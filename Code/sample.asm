;
; Sample program showing syntax rules
;
;	Non-alphabetical, non-numerical, and non-reserved operators do not affect
;	There is no case or space sensitivi1ty.
;	  
;	Keywords:
;		LOAD 	- It is used to load an immediate value or a value from memory into a register.
;			Format: 	LOAD _destination register_  (#/=) _value/address_
;		
;		Store	- It is used to store a register value into a memory address.
;			Format:		STORE =_memory address_  _source register_
;		
;		ADD/SUB/MUL - Performs addition(ADD), subtraction(SUB), or multiplication(MUL)
;			Format:		(ADD/SUB/MUL) _destination register_  _source register1_  _source register2_;
;		DONE - Stops processor from reading instructions and assembler removes any instructions below this.
;			Format:		DONE
;
;	Operators:
;		# - Indicats an immediate value
;		= - Indicates a memory address
;		; - Indicates a comment
;	Registers are: R0, R1, R2, R3, R4, R5, R6, R7, and PC
;		Notes:
;			PC in the program counter and will change the instruction address being read by the processor.
;			But the instruction line number you want it to go to (IGNORE all comment and blank lines)
LOADR0#10

L,O,A,D,R,2,#,5,

L'O'A'D'R'1'='1'0

ADD	R3	R0	R1
STORE =10, R1
load r0, #63

SuB R1, R'2' ' R 3 	

LOAD R0 #0
LOAD R1 #1
ADD R0 R0 R1	; PC jumps to here
LOAD PC =9	; Load PC


LOADR0#10

L,O,A,D,R,2,#,5,

L'O'A'D'R'1'='1'0

ADD     R3      R0      R1

load r0, #63

SuB R1, R'2' ' R 3

LOAD R0 #0
LOAD R1 #1
ADD R0 R0 R1    ; PC jumps to here
LOAD PC =9      ; Load PCLOAD R1 =5
DONE
