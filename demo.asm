LOAD R0, #10		; R0 = 10
LOAD R1, #5		; R1 = 5
ADD R2, R0, R1		; R2 = R0 + R1 --> R2 = 15
SUB R3, R0, R1		; R3 = R0 - R1 --> R3 = 5
SUB R4, R1, R0		; R4 = R1 - R0 --> R4 = -5
MUL R5, R0, R1		; R5 - R0 * R1 --> R5 = 50
STORE =0, R2		; Memory[0] = R2
STORE =1, R3		; Memory[1] = R3
STORE =2, R4		; Memory[2] = R4
STORE =3, R5		; Memory[3] = R5
LOAD PC, =10		; PC = 10
DONE			; Assembler disregards everything below this and fills the rest of the isntruction memory with 0
LOAD R0, #25		; This is will never be assembled
