.model small

.data

currX DW ?
currY DW ?
MovesPlayed DW ?
Winner DW ?   
col DB ?
row DW ?
pointX DW ?
pointY DW ?
OpointX DW ?
OpointY DW ?
Xbox DW ?  
Obox DW ?
DrewX DW ?
drawn DB 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

.code
.startup
           
chk_win macro
    pusha     
    
    ; VERTICAL
    MOV CX, 3
    MOV Winner, 0000
    V1:    
    MOV SI, CX
    SUB SI, 1
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endvl1
    ADD Winner, 1
    
    endvl1:
    LOOP V1
    
    MOV BX, 3
    CMP BX, Winner
    JZ FinishChk
    
    MOV CX, 3
    MOV Winner, 0000
    V2:
    MOV SI, CX
    ADD SI, 2
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endvl2
    ADD Winner, 1
    
    endvl2:
    LOOP V2      
    
    MOV BX, 3
    CMP BX, Winner
    JZ FinishChk
        
    
    MOV CX, 3
    MOV Winner, 0000
    V3:
    MOV SI, CX
    ADD SI, 5
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endvl3
    ADD Winner, 1 
    
    endvl3:
    LOOP V3
    
    MOV BX, 3
    CMP BX, Winner
    JZ FinishChk
    
    ; HORIZONTAL
    MOV CX, 3
    MOV BX, 0 
    MOV Winner, 0000
    H1:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endhl1
    ADD Winner, 1
    ADD BX, 3
    
    endhl1:
    LOOP H1
           
    MOV BX, 3
    CMP BX, Winner
    JZ FinishChk
    
    
    MOV CX, 3
    MOV BX, 1 
    MOV Winner, 0000
    H2:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endhl2
    ADD Winner, 1
    ADD BX, 3
    
    endhl2:
    LOOP H2
    
    MOV BX, 3
    CMP BX, Winner
    JZ FinishChk
    
    MOV CX, 3
    MOV BX, 2 
    MOV Winner, 0000
    H3:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ endhl3
    ADD Winner, 1
    ADD BX, 3
    
    endhl3:
    LOOP H3
    
    MOV BX, 3
    CMP BX, Winner
    JZ FinishChk
    
    MOV CX, 3
    MOV BX, 0 
    MOV Winner, 0000
    D1:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ enddl1
    ADD Winner, 1
    ADD BX, 4
    
    enddl1:
    LOOP D1
    
    MOV BX, 3
    CMP BX, Winner
    JZ FinishChk


    MOV CX, 3
    MOV BX, 2
    MOV Winner, 0000
    D2:
    MOV SI, BX
    MOV AL, drawn[SI]
    CMP AL, 1
    JNZ enddl2
    ADD Winner, 1
    ADD BX, 4
    
    enddl2:
    LOOP D2
 
 
    FinishChk:
    popa
endm 


    
drawX macro spx, spy
    pusha     
    
    MOV SI, Xbox
    MOV AL, drawn[SI]
    CMP AL, 0
    MOV DrewX, 0000h
    JNZ FINISH
    
    MOV BL, 1
    MOV SI, Xbox
    MOV drawn[SI], BL  
    
    MOV AL, 0Eh
    MOV AH, 0Ch
    
    
    MOV CX, spx
    MOV DX, spy
    MOV BX, 50D
    ADD BX, spx
    
    DrawLeft:
    INT 10h
    INC CX
    INC DX
    CMP BX, CX
    JNZ DrawLeft
    
    MOV CX, spx
    ADD CX, 50D
    MOV DX, spy
    MOV BX, CX
    SUB BX, 50D
    
    DrawRight:
    INT 10H
    DEC CX
    INC DX
    CMP BX, CX
    JNZ DrawRight
    
    MOV DrewX, 1    
    popa
    FINISH:
endm


drawO macro OX, OY
    pusha
    
    chk_clear:
    MOV SI, Obox
    MOV AL, drawn[SI]
    CMP AL, 0
    JZ good
    
    INC Obox
    MOV CX, 9
    CMP CX, Obox
    JA OboxLoc
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
    MOV CX, OX
    MOV DX, OY
    INT 10h
    
    popa
    FINISHO:
endm


 
START:
MOV AH, 0h
MOV AL, 12h
INT 10h


MOV AL, 0Eh
MOV AH, 0Ch

MOV CX, 170
MOV DX, 190
MOV BX, 470


HTOP:
INT 10h
INC CX
CMP BX, CX
JNZ HTOP

MOV CX, 170
MOV DX, 290
MOV BX, 470


HLOW:
INT 10h
INC CX
CMP BX, CX
JNZ HLOW


MOV CX, 370
MOV DX, 90
MOV BX, 390


VRIGHT:
INT 10h
INC DX
CMP BX, DX
JNZ VRIGHT


MOV CX, 270
MOV DX, 90
MOV BX, 390


VLEFT:
INT 10h
INC DX
CMP BX, DX
JNZ VLEFT


mov ax, 1003h ; disable blinking.  
mov bx, 0        
int 10h

; hide text cursor:
mov ch, 32
mov ah, 1
int 10h

; display mouse cursor:
mov ax, 1
int 33h

where:
MOV AX, 3
INT 33h
MOV currX, CX
MOV currY, DX
CMP BX, 1
JZ chk_bounds
JNZ where
JMP DONE


chk_bounds:
; For some unknown reason, the value of the x-coordinate
; is doubled. This very problem took me days to solve.


MOV AX, 0154h
CMP AX, currX
JA where

MOV AX, 03ACh
CMP AX, currX
JB where

MOV AX, 05Ah
CMP AX, currY
JA where

MOV AX, 0186h
CMP AX, currY
JB where 


; DETERMINING THE EXACT POSTION,
; IN TERMS OF ROWS AND COLUMNS

; Friendly reminder: remember to put values in hex
; and the x-coordinate is doubled.

chk_x:
MOV AX, 021Ch
CMP AX, currX
JB chk_x_2
MOV col, 1
MOV pointX, 195D
JMP chk_y

chk_x_2:
MOV AX, 02E4h
CMP AX, currX
JB assignc3
MOV col, 2
MOV pointX, 295D 
JMP chk_y

assignc3:
MOV col, 3
MOV pointX, 395D  
JMP chk_y

chk_y:
MOV AX, 0BEh
CMP AX, currY
JB chk_y_2
MOV row, 1
MOV pointY, 115D
JMP stat

chk_y_2:
MOV AX, 0122h
CMP AX, currY
JB assignr3
MOV row, 2
MOV pointY, 215D
JMP stat  

assignr3:
MOV row, 3
MOV pointY, 315D  
JMP stat


stat:
MOV BL, 1
CMP col, 1
JNZ chk_col2
MOV AX, row
MOV Xbox, AX
SUB Xbox, 1
JMP DRAW

chk_col2:
CMP col, 2
JNZ chk_col3 
MOV AX, row
MOV Xbox, AX
ADD Xbox, 2
JMP DRAW

chk_col3:   
MOV AX, row
MOV Xbox, AX
ADD Xbox, 5
JMP DRAW

DRAW:
drawX pointX, pointY 

MOV BX, 1
CMP BX, DrewX
JNZ where

MOV AX, Xbox
MOV Obox, AX
ADD Obox, 4
MOV CX, 9
CMP CX, Obox
JA OboxLoc   
MOV DX, 0000h
MOV AX, Obox
DIV CX
MOV Obox, DX

OboxLoc:
MOV BX, 0
CMP BX, Obox
JNZ chk_obox1
MOV OpointX, 0DCh
MOV OpointY, 08Ch 
JMP dro

chk_obox1:
MOV BX, 1
CMP BX, Obox
JNZ chk_obox2
MOV OpointX, 0DCh 
MOV OpointY, 0F0h 
JMP dro

chk_obox2:
MOV BX, 2         
CMP BX, Obox
JNZ chk_box3
MOV OpointX, 0DCh 
MOV OpointY, 0154h
JMP dro           

chk_box3:
MOV BX, 3
CMP BX, Obox
JNZ chk_box4
MOV OpointX, 0140h
MOV OpointY, 08Ch
JMP dro

chk_box4:
MOV BX, 4
CMP BX, Obox
JNZ chk_box5
MOV OpointX, 0140h
MOV OpointY, 0F0h
JMP dro

chk_box5:
MOV BX, 5
CMP BX, Obox
JNZ chk_box6
MOV OpointX, 0140h
MOV OpointY, 0154h
JMP dro

chk_box6:
MOV BX, 6
CMP BX, Obox
JNZ chk_box7
MOV OpointX, 01A4h
MOV OpointY, 08Ch
JMP dro

chk_box7:
MOV BX, 7
CMP BX, Obox
JNZ chk_box8
MOV OpointX, 01A4h
MOV OpointY, 0F0h
JMP dro

chk_box8:
MOV OpointX, 01A4h
MOV OpointY, 0154h 

dro:




drawO OpointX, OpointY
 
MOV Winner, 0000h 
chk_win


MOV BX, 3
CMP BX, Winner
JZ DONE 


JMP where

DONE:
end