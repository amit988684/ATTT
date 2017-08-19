.model small

.data

currX DW ?
currY DW ?
tester DW ?

.code
.startup             

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
JZ chk_bound
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


DONE:
end