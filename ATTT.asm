.MODEL SMALL

.DATA

; Holds current x-coordinate of the cursor position.
currX       DW ?                                    

; Hold current y-coordinate of the cursor position.
currY       DW ?                                   

; Counts how many moves were played.
MovesPlayed DW ?                                   

; 
Winner      DW ?                                   

; Order of the coloum in which the cursor was clicked   
col         DB ?

; Order of the row in which the cursor was clicked
row         DW ?

; X-coordinate for drawing X.
XpointX     DW ?            

; Y-coordinate for drawing X.
XpointY     DW ?                                       

; X-coordinate for darwing O.
OpointX     DW ?            

; Y-coordinate for drawing O.
OpointY     DW ?                                      

; Holds the order of the box in which X will be drawn.
Xbox        DW ?

; Holds the order of the box in which O will be drawn.  
Obox        DW ?

; To check if X drew or not.
DrewX       DW ?            

; Celebration message
celebrationMessage DB "WINNER WINNER CHICKEN DINNER!"

; Emu8086 refused to intialize the array
; with the normal definition drawn DB TIMES 9 00h. 
drawn DB 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h 

; That's how the array is represented
;
;       |   |
;     0 | 3 | 6
;    ___|___|___
;       |   |
;     1 | 4 | 7
;    ___|___|___
;       |   |
;     2 | 5 | 9
;       |   |




.CODE
.STARTUP
                          
                          
                          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;  MACRO DEFINITIONS  ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clearScreen MACRO
    PUSHA
    
    MOV AX, 0600h
    MOV BH, 15 
    MOV DH, 24
    MOV DL, 79
    INT 10h
    
    POPA
ENDM 
                          
checkWin MACRO
    ; Checks for three consective 1's in the array drawn.
    ; Checks vertically, horizontally, and diagonally.
    
    PUSHA     
    
    ; Vertical
    MOV CX, 3
    MOV Winner, 0000h
    Vertical1:    
    MOV SI, CX
    SUB SI, 1
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endVertical1
    ADD Winner, 1
    
    endVertical1:
    LOOP vertical1
    
    MOV BX, 3
    CMP BX, Winner
    JZ finishWinChk
    
    MOV CX, 3
    MOV Winner, 0000h
    Vertical2:
    MOV SI, CX
    ADD SI, 2
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endVertical2
    ADD Winner, 1
    
    endVertical2:
    LOOP Vertical2      
    
    MOV BX, 3
    CMP BX, Winner
    JZ finishWinChk
        
    
    MOV CX, 3
    MOV Winner, 0000h
    Vertical3:
    MOV SI, CX
    ADD SI, 5
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endVertical3
    ADD Winner, 1 
    
    endVertical3:
    LOOP Vertical3
    
    MOV BX, 3
    CMP BX, Winner
    JZ finishWinChk
    
    ; HORIZONTAL
    MOV CX, 3
    MOV BX, 0 
    MOV Winner, 0000h
    Horizontal1:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endHorizontal1
    ADD Winner, 1
    ADD BX, 3
    
    endHorizontal1:
    LOOP Horizontal1
           
    MOV BX, 3
    CMP BX, Winner
    JZ finishWinChk
    
    
    MOV CX, 3
    MOV BX, 1 
    MOV Winner, 0000h
    Horizontal2:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endHorizontal2
    ADD Winner, 1
    ADD BX, 3
    
    endHorizontal2:
    LOOP Horizontal2
    
    MOV BX, 3
    CMP BX, Winner
    JZ finishWinChk
    
    MOV CX, 3
    MOV BX, 2 
    MOV Winner, 0000h
    Horizontal3:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endHorizontal3
    ADD Winner, 1
    ADD BX, 3
    
    endHorizontal3:
    LOOP Horizontal3
    
    MOV BX, 3
    CMP BX, Winner
    JZ finishWinChk
    
    MOV CX, 3
    MOV BX, 0 
    MOV Winner, 0000h
    Diagonal1:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endDiagonal1
    ADD Winner, 1
    ADD BX, 4
    
    endDiagonal1:
    LOOP Diagonal1
    
    MOV BX, 3
    CMP BX, Winner
    JZ finishWinChk


    MOV CX, 3
    MOV BX, 2
    MOV Winner, 0000h
    Diagonal2:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endDiagonal2
    ADD Winner, 1
    ADD BX, 4
    
    endDiagonal2:
    LOOP Diagonal2
 
 
    finishWinChk:
    POPA
ENDM


    
drawX MACRO startPointX, startPointY
    PUSHA
    
    ; Chekc if there's already something drawn in the box.
    ; If so, it'll wait for another input.
    
    MOV SI, Xbox
    MOV AL, drawn[SI]
    CMP AL, 0
    MOV DrewX, 0000h
    JNZ FINISH
    
    MOV BL, 1
    MOV SI, Xbox
    MOV drawn[SI], BL  
 
    ; Start of drawing
    
    MOV AL, 0Eh
    MOV AH, 0Ch   
    
    MOV CX, startPointX
    MOV DX, startPointY
    MOV BX, 50D
    ADD BX, startPointX
    
    DrawLeft:
    INT 10h
    INC CX
    INC DX
    CMP BX, CX
    JNZ DrawLeft
    
    MOV CX, startPointX
    ADD CX, 50D
    MOV DX, startPointY
    MOV BX, CX
    SUB BX, 50D
    
    DrawRight:
    INT 10H
    DEC CX
    INC DX
    CMP BX, CX
    JNZ DrawRight
    
    MOV DrewX, 1
        
    POPA
    FINISH:
ENDM


drawO MACRO centerPointX, centerPointY
    PUSHA
    
    ; Checks if there's something drawn in the box.
    ; If so, it'll increment the position by one and recheck.
    
    chk_clear:
    MOV SI, Obox
    MOV AL, drawn[SI]
    CMP AL, 0
    JZ good
    
    INC Obox
    MOV CX, 9
    CMP CX, Obox
    JA getOboxOrder
    MOV DX, 0000h
    MOV AX, Obox
    DIV CX
    MOV DX, Obox
    JMP chk_clear
    
    good:
    MOV SI, Obox
    MOV AL, 2
    MOV drawn[SI], AL
    MOV AL, 0Eh
    MOV AH, 0Ch 
    MOV CX, centerPointX
    MOV DX, centerPointY
    INT 10h
    
    POPA
    FINISHO:
ENDM
                          
                          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;     MAIN PROGRAM    ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
START:

; Set video mode at 640x480 pixels 
MOV AH, 0h
MOV AL, 12h
INT 10h


MOV AL, 0Eh
MOV AH, 0Ch

MOV CX, 170
MOV DX, 190
MOV BX, 470


horizontalTop:
INT 10h
INC CX
CMP BX, CX
JNZ horizontalTop

MOV CX, 170
MOV DX, 290
MOV BX, 470


horizontalLow:
INT 10h
INC CX
CMP BX, CX
JNZ horizontalLow


MOV CX, 370
MOV DX, 90
MOV BX, 390


verticalRight:
INT 10h
INC DX
CMP BX, DX
JNZ verticalRight


MOV CX, 270
MOV DX, 90
MOV BX, 390


verticalLeft:
INT 10h
INC DX
CMP BX, DX
JNZ verticalLeft

; Finished drawing.


; Mouse initialization. Any previous mouse pointer is hidden. 
; Disable blinking:

MOV AX, 1003h
MOV BX, 0000h
INT 10h

; Hide text cursor:
MOV CH, 32
MOV AH, 1
INT 10h

; Display mouse cursor:
MOV AX, 1
INT 33h


; Get position (in terms of X and Y) of the pointer

getPointerLocation:
MOV AX, 3
INT 33h
MOV currX, CX
MOV currY, DX
CMP BX, 1
JZ chk_bounds
JNZ getPointerLocation


; Check if the the position was outside of the box.
; If so, wait for another input (click) by the user.

chk_bounds:
; For some unknown reason, the value of the x-coordinate (CX register)
; is doubled. This very problem took me days to solve.

MOV AX, 0154h
CMP AX, currX
JA getPointerLocation

MOV AX, 03ACh
CMP AX, currX
JB getPointerLocation

MOV AX, 05Ah
CMP AX, currY
JA getPointerLocation

MOV AX, 0186h
CMP AX, currY
JB getPointerLocation 


; Determining the exact position, in terms of rows and coloums.
; The goal is to set the Start Point to in which drawing X will start from.
; Friendly reminder: remember to put values in hex, and the x-coordinate is doubled.

checkHorizontal1:
MOV AX, 021Ch
CMP AX, currX
JB checkHorizontal2
MOV col, 1
MOV XpointX, 195D
JMP checkVertical1

checkHorizontal2:
MOV AX, 02E4h
CMP AX, currX
JB checkHorizontal3
MOV col, 2
MOV XpointX, 295D 
JMP checkVertical1

checkHorizontal3:
MOV col, 3
MOV XpointX, 395D  
JMP checkVertical1

checkVertical1:
MOV AX, 0BEh
CMP AX, currY
JB checkVertical2
MOV row, 1
MOV XpointY, 115D
JMP getXboxOrder

checkVertical2:
MOV AX, 0122h
CMP AX, currY
JB checkVertical3
MOV row, 2
MOV XpointY, 215D
JMP getXboxOrder  

checkVertical3:
MOV row, 3
MOV XpointY, 315D  
JMP getXboxOrder

; Determine the order of the box in which X will be drawn
; If it is in the first column, then the position = row - 1
; If the second column it is, position = row + 2
; If the third column it is, position =  row + 5
; Please see the figure the start of this code for clarification.

getXboxOrder:
MOV BL, 1
CMP col, 1
JNZ checkColumn2
MOV AX, row
MOV Xbox, AX
SUB Xbox, 1
JMP STARTDRAWX

checkColumn2:
CMP col, 2
JNZ checkColumn3 
MOV AX, row
MOV Xbox, AX
ADD Xbox, 2
JMP STARTDRAWX

checkColumn3:   
MOV AX, row
MOV Xbox, AX
ADD Xbox, 5
JMP STARTDRAWX
          
          
; Starts drawing X.
          
STARTDRAWX:
drawX XpointX, XpointY 

; Calculates the position of O and starts drawing it.

; If X wasn't drawn, for some reason, it would get the 
; position of the pointer and attempt drawing again.

MOV BX, 1          
CMP BX, DrewX
JNZ getPointerLocation

MOV AX, Xbox
MOV Obox, AX

; This determines how far from X will O be drawn. 

ADD Obox, 5                                      

; If the calculated order of O box is greater than 9,
; it will be divided and the modulus will be taken as the position.

MOV CX, 9                                        
CMP CX, Obox
JA getOboxOrder   
MOV DX, 0000h
MOV AX, Obox
DIV CX
MOV Obox, DX

getOboxOrder:
MOV BX, 0
CMP BX, Obox
JNZ checkBox1
MOV OpointX, 0DCh
MOV OpointY, 08Ch 
JMP STARTDRAWO

checkBox1:
MOV BX, 1
CMP BX, Obox
JNZ checkBox2
MOV OpointX, 0DCh 
MOV OpointY, 0F0h 
JMP STARTDRAWO

checkBox2:
MOV BX, 2         
CMP BX, Obox
JNZ checkBox3
MOV OpointX, 0DCh 
MOV OpointY, 0154h
JMP STARTDRAWO           

checkBox3:
MOV BX, 3
CMP BX, Obox
JNZ checkBox4
MOV OpointX, 0140h
MOV OpointY, 08Ch
JMP STARTDRAWO

checkBox4:
MOV BX, 4
CMP BX, Obox
JNZ checkBox5
MOV OpointX, 0140h
MOV OpointY, 0F0h
JMP STARTDRAWO

checkBox5:
MOV BX, 5
CMP BX, Obox
JNZ checkBox6
MOV OpointX, 0140h
MOV OpointY, 0154h
JMP STARTDRAWO

checkBox6:
MOV BX, 6
CMP BX, Obox
JNZ checkBox7
MOV OpointX, 01A4h
MOV OpointY, 08Ch
JMP STARTDRAWO

checkBox7:
MOV BX, 7
CMP BX, Obox
JNZ checkBox8
MOV OpointX, 01A4h
MOV OpointY, 0F0h
JMP STARTDRAWO

checkBox8:
MOV OpointX, 01A4h
MOV OpointY, 0154h 


; Starts drawing O.

STARTDRAWO:

drawO OpointX, OpointY

; Checks if X won.

MOV Winner, 0000h 
checkWin

MOV BX, 3
CMP BX, Winner
JZ celebrateWinning 


JMP getPointerLocation

celebrateWinning:
clearScreen

; Set cursor position.
MOV AH, 2
MOV DH, 15 
MOV DL, 25
MOV BH, 0
INT 10h

; Display the celebration message.

MOV CX, 29
writeCharacter:
MOV SI, CX
MOV DL, celebrationMessage[SI]
MOV AH, 2
INT 21h
INC CX
CMP CX, 30
JNZ writeCharacter



DONE:
END