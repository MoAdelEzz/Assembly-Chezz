public SelectClickedPlayer
;========================================= Maher
public PawnCellToBeUpgraded1
public PawnCellToBeUpgraded2
public GetPawnToBeUpgraded
public KilledKing

public CheckmatePlayer1
public CheckmatePlayer2
public MovePiece
public received
public otherPlayer
;========================================= Maher

Extrn PlayerOneCell : word
Extrn PlayerTwoCell : word
Extrn InitialColors: byte

Extrn togoPlayer1 : byte
Extrn togoPlayer2 : byte

Extrn time: Byte

Extrn currentPlayer : byte
Extrn Player1SelectedPieceLocation : word
Extrn Player2SelectedPieceLocation : word
Extrn PieceCurrentCellNumber : byte
Extrn DrawBoard : far
Extrn Cells : byte


public sendPieces
public toSendPiece

Extrn PlayerOneStatus: byte
Extrn PlayerTwoStatus: byte
Extrn DrawStatusBar: far
Extrn CountDown: word


Extrn DrawCell : far
Extrn CellWidth : byte
Extrn CellHeight : byte


Extrn SystemTime: word
Extrn getSystemTime: far

Extrn RemoveSelections: far
Extrn DrawSelections: far

Extrn EraseOneChecked:far
Extrn EraseTwoChecked:far

Extrn KingOneChecked:far
Extrn KingTwoChecked:far

Extrn playerSide: byte

.model small
.stack 64
.data

       KnightMoves           db 24,40,60,68

       ;========================== variables added by ahmed
       BannedUp              db 0,1,2,3,4,5,6,7,0ffh               ;15 cell && 100 to get out
       BannedDown            db 56,57,58,59,60,61,62,63,0ffh       ;15 cell && 100 to get out
       BannedRight           db 7,15,23,31,39,47,55,63,0ffh        ;15 cell && 100 to get out
       BannedLeft            db 0,8,16,24,32,40,48,56,0ffh         ;15 cell && 100 to get out


       ;BannedUp2                    db 8,9,10,11,12,13,14,15,0ffh ;15 cell && 100 to get out
       ;BannedDown2                 db 48,49,50,51,52,53,54,55,0ffh ;15 cell && 100 to get out
       BannedRight2          db 6,14,22,30,38,46,54,62,0ffh        ;15 cell && 100 to get out
       BannedLeft2           db 1,9,17,25,33,41,49,57,0ffh         ;15 cell && 100 to get out
       KnightBanned          db 0,0,0,0                            ; 1: bannedRight1  2: bannedRight2 3: bannedLeft1 4: bannedLeft
       otherPlayer           db ?
       ;=========================

       
       ;===================== Maher
       kingbannedleft        db ?
       kingbannedright       db ?
       kingbannedup          db ?
       kingbanneddown        db ?

       SelectedPieceLocation dw ?

       PawnCellToBeUpgraded1 dw 0FFFFH
       PawnCellToBeUpgraded2 dw 0FFFFH

       KilledKing            db 0
       ;========================== Maher


       HorseyHere            db 33 dup(0ffH)
       CheckmatePlayer1      db 0
       CheckmatePlayer2      db 0
       Checkmate             db 0
    
       toSendPiece           db '`',?,?
       received db 0
.code


SelectClickedPlayer proc far

                                     push  ax
       ; Parameters
       ; Cell Clicked Address
                                     mov   currentPlayer,1
                                     mov   otherPlayer,2
                                     
                                     cmp playerSide,1
                                     je PlayerSelected

                                     mov   currentPlayer,2
                                     mov   otherPlayer,1

PlayerSelected:

                                     cmp   ah,0BH
                                     je    IsSpace



                                     jmp   NotSpace

       ;==========================================================================================
       IsSpace:                      
                                     mov   si, PlayerTwoCell

       ;==========================================================================================
       PlayerCellSelected:           
                                     
                                     cmp   currentPlayer,2
                                     je    Player2SameCell

                                     cmp   si,Player1SelectedPieceLocation
                                     jne   NotTheSameCell

                                     cmp   [togoPlayer1],0ffH
                                     je    NotTheSameCell

                                     jmp   CloseFunc

       Player2SameCell:              

                                     cmp   si,Player2SelectedPieceLocation
                                     jne   NotTheSameCell
                                     cmp   [togoPlayer2],0ffH
                                     je    NotTheSameCell

                                     

                                     jmp   CloseFunc

       NotTheSameCell:               

                                     mov   bx,offset CountDown

                                     mov   al,[si]
                                     mov   ah,0

                                     add   bx,ax                                     ; Go To The Cell Count Down
                                     add   bx,ax

                                     cmp   [bx],word ptr 0                           ; Check If The Cell Has A Count Down Lock
                                     je    NoCountDown

                                     mov   al,currentPlayer

                                     cmp   [si + 3],al                               ; Check If This Count Down Is On Player Peace
       ; Not Enemy Freezed Piece
                                     jne   NoCountDown

                                     jmp   NotSpace
       NoCountDown:                  

                                     mov   al,[si]
                                     mov   ah,00H
                                     
                                     mov   bx,offset togoPlayer1
                                     
                                     cmp   currentPlayer, 1
                                     je    togoSelected
                                   
                                     mov   bx,offset togoPlayer2


                                     
       togoSelected:                 

       ; Search For The Cell In The to Go Array
       ;=========================================================================================
       checkIfAvailable:             
                                     cmp   al,[bx]
                                     je    found

                                     cmp   [bx],byte ptr 0ffH
                                     jne   FoundNear


                                     jmp   notFound
       FoundNear:                    

                                     inc   bx
                                     jmp   checkIfAvailable
       found:                        
                                     mov received,0
                                     call  far ptr  MovePiece
                                     jmp   CloseFunc
       notFound:                     

                                     cmp   currentPlayer,2
                                     je    setToGo2

                                     mov   di, offset togoPlayer1
                                     jmp   endSetToGo
       setToGo2:                     
                                     mov   di,offset togoPlayer2
       endSetToGo:                   
                                     call  RemoveSelections

                                     mov   dl,currentPlayer
                                   
                                     cmp   [si + 3],dl
                                     je    DontJump
                                     
                                     
                                     jmp   CloseFunc
       DontJump:                     

                                     cmp   currentPlayer,2
                                     je    SelectedPiece2

                                     mov   Player1SelectedPieceLocation,si
                                     jmp   endSelectedPiece2

       SelectedPiece2:               
                                     mov   Player2SelectedPieceLocation,si
       endSelectedPiece2:            

                                     cmp   currentPlayer,2
                                     je    setDIToGo

                                     mov   di,offset togoPlayer1
                                     jmp   endSetDIToGo

       setDIToGo:                    

                                     mov   di,offset togoPlayer2

       endSetDIToGo:                 


       ; check if the cell clicked has piece or not

                                     mov   al, [si + 2]

                                     cmp   al , 0
                                     je    CloseFunc                                 ; NoPiecesFound

                                     call  GetPieceAvilableMove

       CloseFunc:                    

                                     mov   si,Player1SelectedPieceLocation
                                     
                                     cmp   currentPlayer,1
                                     je    DrawChangesInPrev
                                     
                                     mov   si,Player2SelectedPieceLocation
                                     
       DrawChangesInPrev:            
       ;   mov   CellWidth,30
       ;   mov   CellHeight,20
       ;   call  DrawCell
                                     

                                     call  DrawSelections
       NotSpace:                     
                                     pop   ax
                                     retf

SelectClickedPlayer endp

MovePiece proc far

       ; if found then set the previous cell information to have no pieces
       ; move the piece to the cell that the user is standing on it when he clicked space
       ; note : previous cell is at the data variable before to go 1
                                   
                                     mov   di,[Player1SelectedPieceLocation]
                                     mov   bx,[Player2SelectedPieceLocation]
                                     cmp   currentPlayer,1
                                     je    PlayerSelectedPieceDone
                                     
                                     mov   di,[Player2SelectedPieceLocation]
                                     mov   bx,[Player1SelectedPieceLocation]

       PlayerSelectedPieceDone:    

                                    cmp received,1
                                    je DontSend  
                                     mov   al,[di]
                                     mov   ah,[si]
                                   
                                     mov   toSendPiece +1,al
                                     mov   toSendPiece + 2,ah
                                     call far ptr sendPieces

DontSend:
                                     mov   al, [di]
                                     mov   ah,0

                                     push  bx
                                     push  ax

                                     mov   bx,offset InitialColors
                                     add   bx,ax

                                     mov   al,[bx]
                                     mov   [di + 1],al

                                     pop   ax
                                     pop   bx
                                     
                                     mov   al, [di + 2]
                                     mov   ah, [di + 3]

                                     mov   [di + 2],byte ptr 0
                                     mov   [di + 3],byte ptr 0

                                     xchg  [si + 2], al                              ; save eaten piece if any in al
                                     xchg  [si + 3], ah                              ; and its player

                                     cmp   al,2
                                     jne   NoKingEaten

                                     mov   KilledKing,ah
                                     cmp   ah,1
              

       NoKingEaten:                  
                                     
       ; For Count Down
       ;=============================================================================================
       ; Set The Count Down to the cell by saving current time in seconds
       ; and color the cell black
       SettingCountDown:             
                                     push  si
                                     push  di
                                     push  ax

                                     mov   di,si

                                     mov   al,[si]
                                     mov   ah,0
                                     mov   si , offset CountDown

       ; Because it is word
                                     add   si, ax
                                     add   si, ax
                                  
                                     call  getSystemTime
                                     mov   ax,SystemTime
                                     mov   [si], ax

                                     mov   si,di

       ; Changing Cell Color To Black
                                     mov   [si + 1],byte ptr 00H
                                     mov   CellWidth,30
                                     mov   CellHeight,20
                                     call  DrawCell

                                     cmp   currentPlayer,2
                                     je    Player2Reset

                                     mov   Player1SelectedPieceLocation,0ffffH
                                     jmp   DoneReset

       Player2Reset:                 
                                     mov   Player2SelectedPieceLocation,0ffffH
       DoneReset:                    

                                     pop   ax
                                     pop   di
                                     pop   si
                                     
       EndSettingCountDown:          
       
       ;=============================================================================================
       ; Set The Count Down to the cell by saving current time in seconds
       ; and color the cell black
                                     mov   si, di
                                     mov   CellWidth,30
                                     mov   CellHeight,20
                                     call  DrawCell



       ;=============================================================================================

       ; Al now containing eaten piece and ah containing the player
                                     
                                     cmp   KilledKing,0
                                     jne   KingWasKilled


                                     call  ModifyStatus
                                     
                                     mov   si,offset Cells
                                     mov   cx,64
       SearchForKing:                
                                     cmp   [si + 2],byte ptr 2
                                     jne   NotAKing

                                     mov   al,[si + 3]
                                     mov   currentPlayer, al

                                     call  CheckForCheckmate

       NotAKing:                     
                                     add   si,4
                                     loop  SearchForKing

       KingWasKilled: 
                                      
                                     mov   al,otherPlayer
                                     mov   currentPlayer,al
                                     
                                     mov   si,[Player2SelectedPieceLocation]
                                     mov   di,offset togoPlayer2
              
                                     cmp   al,byte ptr 2
                                     je    UpdateNow

                                     mov   si,[Player1SelectedPieceLocation]
                                     mov   di,offset togoPlayer1

       UpdateNow:                    

                                     cmp   si,0FFFFH
                                     je    DontUpdate

                                     call  RemoveSelections
                                     
       ; The Piece Was Eaten
                                     mov   al,otherPlayer
                                     cmp   [si + 3],al
                                     jne   DontUpdate

                                     call  GetPieceAvilableMove
                                     call  DrawSelections
       DontUpdate:                   

                                     retf
MovePiece endp

GetPieceAvilableMove proc
       ; si should be on cell
                            
                                     mov   al, [si + 2]

                                     mov   ah,[si]
                                     mov   PieceCurrentCellNumber,ah

                                     push  di
                            
                                     cmp   al , 1
                                     jne   NotPawn
                                     call  PawnAvilableMoves
                                     jmp   Done
       NotPawn:                      
                            
                                     cmp   al , 2
                                     jne   NotKing
                                     call  KingAvilableMoves
                                     jmp   Done
       NotKing:                      
                            
                                     cmp   al , 3
                                     jne   NotQueen
                                     call  QueenAvilableMoves
                                     jmp   Done
       NotQueen:                     
                            
                                     cmp   al , 4
                                     jne   NotKnight
                                     call  KnightAvilableMoves
                                     jmp   Done
       NotKnight:                    
                            
                                     cmp   al , 5
                                     jne   NotBishop
                                     call  BishopAvilableMoves
                                     jmp   Done
       NotBishop:                    
                            
                                     call  CastleAvilableMoves
       Done:                         
                                     pop   di
                                     ret
GetPieceAvilableMove endp

CheckForCheckmate PROC
                                     push  si
                                     push  di
                                     push  bx
                                     push  cx

                                     mov   checkmate,0

                                     cmp   currentPlayer,1
                                     je    ResetPlayer2
                                     mov   CheckmatePlayer1,0
                                     call  EraseTwoChecked
                                     jmp   strfn

       ResetPlayer2:                 
                                     mov   CheckmatePlayer2,0
                                     call  EraseOneChecked

       strfn:                        

                                     push  si
       DiagonalCheck:                
                                     mov   di,offset HorseyHere

                                     push  si
                                     push  di
                                     push  bx
                                     call  BishopAvilableMoves
                                     pop   bx
                                     pop   di
                                     pop   si

                                     mov   al,[si]
                                     mov   ah,byte ptr 0

                                     mov   bx,offset InitialColors
                                     add   bx,ax
                                     mov   al,[bx]
                                     mov   [si + 1], al


       CheckDiagonalCheckmate:       
cmp[di],byte ptr 0ffh
                                     je    EndDiagonal

                                     mov   al,[di]
                                     mov   ah,0
                                     mov   bx,offset Cells

                                     add   bx,ax
                                     add   bx,ax
                                     add   bx,ax
                                     add   bx,ax

                                     cmp   [bx + 2],byte ptr 3
                                     je    isQueenDiagonal
                                            
                                     cmp   [bx + 2], byte ptr 5
                                     jne   NotDiagonalCheckmate

       isQueenDiagonal:              
                                            
                                     mov   al, currentPlayer
                                     cmp   [bx + 3],al
                                     je    NotDiagonalCheckmate

                                     mov   [si+1],byte ptr 04H

                                     call  SetKingChecked

                                     jmp   EndDiagonal
                                           
       NotDiagonalCheckmate:         
                                     inc   di
                                     jmp   CheckDiagonalCheckmate
       EndDiagonal:                  
                                     pop   si

                                     cmp   checkmate,1
                                     jne   continue
                                     jmp   endCheck
       continue:                     

                                     push  si
       AxisCheck:                    
                                     mov   di,offset HorseyHere

                                     push  si
                                     push  di
                                     push  bx
                                     call  CastleAvilableMoves
                                     pop   bx
                                     pop   di
                                     pop   si

                                     mov   al,[si]
                                     mov   ah,byte ptr 0

                                     mov   bx,offset InitialColors
                                     add   bx,ax
                                     mov   al,[bx]
                                     mov   [si + 1], al


       CheckAxisCheckmate:           
cmp[di],byte ptr 0ffh
                                     je    EndAxis

                                     mov   al,[di]
                                     mov   ah,0
                                     mov   bx,offset Cells

                                     add   bx,ax
                                     add   bx,ax
                                     add   bx,ax
                                     add   bx,ax

                                     cmp   [bx + 2],byte ptr 3
                                     je    isQueenAxis
                                            
                                     cmp   [bx + 2], byte ptr 6
                                     jne   NotAxisCheckmate

       isQueenAxis:                  
                                            
                                     mov   al, currentPlayer
                                     cmp   [bx + 3],al
                                     je    NotAxisCheckmate

                                     mov   [si+1],byte ptr 04H

                                     call  SetKingChecked

                                     jmp   EndAxis
                                           
       NotAxisCheckmate:             
                                     inc   di
                                     jmp   CheckAxisCheckmate
       EndAxis:                      
                                     pop   si

                                     cmp   checkmate,1
                                     jne   continue2
                                     jmp   endCheck
       continue2:                    

                                     push  si
       HorseyPart:                   
                                     mov   di,offset HorseyHere

                                     push  si
                                     push  di
                                     push  bx
                                     call  KnightAvilableMoves
                                     pop   bx
                                     pop   di
                                     pop   si

                                     mov   al,[si]
                                     mov   ah,byte ptr 0

                                     mov   bx,offset InitialColors
                                     add   bx,ax
                                     mov   al,[bx]
                                     mov   [si + 1], al


       CheckHorsey:                  
cmp[di],byte ptr 0ffh
                                     je    EndHorsey

                                     mov   al,[di]
                                     mov   ah,0
                                     mov   bx,offset cells

                                     add   bx,ax
                                     add   bx,ax
                                     add   bx,ax
                                     add   bx,ax

                                     cmp   [bx + 2],byte ptr 4
                                     jne   NotHorsey
                                            
                                     mov   al, currentPlayer
                                     cmp   [bx + 3],al
                                     je    NotHorsey

                                     mov   [si+1],byte ptr 04H

                                     call  SetKingChecked

                                     jmp   EndHorsey
                                           
       NotHorsey:                    
                                     inc   di
                                     jmp   CheckHorsey

       EndHorsey:                    
                                     pop   si

                                     cmp   checkmate,1
                                     jne   continue3
                                     jmp   endCheck
       continue3:                    

                                     push  si
       PawnCheckPart:                
                                     cmp   currentPlayer,1
                                     je    PawnCheckingPlayerOne
                                     jmp   far ptr PawnCheckingPlayerTwo
       PawnCheckingPlayerOne:        
                                     mov   bx,si
                                     mov   cx,8
                                     mov   di,offset BannedRight

       isOnRight:                    
                                     mov   al,[di]
                                     cmp   al,[bx]
                                     jne   NotBanned

                                     jmp   OtherSide

       NotBanned:                    
                                     inc   di
                                     loop  isOnRight

                                     sub   bx,28
                                     cmp   bx,offset Cells
                                     jnb   DontJumpEnd
                                     jmp   EndPawnCheckPart
       DontJumpEnd:                  

                                     cmp   [bx + 3],byte ptr 1
                                     je    OtherSide

                                     cmp   [bx +2 ],byte ptr 1
                                     jne   OtherSide
                                             
                                     mov   al,currentPlayer
                                     call  SetKingChecked
                                            
                                     mov   [si+1],byte ptr 04H
                                     jmp   EndPawnCheckPart
       OtherSide:                    
                                     mov   bx,si
                                     mov   cx,8
                                     mov   di,offset BannedLeft
       isOnLeft1:                    
                                     mov   al,[di]
                                     cmp   al,[bx]
                                     jne   NotBanned2
                                     jmp   EndPawnCheckPart

       NotBanned2:                   
                                     inc   di

                                     loop  isOnLeft1

                                     sub   bx,36
                                     cmp   bx,offset Cells
                                     jnb   skipJump
                                     jmp   EndPawnCheckPart

       skipJump:                     

                                     cmp   [bx + 3],byte ptr 1
                                     jne   skipJmp2

                                     jmp   EndPawnCheckPart

       skipJmp2:                     

                                     cmp   [bx +2 ],byte ptr 1
                                     jne   EndPawnCheckPart
                                             
                                     mov   al,currentPlayer
                                     call  SetKingChecked
                                            
                                     mov   [si+1],byte ptr 04H
                                     jmp   EndPawnCheckPart
     
                
                     
                    
                    
                    
       PawnCheckingPlayerTwo:        
                                     mov   bx,si
                                     mov   cx,8
                                     mov   di,offset BannedRight

       isOnRight2:                   
                                     mov   al,[di]
                                     cmp   al,[bx]
                                     jne   NotBanned3

                                     jmp   OtherSide2

       NotBanned3:                   
                                     inc   di
                                     loop  isOnRight2

                                     add   bx,36
                                     cmp   bx,offset Cells + 252
                                     jna   DontJumpEnd2
                                     jmp   EndPawnCheckPart
       DontJumpEnd2:                 

                                     cmp   [bx + 3],byte ptr 2
                                     je    OtherSide2

                                     cmp   [bx +2 ],byte ptr 1
                                     jne   OtherSide2

                                     mov   al,currentPlayer
                                     call  SetKingChecked
                                            
                                     mov   [si+1],byte ptr 04H
                                     jmp   EndPawnCheckPart
       OtherSide2:                   
                                     mov   bx,si
                                     mov   cx,8
                                     mov   di,offset BannedLeft
       isOnLeft4:                    
                                     mov   al,[di]
                                     cmp   al,[bx]
                                     jne   NotBanned4
                                     jmp   EndPawnCheckPart

       NotBanned4:                   
                                     inc   di

                                     loop  isOnLeft4

                                     add   bx,28
                                     cmp   bx,offset Cells + 252
                                     ja    EndPawnCheckPart

                                     cmp   [bx + 3],byte ptr 2
                                     je    EndPawnCheckPart

                                     cmp   [bx +2 ],byte ptr 1
                                     jne   EndPawnCheckPart

                                     mov   al,currentPlayer
                                     call  SetKingChecked
                                            
                                     mov   [si+1],byte ptr 04H
                                     jmp   EndPawnCheckPart
     


       EndPawnCheckPart:             
                                     pop   si

       endCheck:                     
                                     mov   CellWidth,30
                                     mov   CellHeight,20
                                     call  DrawCell

                                     pop   cx
                                     pop   bx
                                     pop   di
                                     pop   si
                                     ret
CheckForCheckmate endp


SetKingChecked Proc
                                     mov   checkmate,1

                                     cmp   al,2
                                     je    PlayerTwoKingChecked
                                     mov   CheckmatePlayer1,1
                                     call  KingOneChecked

                                     jmp   setFinish

       PlayerTwoKingChecked:         
                                     mov   CheckmatePlayer2,1
                                     call  KingTwoChecked
       setFinish:                    
                                     ret

SetKingChecked endp


ModifyStatus proc

                                     cmp   ah,1
                                     je    Player1Stat

                                     cmp   ah,2
                                     je    Player2Stat

                                     jmp   ThenGo
       Player1Stat:                  
                                     mov   dh ,0
                                     mov   dl,[PlayerOneStatus]
                                     inc   [PlayerOneStatus]
                                     mov   bx,offset PlayerOneStatus
                                     add   bx,dx
                                     mov   [bx],al
                                     call  DrawStatusBar
                                     jmp   ThenGo
                                     
       ;=======================================================maher
       ;   cmp   al,byte ptr 2
       ;   jne   notkilled
       ;   mov   KilledKing,2
       ;=======================================================maher
       notkilled:                    

       Player2Stat:                  
                                     mov   dh ,0
                                     mov   dl,[PlayerTwoStatus]
                                     inc   [PlayerTwoStatus]
                                     mov   bx,offset PlayerTwoStatus
                                     add   bx,dx
                                     mov   [bx],al
                                     call  DrawStatusBar
                                     jmp   ThenGo
       ThenGo:                       

 
       ;=======================================================maher
       ;   cmp   al,byte ptr 2
       ;   jne   notkilled2
       ;   mov   KilledKing,1
       ;=======================================================maher
       notkilled2:                   
                                     cmp   currentPlayer,2
                                     je    togo2

                                     mov   di,offset togoPlayer1
                                     jmp   closeStatus
       togo2:                        
                                     mov   di,offset togoPlayer2
       closeStatus:                  
                                     call  RemoveSelections
                                     ret

ModifyStatus endp


       ;=============================================== Maher
GetPawnToBeUpgraded PROC far
                                     push  ax
                                     push  bx
                                     push  cx
                                     push  dx
                                     push  si
                                     push  di
                                     pushf

                                     mov   cx,8
                                     mov   si,offset cells
       CheckPawn:                    
                                     cmp   [si+2],byte ptr 1
                                     jne   skip5
                                     mov   PawnCellToBeUpgraded1,si
       skip5:                        
                                     add   si,4
                                     loop  CheckPawn


                                     mov   cx,8
                                     mov   si,offset cells+224
       CheckPawn2:                   
                                     cmp   [si+2],byte ptr 1
                                     jne   skip6
                                     mov   PawnCellToBeUpgraded2,si
       skip6:                        
                                     add   si,4
                                     loop  CheckPawn2


                                     popf
                                     pop   di
                                     pop   si
                                     pop   dx
                                     pop   cx
                                     pop   bx
                                     pop   ax
                                     ret

GetPawnToBeUpgraded ENDP

       ; To Do : Implement This Function
       ; Parameters : Number Of The Cell the Piece is on
       ;              For Which Player Is This Piece

       ; The Functions should place the aviable moves of this piece in either togoPlayer1 or togoPlayer2 depending
       ; on the player passed to the function


       ;============================================Maher
PawnAvilableMoves proc

                                     cmp   currentPlayer,1
                                     jz    Pawnplayer1
                                     cmp   currentPlayer,2
                                     jnz   temp3
                                     jmp   Pawnplayer2
       temp3:                        



       Pawnplayer1:                  
                                  
                                     mov   al,32
                                     mov   ah,0
                                     sub   si,ax

                                     cmp   si,offset Cells
                                     jb    Pawnplayer1End

                                     cmp   [si],byte ptr 0ffH
                                     je    Pawnplayer1End

                                     mov   al,[si + 3]
                                     cmp   al, 0
                                     jne   checkenemyL
                        
                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

                                     mov   si,Player1SelectedPieceLocation
                                     cmp   si,offset cells +192
                                     jb    checkenemyL
                     
                                     mov   al,64
                                     mov   ah,0
                                     sub   si,ax

                                     mov   al,[si + 3]
                                     cmp   al, 0
                                     jne   checkenemyL
                        
                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       checkenemyL:                  

                                     mov   si,Player1SelectedPieceLocation

                                     mov   bx,offset BannedLeft
                                     mov   cx,8
       CheckPawnBannedLeft:          
                                     mov   al,[bx]
                                     cmp   [si],al
                                     je    checkenemyR
                                     inc   bx
                                     loop  CheckPawnBannedLeft

                                     mov   al,36
                                     mov   ah,0
                                     sub   si,ax

                                     mov   al,[si + 3]
                                     cmp   al, 2
                                     jne   checkenemyR

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di


       checkenemyR:                  
                                     mov   si,Player1SelectedPieceLocation

                                     mov   bx,offset BannedRight
                                     mov   cx,8
       CheckPawnBannedRight:         
                                     mov   al,[bx]
                                     cmp   [si],al
                                     je    Pawnplayer1End
    
                                     inc   bx
                                     loop  CheckPawnBannedRight
                     
                     
                                     mov   al,28
                                     mov   ah,0
                                     sub   si,ax

                                     mov   al,[si + 3]
                                     cmp   al, 2
                                     jne   Pawnplayer1End
    
                     

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di
                     
       Pawnplayer1End:               
                                     jmp   Pawnend
       Pawnplayer2:                  
    
                                     mov   al,32
                                     mov   ah,0
                                     add   si,ax

                                     cmp   si,offset Cells + 252
                                     ja    Pawnend

                                     cmp   [si],byte ptr 0ffH
                                     je    Pawnend


                                     mov   al,[si + 3]
                                     cmp   al, 0
                                     jne   checkenemyR2
                        
                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

                                     mov   si,Player2SelectedPieceLocation
                                     cmp   si,offset cells +64
                                     ja    checkenemyR2
                     
                                     mov   al,64
                                     mov   ah,0
                                     add   si,ax

                                     mov   al,[si + 3]
                                     cmp   al, 0
                                     jne   checkenemyR2
                        
                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       checkenemyR2:                 

                                     mov   si,Player2SelectedPieceLocation

                                     mov   bx,offset BannedRight
                                     mov   cx,8
       CheckPawnBannedRight2:        
                                     mov   al,[bx]
                                     cmp   [si],al
                                     je    checkenemyL2
    
                                     inc   bx
                                     loop  CheckPawnBannedRight2
                                  

                                     mov   al,36
                                     mov   ah,0
                                     add   si,ax

                                     mov   al,[si + 3]
                                     cmp   al, 1
                                     jne   checkenemyL2

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di


       checkenemyL2:                 
                                     mov   si,Player2SelectedPieceLocation

                                     mov   bx,offset BannedLeft
                                     mov   cx,8
       CheckPawnBannedLeft2:         
                                     mov   al,[bx]
                                     cmp   [si],al
                                     je    Pawnend
                                     inc   bx
                                     loop  CheckPawnBannedLeft2
                     
                                     mov   al,28
                                     mov   ah,0
                                     add   si,ax

                                     mov   al,[si + 3]
                                     cmp   al, 1
                                     jne   Pawnend

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di
                     

                                     jmp   Pawnend
                      

       Pawnend:                      
                                     mov   [di],byte ptr 0ffH
                                     ret
PawnAvilableMoves endp

       ;=============================================Maher
KingAvilableMoves proc

                                     cmp   currentPlayer,1
                                     jne   nxt1
                                     mov   ax,Player1SelectedPieceLocation
                                     mov   SelectedPieceLocation,ax
       nxt1:                         
                                     cmp   currentPlayer,2
                                     jne   nxt
                                     mov   ax,Player2SelectedPieceLocation
                                     mov   SelectedPieceLocation,ax


       nxt:                          


                                     mov   cx,8
                                     mov   bx,offset BannedLeft
       leftavailble:                 
                                     mov   al,[bx]
                                     cmp   [si],al
                                     je    setbannedleft
                                     inc   bx
                                     loop  leftavailble
                                     jmp   skip1
       setbannedleft:                
                                     mov   kingbannedleft,1
       skip1:                        
                                     mov   cx,8
                                     mov   bx,offset BannedRight
       rightavailble:                
                                     mov   al,[bx]
                                     cmp   [si],al
                                     je    setbannedReight
                                     inc   bx
                                     loop  rightavailble
                                     jmp   skip2
       setbannedReight:              
                                     mov   kingbannedright,1
       skip2:                        
                                     mov   cx,8
                                     mov   bx,offset BannedUp
       upavailble:                   
                                     mov   al,[bx]
                                     cmp   [si],al
                                     je    setbannedup
                                     inc   bx
                                     loop  upavailble
                                     jmp   skip3
       setbannedup:                  
                                     mov   kingbannedup,1
       skip3:                        
                                     mov   cx,8
                                     mov   bx,offset BannedDown
       downavailble:                 
                                     mov   al,[bx]
                                     cmp   [si],al
                                     je    setbannedDown
                                     inc   bx
                                     loop  downavailble
                                     jmp   skip4
       setbannedDown:                
                                     mov   kingbanneddown,1
       skip4:                        

                                     cmp   kingbannedleft,1
                                     je    skipMoveKingLeft

                                     mov   al,4
                                     mov   ah,0
                                     sub   si,ax

                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveKingLeft
                     
                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       skipMoveKingLeft:             

                                     cmp   kingbannedright,1
                                     je    skipMoveKingRight

                                     mov   si,SelectedPieceLocation
                     
                                     mov   al,4
                                     mov   ah,0
                                     add   si,ax

                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveKingRight
                            
                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       skipMoveKingRight:            

                                     mov   cx,3
                                     mov   si,SelectedPieceLocation

                                     mov   al,36
                                     mov   ah,0
                                     sub   si,ax

                                  
                                  
                                     cmp   kingbannedup,1
                                     je    skipMoveKingAbove
                           


       moveKingAbove:                

                                            

                                     cmp   cx,3
                                     jne   s1
                                     cmp   kingbannedleft,1
                                     je    skipOneAbove
       s1:                           

                                                        
                                
                                     cmp   cx,1
                                     jne   s3
                                     cmp   kingbannedright,1
                                     je    skipOneAbove
       s3:                           

                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipOneAbove

                                 

                            
                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       skipOneAbove:                 

                                     mov   al,4
                                     mov   ah,0
                                     add   si,ax
                     
                                     loop  moveKingAbove

       skipMoveKingAbove:            



                                     mov   cx,3
                                     mov   si,SelectedPieceLocation

                                     mov   al,28
                                     mov   ah,0
                                     add   si,ax

                                     cmp   kingbanneddown,1
                                     je    skipMoveKingDown

       moveKingDown:                 
                                  


                                     cmp   cx,3
                                     jne   s4
                                     cmp   kingbannedleft,1
                                     je    skipOneDown
       s4:                           

                                  
                                
                                     cmp   cx,1
                                     jne   s6
                                     cmp   kingbannedright,1
                                     je    skipOneDown
       s6:                           


                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipOneDown
                            
                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       skipOneDown:                  

                                     mov   al,4
                                     mov   ah,0
                                     add   si,ax

                     
                     
                                     loop  moveKingDown

       skipMoveKingDown:             



       Kingend:                      
                                     mov   [di],byte ptr 0ffH
                                     mov   kingbanneddown,0
                                     mov   kingbannedup,0
                                     mov   kingbannedleft,0
                                     mov   kingbannedright,0
                        
                                     ret
KingAvilableMoves endp




KnightAvilableMoves proc
                                     mov   bx,offset BannedRight
                                     mov   cx,8
       loopxy:                       
                                     mov   al,[bx]
                                     cmp   [si],al
                                     jnz   continuu
                                     mov   KnightBanned,1
       continuu:                     
                                     inc   bx
                                     loop  loopxy


                                     mov   bx,offset BannedRight2
                                     mov   cx,8
       loopxy2:                      
                                     mov   al,[bx]
                                     cmp   [si],al
                                     jnz   continuu2
                                     mov   KnightBanned+1,1
       continuu2:                    
                                     inc   bx
                                     loop  loopxy2


                                     mov   bx,offset BannedLeft
                                     mov   cx,8
       loopxy3:                      
                                     mov   al,[bx]
                                     cmp   [si],al
                                     jnz   continuu3
                                     mov   KnightBanned+2,1
       continuu3:                    
                                     inc   bx
                                     loop  loopxy3

                                     mov   bx,offset BannedLeft2
                                     mov   cx,8
       loopxy4:                      
                                     mov   al,[bx]
                                     cmp   [si],al
                                     jnz   continuu4
                                     mov   KnightBanned+3,1
       continuu4:                    
                                     inc   bx
                                     loop  loopxy4

                                     mov   bx,offset KnightMoves
       Player1Cell:                  


                                     mov   cx,4
       SetToGoKnight:                
                                     mov   al,[bx]
                                     mov   ah,0
                                     add   si,ax

                                     cmp   si,offset Cells + 252
                                     ja    skipAvilableKnightAddition
                                     cmp   si,offset Cells
                                     jb    skipAvilableKnightAddition
                                     
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipAvilableKnightAddition

                                     cmp   cx,4
                                     jnz   con
                                     cmp   KnightBanned+3,1
                                     je    skipAvilableKnightAddition
                                     cmp   KnightBanned+2,1
                                     je    skipAvilableKnightAddition
       con:                          

                                     cmp   cx,3
                                     jnz   con2
                                     cmp   KnightBanned,1
                                     je    skipAvilableKnightAddition
                                     cmp   KnightBanned+1,1
                                     je    skipAvilableKnightAddition
       con2:                         

                                     cmp   cx,2
                                     jnz   con3
                                     cmp   KnightBanned+2,1
                                     je    skipAvilableKnightAddition
                                     
       con3:                         
                                                                        
                                     cmp   cx,1
                                     jnz   con4
                                     cmp   KnightBanned,1
                                     je    skipAvilableKnightAddition
                                     
       con4:                         


                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di
       skipAvilableKnightAddition:   
                         
                                     mov   al,[bx]
                                     sub   si,ax
                                     sub   si,ax

                                     cmp   si,offset Cells + 252

                                     ja    skipAvilableKnightSubtraction
                                     cmp   si,offset Cells
                                     jb    skipAvilableKnightSubtraction

                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipAvilableKnightSubtraction

                                     cmp   cx,4
                                     jnz   con00
                                     cmp   KnightBanned,1
                                     je    skipAvilableKnightSubtraction
                                     cmp   KnightBanned+1,1
                                     je    skipAvilableKnightSubtraction
       con00:                        

                                     cmp   cx,3
                                     jnz   con22
                                     cmp   KnightBanned+2,1
                                     je    skipAvilableKnightSubtraction
                                     cmp   KnightBanned+3,1
                                     je    skipAvilableKnightSubtraction
       con22:                        

                                     cmp   cx,2
                                     jnz   con33
                                     cmp   KnightBanned,1
                                     je    skipAvilableKnightSubtraction
                                     
       con33:                        
                                                                        
                                     cmp   cx,1
                                     jnz   con44
                                     cmp   KnightBanned+2,1
                                     je    skipAvilableKnightSubtraction
                                     
       con44:                        
                                     
                       
                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di
       skipAvilableKnightSubtraction:
                        
                                     mov   al,[bx]
                                     add   si,ax
                                     inc   bx
                                     dec   cx
                                     jz    ll
                                     jmp   SetToGoKnight
       ll:                           
                                     mov   KnightBanned,0
                                     mov   KnightBanned+1,0
                                     mov   KnightBanned+2,0
                                     mov   KnightBanned+3,0
                                     mov   [di],byte ptr 0ffH

                                     ret
KnightAvilableMoves endp


BishopAvilableMoves proc
                                     mov   al,otherPlayer
                                     push  ax
                                   

                                     cmp   currentPlayer,1
                                     jz    BishopPlayer1
                                     cmp   currentPlayer,2
                                     jz    BishopPlayer2
              

       BishopPlayer1:                
                                     mov   otherPlayer,2
                                     jmp   startt

       BishopPlayer2:                
                                     mov   otherPlayer,1
                                     jmp   startt
       startt:                       
                                     mov   cx,7                                      ; 7 max num of right up

                                     push  si
              


              


       loopRightUp:                  
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedUp
                                     mov   al,[si]
       loopBannedUp1:                
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveBishopRightUp
                                     cmp   ah,0ffh
                                     je    outUp1
                                     inc   bx
                                     jmp   loopBannedUp1
       outUp1:                       

                                     mov   bx,offset BannedRight
                                     mov   al,[si]
       loopBannedRight1:             
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveBishopRightUp
                                     cmp   ah,0ffh
                                     je    outRight1
                                     inc   bx
                                     jmp   loopBannedRight1
       outRight1:                    

                                     mov   al,28
                                     mov   ah,0
                                     sub   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveBishopRightUp

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveBishopRightUp

                     
                     

                                     mov   al,28
                                     mov   ah,0
                                     loop  loopRightUp
       skipMoveBishopRightUp:        
              


       ;; here si must have the last value use push and pop
                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,7                                      ; 7 max num of left up
       loopLeftUp:                   
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedUp
                                     mov   al,[si]
       loopBannedUp2:                
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveBishopLeftUp
                                     cmp   ah,0ffh
                                     je    outUp2
                                     inc   bx
                                     jmp   loopBannedUp2
       outUp2:                       

                                     mov   bx,offset BannedLeft
                                     mov   al,[si]
       loopBannedLeft1:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveBishopLeftUp
                                     cmp   ah,0ffh
                                     je    outLeft1
                                     inc   bx
                                     jmp   loopBannedLeft1
       outLeft1:                     
                     

                                     mov   al,36
                                     mov   ah,0
                                     sub   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveBishopLeftUp

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveBishopLeftUp

                     

                                     mov   al,36
                                     mov   ah,0
                                     loop  loopLeftUp
       skipMoveBishopLeftUp:         




              



                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,7                                      ; 7 max num of left up
       loopLeftDown:                 
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedDown
                                     mov   al,[si]
       loopBannedDown1:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveBishopLeftDown
                                     cmp   ah,0ffh
                                     je    outDown1
                                     inc   bx
                                     jmp   loopBannedDown1
       outDown1:                     

                                     mov   bx,offset BannedLeft
                                     mov   al,[si]
       loopBannedLeft2:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveBishopLeftDown
                                     cmp   ah,0ffh
                                     je    outLeft2
                                     inc   bx
                                     jmp   loopBannedLeft2
       outLeft2:                     


                                     mov   al,28
                                     mov   ah,0
                                     add   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveBishopLeftDown

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveBishopLeftDown

                     

                                     mov   al,28
                                     mov   ah,0
                                     loop  loopLeftDown
       skipMoveBishopLeftDown:       



                                     pop   si
       ;==========================================================
                                     mov   cx,7                                      ; 7 max num of left up
       loopRightDown:                
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedDown
                                     mov   al,[si]
       loopBannedDown2:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveBishopRightDown
                                     cmp   ah,0ffh
                                     je    outDown2
                                     inc   bx
                                     jmp   loopBannedDown2
       outDown2:                     

                                     mov   bx,offset BannedRight
                                     mov   al,[si]
       loopBannedRight2:             
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveBishopRightDown
                                     cmp   ah,0ffh
                                     je    outRight2
                                     inc   bx
                                     jmp   loopBannedRight2
       outRight2:                    


                                     mov   al,36
                                     mov   ah,0
                                     add   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveBishopRightDown

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveBishopRightDown

                     

                                     mov   al,36
                                     mov   ah,0
                                     loop  loopRightDown
       skipMoveBishopRightDown:      


              
                                     jmp   Bishopend
              

       Bishopend:                    
                                     mov   [di],byte ptr 0ffH

                                     pop   ax
                                     mov   otherPlayer,al

                                     ret
       ;::TODO check if valid cell
BishopAvilableMoves endp


CastleAvilableMoves proc
                                     mov   al,otherPlayer
                                     push  ax

                                     cmp   currentPlayer,1
                                     jz    CastlePlayer1
                                     cmp   currentPlayer,2
                                     jz    CastlePlayer2
              

       CastlePlayer1:                
                                     mov   otherPlayer,2
                                     jmp   startt2

       CastlePlayer2:                
                                     mov   otherPlayer,1
                                     jmp   startt2
       startt2:                      
                                     mov   cx,8                                      ; 8 max num of right up

                                     push  si
              


       loopRight:                    
       ; if the current cell is banned right dont continue
                      
                                     mov   bx,offset BannedRight
                                     mov   al,[si]
       loopBannedRight3:             
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveCastleRight
                                     cmp   ah,0ffh
                                     je    outRight3
                                     inc   bx
                                     jmp   loopBannedRight3
       outRight3:                    

                                     mov   al,4
                                     mov   ah,0
                                     add   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveCastleRight

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveCastleRight

                     
                     

                                     mov   al,4
                                     mov   ah,0
                                     loop  loopRight
       skipMoveCastleRight:          
              


       ;; here si must have the last value use push and pop
                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,8                                      ; 8 max num of left up
       loopLeft:                     
       ; if the current cell is banned right dont continue
                     
                                     mov   bx,offset BannedLeft
                                     mov   al,[si]
       loopBannedLeft3:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveCastleLeft
                                     cmp   ah,0ffh
                                     je    outLeft3
                                     inc   bx
                                     jmp   loopBannedLeft3
       outLeft3:                     
                     

                                     mov   al,4
                                     mov   ah,0
                                     sub   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveCastleLeft

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveCastleLeft

                     

                                     mov   al,4
                                     mov   ah,0
                                     loop  loopLeft
       skipMoveCastleLeft:           




              



                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,8                                      ; 8 max num of left up
       loopDown:                     
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedDown
                                     mov   al,[si]
       loopBannedDown3:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveCastleDown
                                     cmp   ah,0ffh
                                     je    outDown3
                                     inc   bx
                                     jmp   loopBannedDown3
       outDown3:                     



                                     mov   al,32
                                     mov   ah,0
                                     add   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveCastleDown

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveCastleDown

                     

                                     mov   al,32
                                     mov   ah,0
                                     loop  loopDown
       skipMoveCastleDown:           



                                     pop   si
       ;==========================================================
                                     mov   cx,8                                      ; 8 max num of left up
       loopUp:                       
       ; if the current cell is banned Up dont continue

                                     mov   bx,offset BannedUp
                                     mov   al,[si]
       loopBannedUp3:                
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveCastleUp
                                     cmp   ah,0ffh
                                     je    outUp3
                                     inc   bx
                                     jmp   loopBannedUp3
       outUp3:                       


                                     mov   al,32
                                     mov   ah,0
                                     sub   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveCastleUp

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveCastleUp

                     

                                     mov   al,32
                                     mov   ah,0
                                     loop  loopUp
       skipMoveCastleUp:             


              
                                     jmp   Castleend
              

       Castleend:                    
                                     mov   [di],byte ptr 0ffH
       



                                     pop   ax
                                     mov   otherPlayer,al

                                     ret
CastleAvilableMoves endp


QueenAvilableMoves proc
                                     mov   al,otherPlayer
                                     push  ax
                                     cmp   currentPlayer,1
                                     jz    QueenPlayer1
                                     cmp   currentPlayer,2
                                     jz    QueenPlayer2
              

       QueenPlayer1:                 
                                     mov   otherPlayer,2
                                     jmp   startt22

       QueenPlayer2:                 
                                     mov   otherPlayer,1
                                     jmp   startt22
       startt22:                     
                                     mov   cx,7                                      ; 7 max num of right up

                                     push  si
              


              

       loopRightUp2:                 
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedUp
                                     mov   al,[si]
       loopBannedUp4:                
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenRightUp
                                     cmp   ah,0ffh
                                     je    outUp4
                                     inc   bx
                                     jmp   loopBannedUp4
       outUp4:                       

                                     mov   bx,offset BannedRight
                                     mov   al,[si]
       loopBannedRight4:             
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenRightUp
                                     cmp   ah,0ffh
                                     je    outRight4
                                     inc   bx
                                     jmp   loopBannedRight4
       outRight4:                    

                                     mov   al,28
                                     mov   ah,0
                                     sub   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveQueenRightUp

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveQueenRightUp

                     
                     

                                     mov   al,28
                                     mov   ah,0
                                     loop  loopRightUp2
       skipMoveQueenRightUp:         
              


       ;; here si must have the last value use push and pop
                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,7                                      ; 7 max num of left up
       loopLeftUp2:                  
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedUp
                                     mov   al,[si]
       loopBannedUp5:                
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenLeftUp
                                     cmp   ah,0ffh
                                     je    outUp5
                                     inc   bx
                                     jmp   loopBannedUp5
       outUp5:                       

                                     mov   bx,offset BannedLeft
                                     mov   al,[si]
       loopBannedLeft4:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenLeftUp
                                     cmp   ah,0ffh
                                     je    outLeft4
                                     inc   bx
                                     jmp   loopBannedLeft4
       outLeft4:                     
                     

                                     mov   al,36
                                     mov   ah,0
                                     sub   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveQueenLeftUp

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveQueenLeftUp

                     

                                     mov   al,36
                                     mov   ah,0
                                     loop  loopLeftUp2
       skipMoveQueenLeftUp:          




              



                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,7                                      ; 7 max num of left up
       loopLeftDown2:                
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedDown
                                     mov   al,[si]
       loopBannedDown4:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenLeftDown
                                     cmp   ah,0ffh
                                     je    outDown4
                                     inc   bx
                                     jmp   loopBannedDown4
       outDown4:                     

                                     mov   bx,offset BannedLeft
                                     mov   al,[si]
       loopBannedLeft5:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenLeftDown
                                     cmp   ah,0ffh
                                     je    outLeft5
                                     inc   bx
                                     jmp   loopBannedLeft5
       outLeft5:                     


                                     mov   al,28
                                     mov   ah,0
                                     add   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveQueenLeftDown

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveQueenLeftDown

                     

                                     mov   al,28
                                     mov   ah,0
                                     loop  loopLeftDown2
       skipMoveQueenLeftDown:        



                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,7                                      ; 7 max num of left up
       loopRightDown2:               
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedDown
                                     mov   al,[si]
       loopBannedDown5:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenRightDown
                                     cmp   ah,0ffh
                                     je    outDown5
                                     inc   bx
                                     jmp   loopBannedDown5
       outDown5:                     

                                     mov   bx,offset BannedRight
                                     mov   al,[si]
       loopBannedRight5:             
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenRightDown
                                     cmp   ah,0ffh
                                     je    outRight5
                                     inc   bx
                                     jmp   loopBannedRight5
       outRight5:                    


                                     mov   al,36
                                     mov   ah,0
                                     add   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveQueenRightDown

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveQueenRightDown

                     

                                     mov   al,36
                                     mov   ah,0
                                     loop  loopRightDown2
       skipMoveQueenRightDown:       





                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,8                                      ; 8 max num of left up
       loopRight2:                   
       ; if the current cell is banned right dont continue
                      
                                     mov   bx,offset BannedRight
                                     mov   al,[si]
       loopBannedRight7:             
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenRight
                                     cmp   ah,0ffh
                                     je    outRight7
                                     inc   bx
                                     jmp   loopBannedRight7
       outRight7:                    

                                     mov   al,4
                                     mov   ah,0
                                     add   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveQueenRight

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveQueenRight

                     
                     

                                     mov   al,4
                                     mov   ah,0
                                     loop  loopRight2
       skipMoveQueenRight:           
              


       ;; here si must have the last value use push and pop
                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,8                                      ; 8 max num of left up
       loopLeft2:                    
       ; if the current cell is banned right dont continue
                     
                                     mov   bx,offset BannedLeft
                                     mov   al,[si]
       loopBannedLeft7:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenLeft
                                     cmp   ah,0ffh
                                     je    outLeft7
                                     inc   bx
                                     jmp   loopBannedLeft7
       outLeft7:                     
                     

                                     mov   al,4
                                     mov   ah,0
                                     sub   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveQueenLeft

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveQueenLeft

                     

                                     mov   al,4
                                     mov   ah,0
                                     loop  loopLeft2
       skipMoveQueenLeft:            




              



                                     pop   si
                                     push  si
       ;==========================================================
                                     mov   cx,8                                      ; 8 max num of left up
       loopDown2:                    
       ; if the current cell is banned right dont continue
                                     mov   bx,offset BannedDown
                                     mov   al,[si]
       loopBannedDown7:              
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenDown
                                     cmp   ah,0ffh
                                     je    outDown7
                                     inc   bx
                                     jmp   loopBannedDown7
       outDown7:                     



                                     mov   al,32
                                     mov   ah,0
                                     add   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveQueenDown

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveQueenDown

                     

                                     mov   al,32
                                     mov   ah,0
                                     loop  loopDown2
       skipMoveQueenDown:            



                                     pop   si
       ;==========================================================
                                     mov   cx,8                                      ; 8 max num of left up
       loopUp2:                      
       ; if the current cell is banned Up dont continue

                                     mov   bx,offset BannedUp
                                     mov   al,[si]
       loopBannedUp7:                
                                     mov   ah,[bx]
                                     cmp   ah,al
                                     je    skipMoveQueenUp
                                     cmp   ah,0ffh
                                     je    outUp7
                                     inc   bx
                                     jmp   loopBannedUp7
       outUp7:                       


                                     mov   al,32
                                     mov   ah,0
                                     sub   si,ax
                     
       ; dont add to di if the curret pos is the same player
                                     mov   al,[si + 3]
                                     cmp   al, currentPlayer
                                     je    skipMoveQueenUp

                                     mov   al,[si]
                                     mov   [di],al
                                     inc   di

       ; dont add the next pos to di if the curret pos is the other player
                                     mov   al,[si + 3]
                                     cmp   al, otherPlayer
                                     je    skipMoveQueenUp

                     

                                     mov   al,32
                                     mov   ah,0
                                     loop  loopUp2
       skipMoveQueenUp:              



              

                                     mov   [di],byte ptr 0ffH
             



                                     pop   ax
                                     mov   otherPlayer,al


                                     ret
QueenAvilableMoves endp


sendPieces proc far
                                     push  di
                                     push  ax
                                     push  cx
                                     push  dx

                                     mov   di,offset toSendPiece
                                     mov   cx,3
       ;Check that transmitter holding register is empy
       sendPieceOne:                 
                                     mov   dx,3fdh                                   ; line status register
       Again:                        in    al,dx                                     ; Read Line Status
                                     And   al, 00100000b
                                     jz    Again

       ; IF EMPTY put the value in transmit data register
                                     mov   dx, 3f8h
                                     mov   al, [di]                                  ; transmit register
                                     out   dx,al
                                     inc di
                                     loop  sendPieceOne
                                     
                                     pop   dx
                                     pop   cx
                                     pop   ax
                                     pop   di
                                     retf


sendPieces endp

end SelectClickedPlayer