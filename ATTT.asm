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
JZ chk
JNZ where
JMP DONE


chk:
; For some unknown reason, you need to
; divide the x-axis value by two.
; This very problem took me days to solve.

;MOV AX, currX 
;MOV BX, 0002h
;MOV DX, 0000h ; to avoid overflow, since this is a 16-bit divison
;DIV BX
;MOV AH, 00 
;MOV currX, AX
;MOV tester, AX

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


MOV AX, 7





DONE:
end