Extrn PlayerName:byte
Extrn OtherName:byte

public txtmode


.model small
.stack 64
.data

    linetowrite      db 0
    lineCnt          db 0
    lineCnt2         db 0

    linetoshow1      db 0
    linetoshow2      db 0

    chatplayer1      db 80*80 dup('$')
    lastCharSent     dw 0

    chatplayer2      db 80*80 dup('$')

    lastReceived     dw 0                  ; totally
    lastReceivedLine db 0                  ; for one line, if 80 draw the line

    currentLine      db 80 dup(' ')
    currentIndex     db 0
    lastIndex        db 0

    barrier          db 80 dup('='),'$'


    CursorRow        db ?
    CursorColumn     db ?

    blank            db 80 dup(' '),'$'

    P1ChatRow        db 23
    P1ChatColumn     db 3
    
    mousePos         db 1
    otherPlayerOut db 0


.code

txtmode proc far

                        mov  ax,@data
                        mov  ds,ax

                        mov  ax,0b800h
                        mov  es,ax

                        mov  ah,0
                        mov  al,3
                        int  10h


                        mov  ax,1
                        int  33h

                        call resetChat

                        mov  CursorRow,11
                        mov  CursorColumn,0
                        call printBarrier

                        mov  CursorRow,22
                        mov  CursorColumn,0
                        call printBarrier

    ; call drawchat1

    input1:             
    
                        cmp otherPlayerOut,1
                        je TerminateChat

                        call sendChat
                        call receiveChat
                        
                        mov  ah,1
                        int  16h
                        jz   input1

                        cmp  ah,3DH
                        je   Endtxtmd

                        call inputHandler
                        call clearkeyboardbuffer
                        jmp  input1

    Endtxtmd:           
   
    ;Check that transmitter holding register is empy
                        mov  dx,3fdh                     ; line status register
    WaitForEmpty:              in   al,dx                       ; Read Line Status
                        And  al, 00100000b
                        jz   WaitForEmpty

    ; IF EMPTY put the value in transmit data register
                        mov  dx, 3f8h
                        mov  al, byte ptr '$'
                        out  dx,al
    TerminateChat:

                        mov ah,0
                        mov al,3
                        int 10h

                        retf
    
txtmode endp

clearkeyboardbuffer proc
                        PUSH ax
                        mov  ah,0
                        int  16h
                        pop  ax
                        ret
clearkeyboardbuffer endp

printBarrier proc
                        call moveCursor

                        mov  dx,offset barrier
                        mov  ah,9
                        int  21h

                        ret
printBarrier endp

inputHandler proc

                        cmp  ah,0eH
                        jne  NotBackspace
                        call backspaceHandler
                        jmp  endHandler
    NotBackspace:       
                        cmp  ah,4BH
                        je   Arrows
                        cmp  ah,4DH
                        je   Arrows

                        jmp  NotArrowsLeftRight
    Arrows:             
                        call ArrowsHandler
                        jmp  endHandler
    NotArrowsLeftRight: 

                        call mouseLoc

                        cmp  ah,48H
                        jne  NotArrowUp

                        cmp  mousePos,1
                        jne  P2ScrollUp
    P1ScrollUp:         
                        cmp  linetoshow1,0
                        je   skipScrollUp
                        dec  linetoshow1
                        call drawchat1
                        jmp  skipScrollUp
    P2ScrollUp:         
                        cmp  linetoshow2,0
                        je   skipScrollUp
                        dec  linetoshow2
                        call drawchat2

    skipScrollUp:       
                        jmp  endHandler
    NotArrowUp:         

                        cmp  ah,50H
                        jne  NotArrowDown
                        
                        cmp  mousePos,1
                        jne  P2ScrollDown
    P1ScrollDown:       
                        mov  al,linetowrite
                        sub  al,linetoshow1

                        cmp  al,9
                        jbe  skipScrollDown

                        inc  linetoshow1
                        call drawchat1
                        jmp  skipScrollDown
    
    P2ScrollDown:       
                        mov  al,lineCnt2
                        sub  al,linetoshow2

                        cmp  al,9
                        jbe  skipScrollDown

                        inc  linetoshow2
                        call drawchat2
    
    skipScrollDown:     
                        jmp  endHandler
    NotArrowDown:       

                        cmp  al,0DH
                        je   Cont
                        jmp  NotEnter
    Cont:               

              
                        mov  si,offset currentLine
                        mov  di,offset chatplayer1
              
                        mov  al,linetowrite
                        mov  ah,0
                        mov  bl,80
                        mul  bl

                        add  di,ax

                        mov  cx,79
    CpyStr:             
                        mov  al,[si]
                        mov  [di],al
                        mov  [si],byte ptr ' '
              
                        inc  si
                        inc  di
              
                        loop CpyStr

                        mov  [di],byte ptr '`'
              
                        mov  currentIndex,0
                        mov  lastIndex,0

                        mov  P1ChatRow,23
                        mov  P1ChatColumn,3

                        mov  CursorRow,23
                        mov  CursorColumn,0
                        call moveCursor
                        call drawBlank

                        mov  CursorRow,23
                        mov  CursorColumn,0
                        call moveCursor
              
                        mov  ah,2

                        mov  dl,'='
                        int  21h

                        mov  dl,'>'
                        int  21h

                        mov  dl,' '
                        int  21h

                        inc  linetowrite
                        inc  lineCnt

                        cmp  lineCnt,byte ptr 9
                        jbe  DontScrool
              
                        inc  linetoshow1
    DontScrool:         
                        call drawchat1

                        mov  CursorRow,23
                        mov  CursorColumn,3
                        call moveCursor

                        jmp  endHandler

    NotEnter:           
                        cmp  ah,0Eh
                        je   endHandler

                        mov  dh, P1ChatRow
                        mov  dl, 3
                        add  dl, currentIndex

                        cmp  dl,70
                        je   endHandler

                        mov  CursorRow,dh
                        mov  CursorColumn,dl
                        call moveCursor

    ; button is in ah

                        mov  di,offset currentLine
              
                        mov  bl,currentIndex
                        mov  bh,0
              
                        inc  di
                        add  di,bx

                        mov  [di],al

                        mov  dl,al
                        mov  ah,2
                        int  21h

                        inc  currentIndex
                        inc  lastIndex
                        inc  P1ChatColumn
    endHandler:         
                        ret
inputHandler endp

sendChat proc
                        mov  di, offset chatplayer1
                        mov  ax,lastCharSent
                        add  di,ax
                        
                        cmp  [di],byte ptr '$'
                        je   DontSend

    ;Check that transmitter holding register is empy
                        mov  dx,3fdh                     ; line status register
    Again:              in   al,dx                       ; Read Line Status
                        And  al, 00100000b
                        jz   DontSend

    ; IF EMPTY put the value in transmit data register
                        mov  dx, 3f8h
                        mov  al, [di]
                        out  dx,al
                        add  lastCharSent,1
    DontSend:           

    EndSending:         

                        ret

sendChat endp

receiveChat proc

                        mov  dx,3fdh                     ; line status register
                        in   al,dx                       ; Read Line Status
                        And  al,1
                        jz   SkipReciver
                    
                        mov  dx, 3f8h                    ; reciving register
                        in   al,dx

                        mov otherPlayerOut,1
                        cmp al,byte ptr '$'
                        je SkipReciver

                        mov otherPlayerOut,0

                        mov  di,offset chatplayer2
                        mov  bx, lastReceived
                        add  di,bx

                        mov  [di],al

                        add  lastReceived,1
                        inc  lastReceivedLine

                        cmp  [di],byte ptr '`'
                        jne  NotFullLine

                        inc  lineCnt2
                        cmp  lineCnt2,9
                        jbe  DontScrool2
                        inc  linetoshow2
    DontScrool2:        

                        call drawchat2
    NotFullLine:        

    SkipReciver:        
                        ret
receiveChat endp

drawchat1 proc
                        mov  CursorColumn,0

                        mov  CursorRow,9
                        mov  cl,lineCnt

                        cmp  cl,9
                        jbe  FineC
                        mov  cl,9
    FineC:              
                        sub  CursorRow,cl
                        inc  CursorRow
                        mov  ch,0
                        call moveCursor
    LocationHandled:    
                        mov  di,offset chatplayer1

                        mov  al,linetoshow1

                        mov  ah,0
                        mov  dl,80
                        mul  dl

                        add  di,ax
    printshowedchat:    
                        mov  ah,2
                        mov  dl,'-'
                        int  21h
                        mov  dl,' '
                        int  21h
                        push cx

                        mov  cx,78
    printLine:          
                        mov  dl,[di]

                        cmp  dl,byte ptr '`'
                        jne  IgnoreChar
                        mov  dl,' '
    IgnoreChar:         
                        mov  ah,2
                        int  21h
                        inc  di
                        loop printLine

                        pop  cx
                        add  di,2
                        loop printshowedchat

                        ret
drawchat1 endp

drawchat2 proc
                        mov  CursorColumn,0
                        mov  CursorRow,21

                        mov  cl,lineCnt2

                        cmp  cl,9
                        jbe  FineC2
                        mov  cl,9
    FineC2:             
                        sub  CursorRow,cl
                        inc  CursorRow
                        mov  ch,0

                        mov  bl,CursorRow
                        mov  bh,CursorColumn

                        call moveCursor
    LocationHandled2:   
                
                        mov  di,offset chatplayer2

                        mov  al,linetoshow2

                        mov  ah,0
                        mov  dl,80
                        mul  dl

                        add  di,ax

    printshowedchat2:   
                        mov  CursorRow,bl
                          
                        mov  ah,2
                        mov  dl,'='
                        int  21h
                        mov  dl,' '
                        int  21h

                        push cx
                        mov  CursorColumn,2
                        call moveCursor
                        mov  cx,78
    printLine2:         
                        mov  dl,[di]

                        mov  ah,2
                        int  21h
                        
                        inc  di
                        loop printLine2

                        pop  cx
                        add  di,2
                        
                        inc  bl
                        loop printshowedchat2

                        ret
drawchat2 endp


moveCursor proc
                        push ax
                        push dx

                        mov  dh,CursorRow
                        mov  dl,CursorColumn

                        mov  ah,2
                        int  10h

                        pop  dx
                        pop  ax
                        ret
moveCursor endp


drawBlank proc
                        mov  dx,offset blank
                        mov  ah,9
                        int  21h
                        ret
drawBlank endp


mouseLoc proc

                        push ax
                        push cx
                        push dx

                        mov  ax,3
                        int  33h

                        mov  mousePos,1
                        cmp  dl,64H
                        jb   Determined
                        mov  mousePos,2
    Determined:         

                        pop  dx
                        pop  cx
                        pop  ax
                        ret

mouseLoc endp

backspaceHandler proc
                        mov  ah,3h
                        mov  bh,0h
                        int  10h

    ; mov  bx,dx

    ; dl -> column
    ; dh -> row

                        cmp  dh,23
                        jne  BackspaceHandeled

                        cmp  dl,3
                        je   BackspaceHandeled

                        mov  al,dl
                        sub  al,3
                        mov  ah,0

                        mov  di,offset currentLine
                        add  di,ax
                        mov  [di],byte ptr ' '


                        dec  dx

                        mov  ah,2
                        int  10h

                        mov  dl,' '
                        mov  ah,2
                        int  21h

                        mov  ah,3h
                        mov  bh,0h
                        int  10h

                        dec  dx
                        dec  currentIndex

                        mov  ah,2
                        int  10h

    BackspaceHandeled:  
                        ret
backspaceHandler endp

ArrowsHandler proc
                        push ax

                        mov  ah,3h
                        mov  bh,0h
                        int  10h

                        pop  ax

                        cmp  ah,4DH
                        jne  CursorToLeft

                        mov  al,currentIndex

                        cmp  al,lastIndex
                        je   EndArrowHandler

                        inc  dx
                        inc  currentIndex

                        mov  ah,2
                        int  10h

                        jmp  EndArrowHandler
    CursorToLeft:       
                        mov  al,currentIndex

                        cmp  al,0
                        je   EndArrowHandler

                        dec  dx
                        dec  currentIndex

                        mov  ah,2
                        int  10h

    EndArrowHandler:    
                        ret
ArrowsHandler endp

resetChat proc

                        mov  cx,6400
                        mov  di,offset chatplayer1
    clrChatOne:         
                        mov  [di],byte ptr '$'
                        inc  di
                        loop clrChatOne

                        mov  cx,6400
                        mov  di,offset chatplayer2
    clrChatTwo:         
                        mov  [di],byte ptr '$'
                        inc  di
                        loop clrChatTwo

                        mov  linetowrite,0
                        mov  lineCnt,0
                        mov  lineCnt2,0
                        mov  linetoshow1,0
                        mov  linetoshow2,0
                        mov  lastCharSent,0
                        mov  lastReceived,0
                        mov  lastReceivedLine,0
                        mov  currentIndex,0
                        mov  lastIndex,0
                        mov  P1ChatRow,23
                        mov  P1ChatColumn,3

                        mov  CursorRow,23
                        mov  CursorColumn,0
                        call moveCursor

                        mov  ah,2

                        mov  dl,'='
                        int  21h
                        mov  dl,'>'
                        int  21h
                        mov  dl,' '
                        int  21h

                        mov  cx,80
                        mov  di,offset currentLine
    clrLine:            
                        mov  [di],byte ptr ' '
                        inc  di
                        loop clrLine
                        call printPlayerOneName
                        call printPlayerTwoName
                        mov otherPlayerOut,0

                        ret

resetChat endp

printPlayerOneName proc
                        push bx
                        push di
                        push ax

                        mov  bx,offset PlayerName
                        mov  di,0
    printNameLp1:       
                        mov  al,[bx]
                        cmp  al,byte ptr '$'
                        je   EndP1Print

                        inc  bx

                        mov  es:[di],al
                        mov  es:[di + 1],byte ptr 02H
                        
                        add  di,2
                        jmp  printNameLp1
    EndP1Print:         
                        pop  ax
                        pop  di
                        pop  bx
                        ret
printPlayerOneName endp

printPlayerTwoName proc
                        push bx
                        push di
                        push ax

                        mov  bx,offset OtherName
                        mov  di,1920
    printNameLp2:       
                        mov  al,[bx]
                        cmp  al,byte ptr '$'
                        je   EndP2Print

                        inc  bx

                        mov  es:[di],al
                        mov  es:[di + 1],byte ptr 04H
                        
                        add  di,2
                        jmp  printNameLp2
    EndP2Print:         
                        pop  ax
                        pop  di
                        pop  bx
                        ret
printPlayerTwoName endp



end txtmode