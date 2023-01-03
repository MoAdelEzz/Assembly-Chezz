public Winner
public PlayerNameCntr
public OtherNameLength

Extrn gameMain: far
Extrn txtmode: far
Extrn clearkeyboardbuffer : far

Extrn KilledKing: byte
Extrn EraseAnnounce:byte

Extrn PlayerOneName:byte
Extrn PlayerTwoName:byte

Extrn playerSide:byte

public PlayerName
public OtherName

Extrn otherPlayer:Byte
Extrn getSystemTime:far
Extrn SystemTime:word

.model small
.stack 64

.data

    nameRequest           db 'Please Enter Your Name','$'
    SelectedMode          db 0
    ChattingMode          db 'To Start Chatting Press F1','$'
    GameMode              db 'To Start The Game Press F2','$'
    EndMode               db 'To End The Program Press ESC','$'

    GameInvSent           db 'Game Invitation Was Sent                                                                             ','$'
    ChatInvSent           db 'Chat Invitation Was Sent                                                                             ','$'

    GameInvRef            db ' Refused Game Invitation                                                                             ','$'
    ChatInvRef            db ' Refused Chat Invitation                                                                             ','$'


    RecieveChatInvitation db 'The Other Player Invite You to Start Chatting ------ Press (Y) to Accept ------ Press (N) to Refuse','$'
    RecieveGameInvitation db 'The Other Player Invite You to Start The Game ------ Press (Y) to Accept ------ Press (N) to Refuse','$'
    EndGameMessege        db 'The Other Has End The Game                                                                             ','$'
    PressedKey            db ?
    AnswerKey             db ?


    Welcome               db 'Welcome To Chezz','$'
    
    PlayerOneWon          db "- Player One Won The Game",'$'
    PlayerTwoWon          db "- Player Two Won The Game",'$'
    EraseWinner           db "                         ",'$'
    
    Eraser                db '                                                                         ','$'

    Winner                db 0

    ; PlayerName        db 16 dup('$')
    buff1                 db 5 dup("$")
    PlayerName            db 17 dup('$')
    PlayerNameCntr        db 0

    OtherNameReceived     db 0
    buff2                 db 5 dup('$')
    OtherName             db 17 dup('$')
    OtherNameLength       db 0


    myMessage             db 80 dup(' ')
    OtherMessage          db 80 dup(' ')
    Response              db ?

    lastTime              dw ?

    invRefused            db 'Invitation was refused                       ','$'

    waiting               db "waiting for another player ...",'$'
.code

main proc far
                          mov  ax,@data
                          mov  ds,ax

                          call lineConfiguration

                          mov  ah,00H
                          mov  al,03h
                          int  10h

                          call GetPlayerName
                          call waitingForOtherPlayer
                          call SendName

                          mov  ah,00H
                          mov  al,03h
                          int  10h

                          call sendPlayerName

                          call DrawScreen
    getmode:              
                          mov  ah,1
                          int  16h
                          jz   con
                          call clearkeyboardbuffer
    con:                  
                          push ax

                          call RecieveInvitation

                          cmp  ah,3bh                              ;F1 pressed
                          jne  NotChatting
                          mov  PressedKey,ah
                          call SendInvitation
                          mov  SelectedMode,1

    NotChatting:          
                          cmp  ah,3ch                              ;F2 pressed
                          jne  NotGame
                          mov  PressedKey,ah
                          call SendInvitation
   

    NotGame:              

                          pop  ax
                          cmp  al,1bh                              ;ESC pressed
                          jne  NotESC
                          mov  PressedKey,al
                          call SendInvitation
                          jmp  endProgram
    NotESC:               
    
                        
                          jmp  getmode

    endProgram:           
                          mov  ah,00H
                          mov  al,03h
                          int  10h
    
                          MOV  AH, 4CH
                          MOV  AL, 01                              ;your return code.
                          INT  21H

main endp


SendInvitation PROC
                    
  
                          mov  dx , 3FDH                           ; Line Status Register
    AGAIN2:               
                          In   al , dx                             ;Read Line Status
                          AND  al , 00100000b
                          JZ   AGAIN2

                          mov  dx , 3F8H                           ; Transmit data register
                          mov  al,PressedKey
                          out  dx , al

                          cmp  PressedKey,3bh                      ;F1
                          jne  s1

                          mov  dh, 11h
                          mov  dl, 0
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          mov  ah, 9
                          mov  dx, offset ChatInvSent
                          int  21h
                          jmp  getAnswer2
    s1:                   
                          cmp  PressedKey,3ch                      ;F2
                          jne  s3

                          mov  dh, 12h
                          mov  dl, 0
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          mov  ah, 9
                          mov  dx, offset GameInvSent
                          int  21h
                          jmp  getAnswer2

    s3:                   
                          cmp  PressedKey,1bh                      ;Esc
                          je   eproc1
                    

    getAnswer2:           
                          mov  dx , 3FDH                           ; Line Status Register

    CHK2:                 
                          in   al , dx
                          AND  al , 1
                          JZ   CHK2

                          mov  dx , 03F8H
                          in   al , dx
                          mov  AnswerKey,al

                          cmp  AnswerKey,21
                          je   yes
                          cmp  AnswerKey,49
                          je   no

                          jmp  eproc1
    yes:                  
                          cmp  PressedKey,3bh                      ;F1
                          jne  not1
                          call txtmode
                          call DrawScreen
    not1:                 
                          cmp  PressedKey,3ch                      ;F2
                          jne  no
                          mov  playerSide,1
                          call gameMain
                          call DrawScreen

    no:                   
  

                          cmp  PressedKey,3bh                      ;F1
                          jne  s2

                          mov  dh, 11h
                          mov  dl, 0
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          mov  ah, 9
                          mov  dx, offset ChatInvRef
                          int  21h
    s2:                   
                          cmp  PressedKey,3ch                      ;F2
                          jne  eproc1

                          mov  dh, 12h
                          mov  dl, 0
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          mov  ah, 9
                          mov  dx, offset GameInvRef
                          int  21h
  
  
    eproc1:               
                          mov  PressedKey,byte ptr 0
                          mov  AnswerKey,byte ptr 0
                          ret

SendInvitation ENDP

                    
RecieveInvitation PROC
                    
  
                          mov  dx , 3FDH                           ; Line Status Register

               
                          in   al , dx
                          AND  al , 1
                          JNZ  t1
                          jmp  eproc
    t1:                   

                          mov  dx , 03F8H
                          in   al , dx
                    

                          cmp  al,3bh                              ;F1
                          jnz  notF1
                          mov  PressedKey,al

                          mov  dh, 11h
                          mov  dl, 0
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          mov  ah, 9
                          mov  dx, offset RecieveChatInvitation
                          int  21h
                          jmp  getAnswer
                    
    notF1:                
  
                          cmp  al,3ch                              ;F2
                          jnz  notF2
                          mov  PressedKey,al

                          mov  dh, 12h
                          mov  dl, 0
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          mov  ah, 9
                          mov  dx, offset RecieveGameInvitation
                          int  21h
                          jmp  getAnswer
                    
    notF2:                
                          cmp  al,1bh                              ;Esc
                          jnz  notEsc1
                          mov  PressedKey,al

                          mov  dh, 12h
                          mov  dl, 0
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          mov  ah, 9
                          mov  dx, offset EndGameMessege
                          int  21h
    notEsc1:              

                          jmp  eproc

    getAnswer:            
                          mov  ah,0
                          int  16h
                          cmp  ah,21
                          je   sendchar
                          cmp  ah,49
                          je   sendchar
                          jmp  getAnswer

    sendchar:             
    ;send the answer of the invitation
                          push ax

                          mov  dx , 3FDH                           ; Line Status Register
    AGAIN3:               
                          In   al , dx                             ;Read Line Status
                          AND  al , 00100000b
                          JZ   AGAIN3

                          mov  dx , 3F8H                           ; Transmit data register
                          mov  al,ah
                          out  dx , al

                          pop  ax

                          cmp  ah,21
                          jne  n1
                          cmp  PressedKey,3bh
                          jne  n3
                          call txtmode
                          call DrawScreen
    n3:                   
                          cmp  PressedKey,3ch
                          jne  n1
                          call gameMain
                          call DrawScreen
    n1:                   
                          cmp  ah,49
                          jne  n2

    n2:                   

    eproc:                
                          mov  PressedKey,byte ptr 0
                    
                          ret
RecieveInvitation ENDP



GetPlayerName proc

                          mov  dh, 12
                          mov  dl, 26
                          mov  bh, 0
                          mov  ah, 2
                          int  10h
                 
                          mov  dx,offset nameRequest
                          mov  ah,9
                          int  21h
                  
                          mov  dh, 15
                          mov  dl, 26
                          mov  bh, 0
                          mov  ah, 2
                          int  10h


                          mov  di,offset PlayerName
                          mov  PlayerNameCntr,0
                          mov  bl, PlayerNameCntr
                          mov  bh, 0
    GetNameLp:            
                          mov  ah,0
                          int  16h
                          jz   GetNameLp

                          cmp  ah,0eH
                          jne  NotBackspace1


                          call backspaceHandler
                          jmp  IgnoreChar

    NotBackspace1:        
                          cmp  al,0DH
                          jne  CheckCharacter

                          cmp  bx,3
                          jb   IgnoreChar

                          mov  [di+bx],byte ptr ':'
                          mov  [di+bx + 1],byte ptr '$'
                          add  PlayerNameCntr,2
                          jmp  EndFunName

    ;    TODO
    ;    Here You Should Check if the input ah => scan code is a number then if the PlayerNameCounter = 0 ignore
    ;    it and if else you must only accept letters and numbers
    ;    letters => [04H, 1DH] , Numbers => [1EH,27H]
    ;    name should be between 3 chars to 15 chars
    ;    if he pressed enter check if the name length is between 3 and 15
    ;    if name length is stop taking input but wait for enter
    ;    save it in PlayerName

    CheckCharacter:       
                          cmp  al, 61H
                          jb   IgnoreChar

                          cmp  al,7AH
                          ja   IgnoreChar

                          jmp  TakeChar
    TakeChar:             
                          cmp  bx,15
                          je   IgnoreChar

                          mov  [di+bx], al
                          inc  bx
                          inc  PlayerNameCntr

                          mov  dl,al
                          mov  ah,2
                          int  21h
    IgnoreChar:           


                          jmp  GetNameLp
    ;=======================================================================================================
    ; Loop End Here
    EndFunName:           
    ; call sendPlayerName

                          ret

GetPlayerName endp

sendPlayerName proc
                          mov  si,offset buff1

                          mov  cl,PlayerNameCntr
                          mov  ch,0

                          inc  cx
    sendNamelp:           
    ;Check that transmitter holding register is empy
                          mov  dx,3fdh                             ; line status register
    Again33:              in   al,dx                               ; Read Line Status
                          And  al, 00100000b
                          jz   Again33
    ; IF EMPTY put the value in transmit data register
                          mov  dx, 3f8h
                          mov  al,[si]
                          out  dx,al
                          inc  si
                          loop sendNamelp
                          ret
sendPlayerName endp


DrawScreen proc
                          mov  dh, 3
                          mov  dl, 30
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          mov  ah, 9
                          mov  dx, offset Welcome
                          int  21h


                          mov  dh, 7h
                          mov  dl, 26
                          mov  bh, 0
                          mov  ah, 2
                          int  10h
                       
                          mov  ah, 9
                          mov  dx, offset ChattingMode
                          int  21h
                
                
                
                          mov  dh, 0Ah
                          mov  dl, 26
                          mov  bh, 0
                          mov  ah, 2
                          int  10h
                           
                
                          mov  ah, 9
                          mov  dx, offset GameMode
                          int  21h
                
                
                
                          mov  dh, 0Dh
                          mov  dl, 25
                          mov  bh, 0
                          mov  ah, 2
                          int  10h
                           
                
                          mov  ah, 9
                          mov  dx, offset EndMode
                          int  21h

                          mov  dh, 10h
                          mov  dl, 0
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          mov  ah,9                                ;Display
                          mov  bh,0                                ;Page 0
                          mov  al,'='                              ;character =
                          mov  cx,80                               ;80 times
                          mov  bl,0Fh                              ;Green (A) on white(F) background
                          int  10h

                          call PrintWinner

                                 

                 
                          ret
DrawScreen endp

PrintWinner proc
                 
                          mov  dh, 11h
                          mov  dl, 0
                          mov  bh, 0
                          mov  ah, 2
                          int  10h

                          cmp  Winner,0
                          je   NoWinner
                 
                          mov  dx,offset PlayerOneWon
                          cmp  Winner,1
                          je   P1Won
                          mov  dx,offset PlayerTwoWon
    P1Won:                
                 
                          mov  ah, 9
                          int  21h


    NoWinner:             
                 
                          ret

PrintWinner endp

lineConfiguration proc
    ; Set Divisor Latch Access Bit
                          mov  dx,3fbh                             ; line control register
                          mov  al,10000000b
                          out  dx,al


    ; Set LSB Byte of the baud rate divisor latch register
                          mov  dx,3f8h
                          mov  al,0ch
                          out  dx,al



    ; Set MSB Byte of the baud rate divisor latch register
                          mov  dx ,3f9h
                          mov  al,00H
                          out  dx,al

    ; Port Configurations
                          mov  dx,3fbh
                          mov  al,00000011b
    ; 0 Access To Revcive Transmit Buffers
    ; 0 Set Break Disabled
    ; 011 Even Parity
    ; 0 One Stop Bit
    ; 11 8Bits
                          out  dx,al


                          ret
lineConfiguration endp

backspaceHandler proc
                          push bx
                          mov  ah,3h
                          mov  bh,0h
                          int  10h
                          pop  bx

    ; mov  bx,dx

    ; dl -> column
    ; dh -> row
                          cmp  PlayerNameCntr,0
                          je   BackspaceHandeled2

                          mov  al,dl
                          sub  al,3
                          mov  ah,0

                          mov  di,offset PlayerName
                          add  di,ax
                          mov  [di],byte ptr ' '


                          dec  dx

                          mov  ah,2
                          int  10h

                          mov  dl,' '
                          mov  ah,2
                          int  21h

                          push bx
                          mov  ah,3h
                          mov  bh,0h
                          int  10h
                          pop  bx

                          dec  dx
                          dec  PlayerNameCntr
                          dec  bx

                          mov  ah,2
                          int  10h

    BackspaceHandeled2:   
                          ret
backspaceHandler endp



waitingForOtherPlayer proc
                          mov  ah,0
                          mov  al,3
                          int  10h

                          mov  dx,offset waiting
                          mov  ah,9
                          int  21h
                          ret
waitingForOtherPlayer endp


SendName proc

                          push si
                          push cx
                          push dx

    clr:                  
                          mov  dx,3fdh                             ; line status register
                          in   al,dx                               ; Read Line Status
                          And  al,1
                          jz   clrd
    ; IF recieved but in al
                          mov  dx, 3f8h                            ; reciving register
                          in   al,dx

    clrd:                 

                          mov  si,offset buff1
                          mov  di,offset buff2
                          mov  cx,22
    sendNextChar:         
    ;Check that transmitter holding register is empy
                          mov  dx,3fdh                             ; line status register
    Wait2:                in   al,dx                               ; Read Line Status
                          And  al, 00100000b
                          jz   Wait2
    ; IF EMPTY put the value in transmit data register
                          mov  dx, 3f8h
                          mov  al,[si]
                          out  dx,al

    WaitCharacter:        
                          mov  dx,3fdh                             ; line status register
                          in   al,dx                               ; Read Line Status
                          And  al,1
                          jz   WaitCharacter
    ; IF recieved but in al
                          mov  dx, 3f8h                            ; reciving register
                          in   al,dx

                          mov  [di],al

                          inc  si
                          inc  di
                          cmp  al,byte ptr '$'
                          je   dontInc

                          INC  OtherNameLength


    dontInc:              
                          loop sendNextChar
                          pop  dx
                          pop  cx
                          pop  si
                          ret
SendName endp

end main