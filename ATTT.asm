.model small

.data

currX DW ?
currY DW ?   
col DB ?
row DW ?
pointX DW ?
pointY DW ?
box DW ?
drawn DB 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h

.code
.startup
           

drawX macro spx, spy
    pusha     
    
    MOV SI, box
    MOV AL, drawn[SI]
    CMP AL, 1
    JZ FINISH
    
    MOV BL, 1
    MOV SI, box
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
        
    popa
    FINISH:
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
MOV box, AX
SUB box, 1
JMP DRAW

chk_col2:
CMP col, 2
JNZ chk_col3 
MOV AX, row
MOV box, AX
ADD BOX, 2
JMP DRAW

chk_col3:   
MOV AX, row
MOV box, AX
ADD box, 5
JMP DRAW

DRAW:
drawX pointX, pointY

JMP where

DONE:
end