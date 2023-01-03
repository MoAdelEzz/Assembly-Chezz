Extrn Cells: byte
Extrn togoPlayer1 : byte
Extrn togoPlayer2 : byte

public DrawBoard
public DrawCell
public CellWidth
public CellHeight

public PlayerOneStatus
public PlayerTwoStatus
public DrawStatusBar
public SystemTime
public getSystemTime
public RemoveSelections
public DrawSelections


public InitialColors
public PlayerOneCellColor
public PlayerTwoCellColor


Extrn CheckmatePlayer1:Byte
Extrn CheckmatePlayer2:Byte


public KingOneChecked
public KingTwoChecked
public EraseOneChecked
public EraseTwoChecked



.model small
.data
    ;  PAWN IMAGE ADDRESS

    Pawn               DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 00H, 00H, 00H, 00H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH
                       DB 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH
                       DB 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH
                       DB 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H
    ; end Pawn

    ;  KING IMAGE ADDRESS
    ;Start King
    King               DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 00H, 00H, 01H, 01H, 01H, 01H, 01H, 01H, 0FFH
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 01H, 00H, 00H, 01H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH
                       DB 0FFH, 0FFH, 01H, 00H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 00H, 01H, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 01H, 01H, 01H, 01H, 01H, 01H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
    ;End King

    ;  QUEEN IMAGE ADDRESS
    ;start queen
    Queen              DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 0FFH, 01H, 00H, 00H, 01H, 0FFH, 01H, 01H, 0FFH, 0FFH, 0FFH
                       DB 01H, 01H, 0FFH, 01H, 01H, 0FFH, 01H, 01H, 01H, 01H, 0FFH, 01H, 01H, 0FFH, 01H, 01H
                       DB 01H, 01H, 0FFH, 0FFH, 00H, 0FFH, 0FFH, 00H, 00H, 0FFH, 0FFH, 00H, 0FFH, 0FFH, 00H, 01H
                       DB 0FFH, 00H, 0FFH, 0FFH, 00H, 01H, 0FFH, 01H, 01H, 0FFH, 01H, 00H, 0FFH, 0FFH, 00H, 0FFH
                       DB 0FFH, 00H, 01H, 0FFH, 00H, 01H, 0FFH, 01H, 01H, 0FFH, 01H, 00H, 0FFH, 01H, 00H, 0FFH
                       DB 0FFH, 00H, 01H, 0FFH, 00H, 01H, 0FFH, 00H, 00H, 0FFH, 01H, 00H, 0FFH, 01H, 00H, 0FFH
                       DB 0FFH, 00H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 00H, 0FFH
                       DB 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH            ;end queen


    ;  KNIGHT IMAGE ADDRESS
    ;Knight Start
    Knight             DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 00H, 00H, 00H, 00H, 01H, 01H, 01H, 01H, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 01H, 0FFH, 0FFH
                       DB 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 01H, 0FFH
                       DB 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 00H, 00H, 00H, 01H, 01H, 01H, 01H
                       DB 01H, 01H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 00H, 00H, 00H, 00H, 01H, 01H, 01H
                       DB 01H, 01H, 00H, 00H, 00H, 01H, 01H, 0FFH, 01H, 00H, 00H, 00H, 00H, 01H, 00H, 01H
                       DB 01H, 01H, 01H, 00H, 01H, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 01H, 00H, 01H
                       DB 0FFH, 0FFH, 01H, 01H, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 00H, 01H
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 00H, 01H
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 00H, 01H
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 00H, 01H
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H
    ;end Knight

    ;  BISHOP IMAGE ADDRESS
    ;bishop start
    Bishop             DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 00H, 00H, 00H, 00H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 0FFH, 01H, 00H, 01H, 01H, 01H, 01H, 00H, 01H, 0FFH, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 01H, 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H, 01H, 0FFH
                       DB 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H
    ;bishop end


    ;  CASTLE IMAGE ADDRESS
    ; Castle Start
    Castle             DB 0FFH, 01H, 01H, 01H, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 01H, 01H, 01H, 0FFH
                       DB 0FFH, 01H, 00H, 01H, 01H, 01H, 01H, 00H, 00H, 01H, 01H, 01H, 01H, 00H, 01H, 0FFH
                       DB 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 0FFH
                       DB 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 0FFH, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 0FFH, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH
                       DB 0FFH, 0FFH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0FFH, 0FFH
                       DB 01H, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 01H
                       DB 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H, 01H

    ; Each Cell Has ====> Number, background color- piece number - dominating player
    ;                                               0 if No Piece         1/2
    ; first cell => Cells,   second cell => Cells + 4, third Cell => Cells + 8
    ; ; first cell color => Cells + 1,   first cell piece => Cells + 2, first Cell player => Cells + 3

    Circle             DB 0ffH, 0ffH, 0ffH, 0ffH, 0ffH, 01H, 01H, 01H, 01H, 01H, 01H, 0ffH, 0ffH, 0ffH, 0ffH, 0ffH
                       DB 0ffH, 0ffH, 0ffH, 0ffH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0ffH, 0ffH, 0ffH, 0ffH
                       DB 0ffH, 0ffH, 0ffH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0ffH, 0ffH, 0ffH
                       DB 0ffH, 0ffH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0ffH, 0ffH
                       DB 0ffH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0ffH
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H
                       DB 0ffH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0ffH
                       DB 0ffH, 0ffH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0ffH, 0ffH
                       DB 0ffH, 0ffH, 0ffH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0ffH, 0ffH, 0ffH
                       DB 0ffH, 0ffH, 0ffH, 0ffH, 01H, 00H, 00H, 00H, 00H, 00H, 00H, 01H, 0ffH, 0ffH, 0ffH, 0ffH
                       DB 0ffH, 0ffH, 0ffH, 0ffH, 0ffH, 01H, 01H, 01H, 01H, 01H, 01H, 0ffH, 0ffH, 0ffH, 0ffH, 0ffH


    ; used in draw board to draw the piece above the cell

    pieceColor         db 05H
    InitialColors      db 4 dup( 4 dup(5AH,0DAH), 4 dup(0DAH,5AH))                                                        ; grid colors
    PlayerOneCellColor db 02H                                                                                             ; cell that player 1 occuping now and its color
    PlayerTwoCellColor db 2BH                                                                                             ; cell that player 2 occuping now and its color

    
    ; color of the piece border
    CellHeight         db 20                                                                                              ; height of the cell to be drawn
    CellWidth          db 30                                                                                              ; width of the cell to be drawn
    CellColor          db ?

    ; PlayerOneStatus db 16 dup(0ffH)
    ; First Number Is The First Available Location To Push
    ; Like Tail In Linked List
    PlayerOneStatus    db 1,16 dup(0ffH)
    PlayerTwoStatus    db 1,16 dup(0ffH)

    SystemTime         dw 0

    PlayerOneChecked   db 'Check', '$'
    Eraser             db '     ', '$'

.code

 
DrawBoard proc far
                          
                          push  ax
                          push  bx
                          push  cx
                          push  dx
                          push  si
                          push  di
                          pushf

    ;======================================================
                          mov   cx,64
                          mov   si,offset Cells
    drawBoardLoop:        

                          mov   CellWidth,30
                          mov   CellHeight,20

                          call  far ptr  DrawCell
                          add   si,4
                          loop  drawBoardLoop

                          popf
                          pop   di
                          pop   si
                          pop   dx
                          pop   cx
                          pop   bx
                          pop   ax



                          retf
DrawBoard endp


DrawCell proc far
    ; parameters: Cell Number

                          push  ax
                          push  bx
                          push  cx
                          push  dx
                          push  si
                          push  di
                          pushf
                          


    CalculatingDiLocation:
    ; Ax = Cell Number
                          mov   ax, 0
                          mov   al, [si]

                          mov   bx,8
                          div   bl

                          mov   dx,ax                             ;   dl = Cell Number / 8,     dh = Cell Number % 8

                          mov   al,ah
                          mov   ah,0                              ;   ah = 0 , al = ah

                          mov   bl,CellWidth
                          mul   bl
                          mov   di,ax                             ; di = (CellNumer % 8) * CellWidth

                          mov   ah,00H
                          mov   al,dl                             ;  ax = CellNumber / 8

                          mov   bx , 6400                         ;  bx = 320 * 20 = ScreenWidth * CellHeight
                          mul   bx                                ;  ah = 320*20* (CellNumber / 8)

                          add   di,ax                             ; di += ax
                          add   di,40
                                     

                          mov   dl, [si]                          ; dl = cell number
    ;========================================================================================
    GettingCellColor:     
                          mov   bx,si
                          mov   al , [bx + 1]
                          mov   CellColor, al
    ;========================================================================================
    GettingPieceColor:    
                          mov   pieceColor,08H                    ; Player 1 Color
              
                          mov   al, [bx + 3]
                          cmp   al,1
                          je    Player1PieceColor
              
                          mov   pieceColor, 0fH                   ; Player 2 Color
              
    Player1PieceColor:    
    ;========================================================================================
                          cmp   [bx + 2],byte ptr 0
                          je    DrawCellNow

    GettingPieceAddress:  
              
                          mov   si, offset Pawn
                          cmp   [bx + 2],byte ptr 1
                          je    DrawCellNow
              
                          mov   si, offset King
                          cmp   [bx + 2],byte ptr 2
                          je    DrawCellNow
              
                          mov   si, offset Queen
                          cmp   [bx + 2],byte ptr 3
                          je    DrawCellNow
              
                          mov   si, offset Knight
                          cmp   [bx + 2],byte ptr 4
                          je    DrawCellNow
              
                          mov   si, offset Bishop
                          cmp   [bx + 2],byte ptr 5
                          je    DrawCellNow
              
                          mov   si, offset Castle
                          cmp   [bx + 2],byte ptr 6
    ;========================================================================================
    DrawCellNow:          
                          mov   ch,0
                          mov   cl,CellHeight
                          mov   ax,0

    drawSingleRow:        
                          call  DrawBackground
                          add   di,320
                          add   ax,320
                          loop  drawSingleRow

                          sub   di,ax
                          cmp   [bx + 2],byte ptr 0
                          je    Return

                          mov   cx,16
                          add   di,647

                          mov   CellWidth,16
                          mov   ax,0
    drawSinglePiece:      
                          call  DrawPiece
                          add   di,320
                          add   ax ,320
                          loop  drawSinglePiece
    ; Drawing Circles if Found
                          sub   di,ax
                          sub   di , 647

    Return:               
       
    ; Drawing Player 1 Circles
    DrawCircleIfFound1:   
                          mov   CellWidth,16
                          mov   CellHeight,16

                          add   di,647
                          mov   ax,di
                          mov   bx,offset togoPlayer1
    findCellNumber1:      
                          cmp   [bx],dl
                          je    foundCellInTogo1
                          jmp   notFoundCell1
    foundCellInTogo1:     
                          mov   si,offset Circle
                          mov   pieceColor,08H
                          mov   cl,CellHeight
                          mov   ch,0
    drawCicleLoop:        
                          call  DrawPiece
                          add   di,320
                          loop  drawCicleLoop
                          jmp   breakTheToGo1
    notFoundCell1:        
                          cmp   [bx], byte ptr 0ffh
                          je    breakTheToGo1
                          inc   bx
                          jmp   findCellNumber1
                                     
    breakTheToGo1:        

                          mov   di,ax

    ; Drawing Player 2 Circles
    DrawCircleIfFound2:   
                          mov   CellWidth,16
                          mov   CellHeight,16

                          mov   bx,offset togoPlayer2
    findCellNumber2:      
                          cmp   [bx],dl
                          je    foundCellInTogo2
                          jmp   notFoundCell2
    foundCellInTogo2:     
                          mov   si,offset Circle
                          mov   pieceColor,0fH
                          mov   cl,CellHeight
                          mov   ch,0

    drawCicleLoop2:       
                          call  DrawPiece
                          add   di,320
                          loop  drawCicleLoop2
                          jmp   breakTheToGo2
    notFoundCell2:        
                          cmp   [bx],byte ptr 0ffh
                          je    breakTheToGo2
                          inc   bx
                          jmp   findCellNumber2
                                     
    breakTheToGo2:        




                          popf
                          pop   di
                          pop   si
                          pop   dx
                          pop   cx
                          pop   bx
                          pop   ax

                          retf
       
DrawCell endp

DrawBackground proc
    ; Parameters
    ; CellWidth, Draw Piece or Cell, Color Of Piece or Cell
                          push  ax
                          push  cx
                          push  di
                          pushf

                          mov   cl, CellWidth
                          mov   ch,0

    drawBGLoop:           
                          mov   al,CellColor
                          mov   es:[di],al
                          inc   di
                          loop  drawBGLoop
                            
                          popf
                          pop   di
                          pop   cx
                          pop   ax
                          ret
DrawBackground endp

DrawPiece proc
    ; Parameters
    ; cellWidth, pieceAddress, pieceColor,borderColor



                          push  ax
                          push  cx
                          push  di
                          pushf

                          mov   cx,0
                          mov   cl,CellWidth
    DrawPieceLoop:        
                          mov   al,[si]
                          cmp   al,0FFH
                          je    SkipPieceDrawing

                          mov   ah,pieceColor

                          cmp   al,00H
                          je    BodyColor
                          mov   ah,00H

    BodyColor:            
                          mov   es:[di], ah

    SkipPieceDrawing:     
                          inc   si
                          inc   di
                          loop  DrawPieceLoop

                          popf
                          pop   di
                          pop   cx
                          pop   ax
                          ret
DrawPiece endp


DrawStatusBar proc far

                          
                          push  ax
                          push  bx
                          push  cx
                          push  dx
                          push  si
                          push  di
                          pushf

                          
                          mov   CellWidth,16
                          mov   CellHeight,16
                          mov   pieceColor,08H

                          mov   bx, offset PlayerOneStatus + 1
                          mov   di , 2
                          add   di, 3200
                          call  DrawStatusColumn

                          mov   bx, offset PlayerOneStatus + 9
                          mov   di , 22
                          add   di, 3200
                          call  DrawStatusColumn

                          mov   bx, offset PlayerTwoStatus + 1
                          mov   di , 282
                          add   di, 3200
                          mov   pieceColor,0fH
                          call  DrawStatusColumn

                          mov   bx, offset PlayerTwoStatus + 9
                          mov   di , 302
                          add   di, 3200
                          call  DrawStatusColumn

                          popf
                          pop   di
                          pop   si
                          pop   dx
                          pop   cx
                          pop   bx
                          pop   ax
                          retf
    
DrawStatusBar endp

DrawStatusColumn proc
                          mov   cx,8
    PlayerOneLoop:        

                          mov   ah,0
                          mov   al,[bx]                           ; piece Number
                         
                          cmp   al, 0ffh
                          je    endPlayerOne

                          inc   bx

                          dec   ax
                          mov   dx,256
                          mul   dx

                          mov   si,offset Pawn
                          add   si,ax

                          push  cx
                          mov   cx, 16
    DrawLoop:             
                          call  DrawPiece
                          add   di,320
                          loop  DrawLoop
                          pop   cx
                          
                          cmp   bx,8
                          je    endPlayerOne
                
                          loop  PlayerOneLoop

    endPlayerOne:         
                          ret
DrawStatusColumn endp

RemoveSelections proc far

    ; Di Should Contain Either Address Of togo1, togo2
                          push  ax
                          push  bx
                          push  cx
                          push  dx
                          push  si
                          push  di
                          pushf

                          
    RemoveSelectionsLoop: 
                          mov   ah, 0
                          mov   al,[di]
                          cmp   al,0ffH
                          je    Finished

                          mov   [di],byte ptr 0ffH
                          inc   di

                          mov   si,offset Cells
                            
                          mov   bl,4
                          mul   bl

                            
                          mov   CellWidth,30
                          mov   CellHeight,20

                          add   si,ax
                          call  DrawCell
                          jmp   RemoveSelectionsLoop

    Finished:             
                          popf
                          pop   di
                          pop   si
                          pop   dx
                          pop   cx
                          pop   bx
                          pop   ax
                          retf



RemoveSelections endp

DrawSelections proc far

    ; di should contain togo1 or togo2

    ; Di Should Contain Either Address Of togo1, togo2

                          push  ax
                          push  bx
                          push  cx
                          push  dx
                          push  si
                          push  di
                          pushf


    DrawSelectionsLoop:   

                          mov   ah, 0
                          mov   al,[di]
                          cmp   al,0ffH
                          je    FinishedD

                          inc   di

                          mov   si,offset Cells
                            
                          mov   bl,4
                          mul   bl
                          
                          mov   CellWidth,30
                          mov   CellHeight,20

                          add   si,ax
                          call  DrawCell

                          jmp   DrawSelectionsLoop

    FinishedD:            
                          popf
                          pop   di
                          pop   si
                          pop   dx
                          pop   cx
                          pop   bx
                          pop   ax
                          retf


DrawSelections endp


getSystemTime proc far

                          push  ax
                          push  cx
                          push  bx

                          mov   SystemTime,0
                          mov   ah,2CH
                          int   21H
    ; Hours is in CH
    ; Minutes is in CL
    ; Seconds is in DH
                          mov   ax,0
                          mov   al,ch
                          mov   bl,24
                          mul   bl

                          add   SystemTime,ax

                          mov   ax,0
                          mov   al,cl
                          mov   bl,60
                          mul   bl

                          add   SystemTime,ax

                          mov   ax,0
                          mov   al,dh

                          add   SystemTime,ax
                          
                          pop   bx
                          pop   cx
                          pop   ax
                          retf
getSystemTime endp


KingOneChecked proc far

                          mov   dl, 0                             ; Column
                          mov   dh, 18                             ; Row
                          call  moveCursor
                          
                          mov   ah, 9
                          mov   dx, offset PlayerOneChecked
                          int   21h

                          retf
KingOneChecked endp


EraseOneChecked proc far
                          mov   dl, 0                             ; Column
                          mov   dh, 18                             ; Row
                          call  moveCursor
                          
                          mov   ah, 9
                          mov   dx, offset Eraser
                          int   21h

                          retf
EraseOneChecked endp

KingTwoChecked proc far
                          mov   dl, 155                             ; Column
                          mov   dh, 18                             ; Row
                          call  moveCursor
                          
                          mov   ah, 9
                          mov   dx, offset PlayerOneChecked
                          int   21h

                          retf

KingTwoChecked endp

EraseTwoChecked proc far
                          mov   dl, 155                             ; Column
                          mov   dh, 18                             ; Row
                          call  moveCursor
                          
                          mov   ah, 9
                          mov   dx, offset Eraser
                          int   21h

                          retf
EraseTwoChecked endp

moveCursor proc

                          mov   bx, 0                             ; Page number, 0 for graphics modes
                          mov   ah, 2h
                          int   10h
                          ret
moveCursor endp

end DrawBoard