public PlayerOneCell, PlayerTwoCell
public togoPlayer1, togoPlayer2
public currentPlayer
public Player1SelectedPieceLocation, Player2SelectedPieceLocation
public PieceCurrentCellNumber
public Cells
public CountDown
public gameMain

public PlayerOneName
public PlayerTwoName
public clearkeyboardbuffer

Extrn received:byte
Extrn SelectClickedPlayer : far
Extrn DrawBoard : far
Extrn DrawCell : far
Extrn CellWidth : byte
Extrn CellHeight : byte
Extrn DrawAll : byte
Extrn SystemTime: word
Extrn getSystemTime: far
Extrn DrawStatusBar: far
Extrn Winner:Byte


Extrn sendPieces:far
Extrn toSendPiece:Byte

Extrn PlayerName:Byte
Extrn otherPlayer:Byte
Extrn OtherName:Byte
Extrn PlayerNameCntr: Byte

Extrn MovePiece : far


Extrn PlayerOneStatus: byte
Extrn PlayerTwoStatus: byte


;=================================================== Maher
Extrn GetPawnToBeUpgraded: far
Extrn PawnCellToBeUpgraded1: word
Extrn PawnCellToBeUpgraded2: word
Extrn KilledKing: byte

Extrn CheckmatePlayer1 : Byte
Extrn CheckmatePlayer2 : Byte
;=================================================== Maher
Extrn InitialColors:Byte
Extrn PlayerOneCellColor:Byte
Extrn PlayerTwoCellColor:Byte

Extrn CheckmatePlayer1: byte
Extrn CheckmatePlayer2: byte

public time
public playerSide


.model small
.stack 64

.data
       DataBuffer                   DB 40 dup(0ffh)
       Cells                        DB 0,5AH,6,2
                                    DB 1,0DAH,4,2
                                    DB 2,5AH,5,2
                                    DB 3,0DAH,3,2
                                    DB 4,2BH,2,2
                                    DB 5,0DAH,5,2
                                    DB 6,5AH,4,2
                                    DB 7,0DAH,6,2
       ; [si + 2] , [si + 3]
                                    DB 8,0DAH,1,2
                                    DB 9,5AH,1,2
                                    DB 10,0DAH,1,2
                                    DB 11,5AH,1,2
                                    DB 12,0DAH,1,2
                                    DB 13,5AH,1,2
                                    DB 14,0DAH,1,2
                                    DB 15,5AH,1,2

                                    DB 16,5AH,0,0
                                    DB 17,0DAH,0,0
                                    DB 18,5AH,0,0
                                    DB 19,0DAH,0,0
                                    DB 20,5AH,0,0
                                    DB 21,0DAH,0,0
                                    DB 22,5AH,0,0
                                    DB 23,0DAH,0,0

                                    DB 24,0DAH,0,0
                                    DB 25,5AH,0,0
                                    DB 26,0DAH,0,0
                                    DB 27,5AH,0,0
                                    DB 28,0DAH,0,0
                                    DB 29,5AH,0,0
                                    DB 30,0DAH,0,0
                                    DB 31,5AH,0,0

                                    DB 32,5AH,0,0
                                    DB 33,0DAH,0,0
                                    DB 34,5AH,0,0
                                    DB 35,0DAH,0,0
                                    DB 36,5AH,0,0
                                    DB 37,0DAH,0,0
                                    DB 38,5AH,0,0
                                    DB 39,0DAH,0,0

                                    DB 40,0DAH,0,0
                                    DB 41,5AH,0,0
                                    DB 42,0DAH,0,0
                                    DB 43,5AH,0,0
                                    DB 44,0DAH,0,0
                                    DB 45,5AH,0,0
                                    DB 46,0DAH,0,0
                                    DB 47,5AH,0,0

                                    DB 48,5AH,1,1
                                    DB 49,0DAH,1,1
                                    DB 50,5AH,1,1
                                    DB 51,0DAH,1,1
                                    DB 52,5AH,1,1
                                    DB 53,0DAH,1,1
                                    DB 54,5AH,1,1
                                    DB 55,0DAH,1,1

                                    DB 56,0DAH,6,1
                                    DB 57,5AH,4,1
                                    DB 58,0DAH,5,1
                                    DB 59,5AH,3,1
                                    DB 60,02H,2,1
                                    DB 61,5AH,5,1
                                    DB 62,0DAH,4,1
                                    DB 63,5AH,6,1

       CountDown                    dw 64 dup(0)                ; count down for pieces on each cell if found
       
       ; Parameters               ; if there is a piece to which player it belongs
       CellNumber                   db ?                        ; Number of the cell to be drawn => [0,63]
       ; which piece is in this cell => 0 if no pieces


       ; Player One Cell Color => 0ffH, player two => 00H
       PlayerOneCell                dw ?
       PlayerTwoCell                dw ?

       CellAddress                  dw ?
       PieceCurrentCellNumber       db ?                        ; the cell number on which the piece is
       currentPlayer                db 1
       
       Player1SelectedPieceLocation dw 0FFFFH                   ; if ffffH it means that no previous cells was selected
       togoPlayer1                  DB 64 dup (0FFH)
       Player2SelectedPieceLocation dw 0FFFFH                   ; if ffffH it means that no previous cells was selected
       togoPlayer2                  DB 64 dup (0FFH)
       ButtonClicked                db ?

       time                         db '00:00',0dh,'$'
       seconds                      db 99

       PlayerOneCntDown             db 3
       PlayerTwoCntDown             db 3


       InitialPositions             db 6,4,5,3,2,5,4,6
       barrier                      db 40 dup('-'),'$'

       CursorRow                    db ?
       CursorColumn                 db ?

       P1ChatRow                    db 16H
       P1ChatColumn                 db 05H

       playerOneChat                db 0, 40*80 dup('`')
       playerTwoChat                db 0, 40*80 dup('$')

       lastSent                     db 0
       lastReceived                 db 0

       clear                        db 26 dup (' ') , '$'

       PlayerOneName                db 'MoA:',16 dup('$')
       playerTwoName                db 'Nil:',16 dup('$')


       chatOneLine                  db 0
       chatTwoLine                  db 0


       playerSide                   db 2                        ; 1 For The bottom Side, 2 for the Top side
       
       PlayerOut                    db 0
.code

gameMain proc far
       ; move es to the graphics memory
                              mov   ax,0A000H
                              mov   es,ax

                              mov   ax,@data
                              mov   ds,ax

                              mov   KilledKing,0

       ; go to graphics mode
                              mov   ah,0
                              mov   al,13h
                              int   10h

                              mov   PlayerOneCell, offset Cells
                              mov   PlayerTwoCell, offset Cells
                              add   PlayerOneCell, 240
                              add   PlayerTwoCell, 16

                              call  ResetGrid



                              mov   currentPlayer,2
                              mov   CellAddress,offset Cells
                              add   CellAddress,4
                              
                              call  DrawBoard

       GameLoop:              
                              cmp   PlayerOut,1
                              je    EndGame

                              call  sendPlayerChat
                              call  recieveChat

                              mov   ah,1
                              int   16h
                              jz    NoKeyPressed
                              
                              cmp   ah,3eh
                              je    PlayerExit

                              mov   ButtonClicked, ah
                             
                              call  inlineChat
                              
       ;   call  MovePlayerOneSelection

                              mov   received,0
                              call  MovePlayerTwoSelection
                              
                              call  GetPawnToBeUpgraded
                              call  UpgradePawn

                              call  SelectClickedPlayer



                              call  clearkeyboardbuffer

       NoKeyPressed:          
                              call  updateCountDowns
                              call  timerDraw
                              cmp   KilledKing,0
                              jne   EndGame

                              jmp   GameLoop
       PlayerExit:            
       ;Check that transmitter holding register is empy
                              mov   dx,3fdh                                         ; line status register
       WaitToSend:            in    al,dx                                           ; Read Line Status
                              And   al, 00100000b
                              jz    WaitToSend
       ; IF EMPTY put the value in transmit data register
                              mov   dx, 3f8h
                              mov   al, '*'                                         ; transmit register
                              out   dx,al

       EndGame:               
                              mov   ah,00H
                              mov   al,03h
                              int   10h
                              
                              mov   Winner,2
                              cmp   KilledKing,1
                              je    WinnerDetermined
                              
                              mov   Winner,1
                              cmp   KilledKing,2
                              je    WinnerDetermined
                              
                              mov   Winner,0
       WinnerDetermined:      
                              
                              retf

gameMain endp

clearkeyboardbuffer proc
                              PUSH  ax
                              mov   ah,0
                              int   16h
                              pop   ax
                              ret
clearkeyboardbuffer endp

ResetGrid proc

                              call  eraseScreen
                              mov   PlayerOut,0

                              mov   playerOneChat,0
                              mov   playerOneChat + 1,'$'
                              mov   playerTwoChat,'$'

                              call  ClearP1Line
                              call  ClearP2Line

                              call  printBarrier

                              call  moveCursor
                            
                              mov   al,PlayerNameCntr

                              mov   P1ChatRow,16H
                              mov   P1ChatColumn,al
                              call  ClearP1Line

                              mov   CheckmatePlayer1,0
                              mov   CheckmatePlayer2,0

                              mov   [time],'0'
                              mov   [time + 1],'0'
                              mov   [time + 2],':'
                              mov   [time + 3],'0'
                              mov   [time + 4],'0'

                              mov cx,3200
                              mov si,offset playerOneChat
                              mov [si],byte ptr 0
                              inc si
clrChat1:
                              mov [si],byte ptr '`'
                              inc si
                              loop clrChat1

                              mov cx,3200
                              mov si,offset playerTwoChat
                              mov [si],byte ptr 0
                              inc si
clrChat2:
                              mov [si],byte ptr '$'
                              inc si
                              loop clrChat2

                              mov lastsent,0
                              mov lastReceived,0


                              mov   cx,64
                              mov   di,offset InitialColors
                              mov   si,offset Cells


       backgroundLp:          
                              mov   al,[di]
                              mov   [si + 1],al
                              mov   [si + 2],byte ptr 0
                              mov   [si + 3],byte ptr 0
                            
                              inc   di
                              add   si,4

                              loop  backgroundLp

                              mov   cx,64
                              mov   di,offset togoPlayer1
                              mov   si,offset togoPlayer2
                              mov   bx,offset CountDown

       ClearToGoAndCountDown: 
                              mov   [si],byte ptr 0ffH
                              mov   [di],byte ptr 0ffH
                              mov   [bx],word ptr 0
                              inc   si
                              inc   di
                              add   bx,2
                              loop  ClearToGoAndCountDown


                              mov   cx,16
                              mov   si,offset PlayerOneStatus
                              mov   di,offset PlayerTwoStatus

                              inc   si
                              inc   di

                              mov   [PlayerOneStatus],1
                              mov   [PlayerTwoStatus],1

       ClearStatus:           
                              mov   [si],byte ptr 0ffH
                              mov   [di],byte ptr 0ffH
                              inc   si
                              inc   di
                              loop  ClearStatus

       

                              mov   Player1SelectedPieceLocation,0fffh
                              mov   Player2SelectedPieceLocation,0fffh



                              mov   cx,8
                              mov   si,offset Cells
                              mov   di,offset InitialPositions
                              mov   ah,2

       Player2InitialPoslp:   
                              mov   al,[di]
                              mov   [si + 2],al
                              mov   [si + 3],ah
                              add   si,4
                              inc   di
                              loop  Player2InitialPoslp


                              mov   cx,8
                              mov   al,1

       Player2Pawslp:         
                              mov   [si+2],al
                              mov   [si+3],ah
                              add   si,4
                              loop  Player2Pawslp
              

                              mov   cx,8
                              mov   si,offset Cells + 192
              
                              mov   al,1
                              mov   ah,1

       Player1Pawslp:         
                              mov   [si+2],al
                              mov   [si+3],ah
                              add   si,4
                              loop  Player1Pawslp

                              mov   cx,8
                              mov   di,offset InitialPositions
                              mov   ah,1

       Player1InitialPoslp:   
                              mov   al,[di]
                              mov   [si + 2],al
                              mov   [si + 3],ah

                              inc   di
                              add   si,4

                              loop  Player1InitialPoslp

                              ret

ResetGrid endp

       ; parameters => toModifyCell, toModifyColor, ModifyBy, ModifyPrevColor       check data for more info
MovePlayerOneSelection proc
       ; parameters
       ; => cell clicked address , button clicked

       ; Reset Cell Color
                              push  ax
                              push  bx
                              push  cx
                              push  dx
                              push  si
                              push  di
                              pushf
       
                                     
                              mov   si,PlayerOneCell

       SelectWhichButton:     
                              mov   al,ButtonClicked
                              mov   di,si

                              add   di,4                                            ; si should be on the current cell
                              cmp   al,20H                                          ; Next Cell On Right if d pressed
                              je    Move
       ; di = si + 4
                              sub   di,8
                              cmp   al,1EH                                          ; Next Cell On Left if a pressed
                              je    Move
       ; di = si - 4
                              add   di,36
                              cmp   al,1FH                                          ; Next Cell On Bottom if w pressed
                              je    Move
       ; di = si + 32
                              sub   di,64
                              cmp   al,11H                                          ; Next Cell On Right if s pressed
                              je    Move

                              jmp   OutOfRange
       ; di = si - 32
       Move:                  
                              cmp   di,offset Cells                                 ; Check if the next Cell is out of the grid
                              jb    OutOfRange

                              mov   ax,offset Cells
                              add   ax, 252

                              cmp   di,ax
                              ja    OutOfRange                                      ; if so exit

       ResetingCellColor:     
                              mov   bx,[PlayerTwoCell]
                              mov   ah,[bx]                                         ; ah = Player 2 Current Cell

                              mov   al,PlayerTwoCellColor
                              cmp   ah,[si]                                         ; Checking if the cell that player 1 came from has player 2 or not
                              je    PlayerTwoHere
                              
                              mov   cl,1


                              push  di
                              push  bx
                                   
                              mov   al,[si]
                              mov   ah,0

                              mov   di,offset CountDown

                              add   di,ax
                              add   di,ax

                              cmp   [di],word ptr 0
                              je    Continue
                              mov   al,00H
                              mov   cl,0

       Continue:              

                              pop   bx
                              pop   di

                              cmp   cl,00H
                              je    PlayerTwoHere
                              
                              

                              mov   bx,offset InitialColors                         ; if no then return cell color to its initial value
                              mov   al,[si]
                              mov   ah,0
                              add   bx,ax                                           ; Go To The Current Cell In Initial colors
                              mov   al,[bx]

       PlayerTwoHere:         
                              mov   [si + 1],al                                     ; Change Previous Cell Color
                              
                              call  kingHandler

                              mov   al,PlayerOneCellColor
                              mov   [di + 1], al
                              mov   PlayerOneCell, di

                              mov   al,30
                              mov   ah,20

                              mov   CellWidth,al
                              mov   CellHeight,ah
                              call  far ptr DrawCell
                              
                              mov   si,di
                              mov   CellWidth,al
                              mov   CellHeight,ah
                              
                              call  far ptr DrawCell
       OutOfRange:            
                              popf
                              pop   di
                              pop   si
                              pop   dx
                              pop   cx
                              pop   bx
                              pop   ax
                              ret

MovePlayerOneSelection endp

MovePlayerTwoSelection proc
       ; parameters
       ; => cell clicked address , button clicked

       ; Reset Cell Color
                              push  ax
                              push  bx
                              push  cx
                              push  dx
                              push  si
                              push  di
                              pushf
       
                              mov   si,PlayerTwoCell

       SelectWhichButton2:    
                              mov   al,ButtonClicked
                              mov   di,si

                              add   di,4                                            ; si should be on the current cell
                              cmp   al,4DH                                          ; Next Cell On Right if left pressed
                              je    Move2
       ; di = si + 4
                              sub   di,8
                              cmp   al,4BH                                          ; Next Cell On Left if right pressed
                              je    Move2
       ; di = si - 4
                              add   di,36
                              cmp   al,50H                                          ; Next Cell On Bottom if up pressed
                              je    Move2
       ; di = si + 32
                              sub   di,64
                              cmp   al,48H                                          ; Next Cell On Right if down pressed
                              je    Move2

                              jmp   OutOfRange
       ; di = si - 32
       Move2:                 
       ResetingCellColor2:    
                              mov   bx,[PlayerOneCell]
                              mov   ah,[bx]                                         ; ah = Player 2 Current Cell

                              mov   al,PlayerOneCellColor
                              cmp   ah,[si]
                              je    PlayerOneHere

                              mov   cl,1
                              push  di
                              push  bx
                                   
                              mov   al,[si]
                              mov   ah,0
                              mov   di,offset CountDown
                              add   di,ax
                              add   di,ax

                              cmp   [di],word ptr 0
                              je    Continue2
                              mov   al,00H
                              mov   cl,0
       Continue2:             
                              pop   bx
                              pop   di


                              cmp   cl,00H
                              je    PlayerOneHere

                              mov   bx,offset InitialColors
                              mov   al,[si]
                              mov   ah,0
                              add   bx,ax                                           ; Go To The Current Cell In Initial colors
                              mov   al,[bx]

       PlayerOneHere:         
                              mov   [si + 1],al
                              call  kingHandler

                              cmp   di,offset Cells
                              jb    OutOfRange2

                              mov   ax,offset Cells
                              add   ax, 252

                              cmp   di,ax
                              ja    OutOfRange2
                              
                              mov   al,PlayerTwoCellColor
                              mov   [di + 1], al
                              mov   PlayerTwoCell, di

                              mov   al,30
                              mov   ah,20

                              mov   CellWidth,al
                              mov   CellHeight,ah
                              call  far ptr DrawCell
                              
                              mov   si,di
                              mov   CellWidth,al
                              mov   CellHeight,ah
                              
                              call  far ptr DrawCell

       OutOfRange2:           
                              popf
                              pop   di
                              pop   si
                              pop   dx
                              pop   cx
                              pop   bx
                              pop   ax
                              ret

MovePlayerTwoSelection endp

kingHandler proc

                              cmp   [si + 2],byte ptr 2
                              jne   NoKingInThisCell

                              
                              mov   al, [si + 3]
                              cmp   al,1
                              jne   PlayerTwoKingHandler

                              

       PlayerOneKingHandler:  
                              cmp   CheckmatePlayer1,byte ptr 1
                              jne   NoKingInThisCell


                              mov   al, 04H
                              mov   [si + 1],al
                              jmp   NoKingInThisCell


       PlayerTwoKingHandler:  
                              cmp   CheckmatePlayer2,byte ptr 1
                              jne   NoKingInThisCell
                              

                              mov   al, 04H
                              mov   [si + 1],al
                              

                              jmp   NoKingInThisCell

       NoKingInThisCell:      

                              ret

kingHandler endp

updateCountDowns proc

                              push  ax
                              push  si
                              push  di
                              push  cx
                              pushf

                              mov   si, offset Cells
                              mov   bx, offset InitialColors

                              call  getSystemTime
                     
                              mov   di,offset CountDown

                              mov   cx,64
       CountDownLoop:         


                              mov   ax,word ptr SystemTime

                              cmp   [di],word ptr 0
                              je    dontReset

                              mov   dl, PlayerOneCntDown
                              mov   dh,byte ptr 0

                              cmp   [si + 3],byte ptr 1
                              je    PlayerOneCounter
                              
                              mov   dl, PlayerTwoCntDown
                              mov   dh,byte ptr 0
       PlayerOneCounter:      




                              sub   ax,word ptr [di]
                              cmp   ax,dx
                              jb    dontReset
       Reset:                 

                              mov   al,PlayerOneCellColor
                              cmp   si,PlayerOneCell
                              je    ColorDone

                              mov   al,PlayerTwoCellColor
                              cmp   si,PlayerTwoCell
                              je    ColorDone

                              mov   al,[bx]

       ColorDone:             
                                   
                              mov   [si + 1],al
                              


                              mov   [di], word ptr 0

                              
                              mov   CellWidth,30
                              mov   CellHeight,20
                              call  DrawCell
       ; call DrawBoard

                              jmp   skipCountDown

       dontReset:             
                                   
       skipCountDown:         
                              add   di,2
                              add   si,4
                              inc   bx
                              loop  CountDownLoop
                                   
                              popf
                              pop   cx
                              pop   di
                              pop   si
                              pop   ax
                              ret
updateCountDowns endp

timerDraw proc

                              mov   ah,3h
                              mov   bh,0h
                              int   10h

                              push  dx

                              mov   dl, 0                                           ; Column
                              mov   dh, 0                                           ; Row
                              mov   bx, 0                                           ; Page number, 0 for graphics modes
                              mov   ah, 2h
                              int   10h

                              mov   ah, 2ch
                              int   21h
                              cmp   dh,byte ptr seconds
                              je    no_change

                              mov   seconds, dh

                              mov   si,offset time+4
                              cmp   [si],byte ptr 57
                              je    sec
                            
                              add   [si],byte ptr 1
                            
                              jmp   skip
                            
       sec:                   
                              mov   [si],byte ptr 48
                            
                              dec   si
                            
                              cmp   [si],byte ptr 53
                              je    min
                            
                              add   [si],byte ptr 1
                            
                              jmp   skip
                            
       min:                   
                            
                              mov   [si],byte ptr 48
                            
                              sub   si,byte ptr 2
                            
                              cmp   [si],byte ptr 57
                              je    min2
                            
                              add   [si],byte ptr 1
                            
                              jmp   skip
                            
       min2:                  
                            
                              mov   [si],byte ptr 48
                            
                              dec   si
                              add   [si],byte ptr 1
                            
                            
                            
       skip:                  
                            
                            
                            
                              mov   ah, 9
                              mov   dx, offset time
                              int   21h
       no_change:             

                              pop   dx

                              mov   CursorRow,dh
                              mov   CursorColumn,dl
                              call  moveCursor

                              ret
timerDraw endp


       ;=================================================== Maher
UpgradePawn proc
                              push  ax
                              push  bx
                              push  cx
                              push  dx
                              push  si
                              push  di
                              pushf

                              cmp   PawnCellToBeUpgraded1,word ptr 0FFFFH
                              je    CheckP2

                              cmp   playerSide,2
                              je    CheckP2

                              mov   di, offset PawnCellToBeUpgraded1
                              mov   si,[PawnCellToBeUpgraded1]
                              mov   bl,[si]
                              
                              
                              mov   al,ButtonClicked

                              cmp   al,3FH
                              jne   not3
                              mov bh,3
                              mov   [si+2],byte ptr 3
                              jmp   endUpgrade
       not3:                  

                              cmp   al,40H
                              jne   not4
                              mov   [si+2],byte ptr 4
                              mov bh,4
                              jmp   endUpgrade
       not4:                  

                              cmp   al,41H
                              jne   not5
                              mov   [si+2],byte ptr 5
                              mov bh,5
                              jmp   endUpgrade
       not5:                  

                              cmp   al,42H
                              jne   not6
                              mov   [si+2],byte ptr 6
                              mov bh,6
                              jmp   endUpgrade
       not6:                  

       CheckP2:               
                              cmp   playerSide,1
                              je    NotUpgraded

                              cmp   PawnCellToBeUpgraded2,word ptr 0FFFFH
                              je    NotUpgraded

                              mov   di, offset PawnCellToBeUpgraded2
                              mov   si,[PawnCellToBeUpgraded2]
                              mov   bl,[si]

                              cmp   ah,43H
                              jne   not3P2
                              mov   [si+2],byte ptr 3
                              mov bh,3
                              jmp   endUpgrade
       not3P2:                

                              cmp   ah,44H
                              jne   not4P2
                              mov   [si+2],byte ptr 4
                              mov bh,4
                              jmp   endUpgrade
       not4P2:                

                              cmp   ah,45H
                              jne   not5P2
                              mov   [si+2],byte ptr 5
                              mov bh,5
                              jmp   endUpgrade
       not5P2:                

                              cmp   ah,46H
                              jne   not6P2
                              mov   [si+2],byte ptr 6
                              mov bh,6
                              jmp   endUpgrade
       not6P2:                


                              jmp   NotUpgraded

                              


       endUpgrade:            
                              mov   [toSendPiece],0ffH
                              mov   [toSendPiece+1],bh
                              mov   [toSendPiece+2],bl
                              call  sendPieces

                              mov   [toSendPiece],'`'

                              mov   CellWidth,30
                              mov   CellHeight,20
                              call  DrawCell
                              mov   [di],0FFFFH

       ;   call  far ptr DrawBoard

       NotUpgraded:           
                              popf
                              pop   di
                              pop   si
                              pop   dx
                              pop   cx
                              pop   bx
                              pop   ax
                              ret

UpgradePawn endp

eraseScreen proc

              
                              push  di

                              mov   cx,64000
       ClearScreen:           
                              mov   es:[di],byte ptr 00H
                              inc   di
                              loop  ClearScreen

                              pop   di

                              ret

eraseScreen endp



inlineChat proc

                              cmp   ah,48H
                              je    GamePart
                              cmp   ah,50H
                              je    GamePart
                              cmp   ah,4DH
                              je    GamePart
                              cmp   ah,4BH
                              je    GamePart
                              cmp   ah,0BH
                              je    GamePart
                              cmp   ah,3FH
                              je    GamePart
                              cmp   ah,40H
                              je    GamePart
                              cmp   ah,41H
                              je    GamePart
                              cmp   ah,42H
                              je    GamePart
                              cmp   ah,43H
                              je    GamePart
                              cmp   ah,44H
                              je    GamePart
                              cmp   ah,45H
                              je    GamePart
                              je    GamePart
                              cmp   ah,46H
                              je    GamePart

                              call  P1Chat


       GamePart:              


                              ret
inlineChat endp


P1Chat proc
                              cmp   al,0DH
                              jne   NotEnter

                              call  ClearP1Line
              
                              mov   al,PlayerNameCntr
                              mov   P1ChatColumn,al
                            
                              mov   di,offset playerOneChat
              
                              mov   bl,[di]
                              mov   bh,0
              
                              inc   di
                              add   di,bx

                              mov   [di],byte ptr '$'

                              inc   [playerOneChat]

                              jmp   EndP1Chat

       NotEnter:              
                              mov   dh, P1ChatRow
                              mov   dl, P1ChatColumn

                              cmp   dl,35
                              je    EndP1Chat

                              mov   CursorRow,dh
                              mov   CursorColumn,dl
                              call  moveCursor

       ; button is in ah

                              mov   di,offset playerOneChat
              
                              mov   bl,[di]
                              mov   bh,0
              
                              inc   di
                              add   di,bx

                              mov   [di],al

                              mov   dl,al
                              mov   ah,2
                              int   21h

                              inc   [playerOneChat]

                              inc   P1ChatColumn
       EndP1Chat:             

                              ret

P1Chat endp


ClearP1Line proc

                              
                              mov   CursorRow,16h
                              mov   CursorColumn, 00h
                              call  moveCursor


                              mov   dx,offset PlayerName
                              mov   ah,9
                              int   21h

                              mov   dx,offset clear
                              mov   ah,9
                              int   21h

                              mov   al,PlayerNameCntr

                              mov   CursorRow,16h
                              mov   CursorColumn, al
                              mov   P1ChatRow,16h
                              mov   P1ChatColumn,al
                              call  moveCursor

                              ret
ClearP1Line endp

moveCursor proc
                              push  ax
                              push  dx

                              mov   dh,CursorRow
                              mov   dl,CursorColumn

                              mov   ah,2
                              int   10h

                              pop   dx
                              pop   ax
                              ret
moveCursor endp


sendPlayerChat proc
                              mov   di,offset playerOneChat
                              inc   di
                              mov   al,lastSent
                              mov   ah,0
                              add   di,ax

                              cmp   [di],byte ptr '`'
                              je    SkipSend

       ;Check that transmitter holding register is empy
                              mov   dx,3fdh                                         ; line status register
       Again:                 in    al,dx                                           ; Read Line Status
                              And   al, 00100000b
                              jz    SkipSend
       ; IF EMPTY put the value in transmit data register
                              mov   dx, 3f8h
                              mov   al, [di]                                        ; transmit register
          
                              out   dx,al

                              inc   lastsent
       SkipSend:              
                              ret

sendPlayerChat endp


recieveChat proc
                              mov   di,offset playerTwoChat
                              mov   al,lastReceived
                              mov   ah,0
                              add   di, ax

                           
                              mov   dx,3fdh                                         ; line status register
                              in    al,dx                                           ; Read Line Status
                              And   al,1
                              jz    skipRecieving

       ; IF recieved but in al
                              mov   dx, 3f8h                                        ; reciving register
                              in    al,dx
                              
                              mov   PlayerOut,1
                              cmp   al,'*'
                              je    skipRecieving
                              mov   PlayerOut,0
                              

                              cmp   al,'`'
                              jne   NotPieceRec
                              
                              call  pieceReceived
                              jmp   skipRecieving

       NotPieceRec:           

                              cmp al,0ffH
                              jne NotPromotion
                              
                              call promotionReceived
                              jmp skipRecieving
       NotPromotion:


                              mov   [di],al
                              inc   lastReceived

                              cmp   al,'$'
                              jne   skipRecieving
                           
                              call  ClearP2Line
                              mov   lastReceived,00H
       skipRecieving:         
                              ret

recieveChat endp

ClearP2Line proc

                              mov   ah,3
                              mov   bh,0
                              int   10h

                              push  dx

                              mov   dl,17H
                              mov   dh,00H

                              mov   CursorRow,dl
                              mov   CursorColumn,dh
                              call  moveCursor


                              mov   dx,offset clear
                              mov   ah,9
                              int   21h

                              mov   dl,17H
                              mov   dh,00H

                              mov   CursorRow,dl
                              mov   CursorColumn,dh
                              call  moveCursor

                              mov   dx,offset OtherName
                              mov   ah,9
                              int   21h

                              mov   dx,offset playerTwoChat
                              mov   ah,9
                              int   21h

                              pop   dx

                              mov   CursorRow,dh
                              mov   CursorColumn,dl
                              call  moveCursor
                              ret
ClearP2Line endp

pieceReceived proc
                              mov   ah,3h
                              mov   bh,0h
                              int   10h
                              push  dx
       getFirstPiece:         
                              mov   dx,3fdh                                         ; line status register
                              in    al,dx                                           ; Read Line Status
                              And   al,1
                              jz    getFirstPiece

       ; IF recieved but in al
                              mov   dx, 3f8h                                        ; reciving register
                              in    al,dx
                              
                              mov   ah,0
                              mov   bl,4
                              mul   bl

                              cmp   playerSide,1
                              jne   PlayerOneMoved
       PlayerTwoMoved:        
                              mov   Player2SelectedPieceLocation,offset cells
                              add   Player2SelectedPieceLocation,ax
                              mov   currentPlayer,2
                              mov   otherPlayer,1
                              jmp   SecondPiece
       PlayerOneMoved:        
                              mov   Player1SelectedPieceLocation,offset cells
                              add   Player1SelectedPieceLocation,ax
                              mov   currentPlayer,1
                              mov   otherPlayer,2
       SecondPiece:           
                              mov   dx,3fdh                                         ; line status register
                              in    al,dx                                           ; Read Line Status
                              And   al,1
                              jz    SecondPiece

       ; IF recieved but in al
                              mov   dx, 3f8h                                        ; reciving register
                              in    al,dx
                              
                              mov   ah,0
                              mov   bl,4
                              mul   bl

                              mov   si,offset cells
                              add   si,ax

                              mov   received,1
                              call  MovePiece
                             
                              pop   dx

                              mov   CursorRow,dh
                              mov   CursorColumn,dl
                              call  moveCursor


                              ret

pieceReceived endp

promotionReceived proc
       getFirstPos:         
                              mov   dx,3fdh                                         ; line status register
                              in    al,dx                                           ; Read Line Status
                              And   al,1
                              jz    getFirstPos

       ; IF recieved but in al
                              mov   dx, 3f8h                                        ; reciving register
                              in    al,dx

                              mov bl,al
       getSecondPos:         
                              mov   dx,3fdh                                         ; line status register
                              in    al,dx                                           ; Read Line Status
                              And   al,1
                              jz    getSecondPos

       ; IF recieved but in al
                              mov   dx, 3f8h                                        ; reciving register
                              in    al,dx


                              mov si,offset Cells
                              mov ah,0

                              add si,ax
                              add si,ax
                              add si,ax
                              add si,ax

                              mov [si + 2],bl

                              mov CellWidth,30
                              mov CellHeight,20
                              call DrawCell
                              ret
promotionReceived endp

printBarrier proc
                              mov   CursorRow,15h
                              mov   CursorColumn,00h
                              call  moveCursor

                              mov   dx,offset barrier
                              mov   ah,9
                              int   21h

                              ret

printBarrier endp



end gameMain