module CONTROLLER(Clk, Reset, Opcode, PC_Clr, PC_Load, PC_Inc, IR_Load, Reg_Load, Alu_Add, Alu_Sub, Alu_Mul, Alu_Pass, Ram_Data_Read, Ram_Data_Write, Ram_Inst_Read, Load_M, Load_I);
	`include "parameters.v"
	/*
		Inputs:
			Clk    - Clock Signals
			Reset  - Returns and keeps program in RESET state
			Opcode - The instructions opcode
	*/
       input Clk, Reset;
       input [`OPCODE_WIDTH-1:0] Opcode;

       /*
       		Ouputs:
			PC_Clr  	- Clears the program counter to 0
	     		PC_Load 	- Loads Dest_Reg from the instruction register into the program counter
	    		PC_Inc  	- Increments the program counter by 1
	    		IR_Load 	- Loads a new set of instructions from the RAM into the instruction register
	    		Reg_Load 	- Loads the Reg_Data_In into the Dest_Reg for the general purpose registers
	    		Alu_Add 	- Makes arithmetic logic unit perform addition between its operands
       			Alu_Sub 	- Makes arithmetic logic unit perform subtraction between its operands
       			Alu_Mul  	- Makes arithmetic logic unit perform multplication between its operands
       			Alu_Pass 	- Passes the first operand of the arithmetic logic unit into it's output
       			Ram_Data_Read 	- Reads data from the address inputted into the random access memory
       			Ram_Data_Write	- Writes the data inputted into the random access memory at the inputted address
       			Ram_Inst_Read 	- Reads instruction from the address inputted into the random access memory
       			Load_M 		- Passes Source_Reg1 as the random access memory's address
       			Load_I 		- Pass Source_Reg1 as the Reg_Data_In for the register into the Dest_Reg
       */
      	output reg PC_Clr, PC_Load, PC_Inc, IR_Load, Reg_Load, Alu_Add, Alu_Sub, Alu_Mul, Alu_Pass, Ram_Data_Read, Ram_Data_Write, Ram_Inst_Read, Load_M, Load_I;
      	
	// Holds the what state the processor is in.
	reg [2:0] PresentState, NextState;

	// Updates the present state
 	always @(posedge Clk) begin
		PresentState <= Reset ? `RESET : NextState;
      	end
	// Any updates to the states determine what signals need to be sent
	always @(PresentState or Reset) begin
	      	// Clears PC Control Signals //
		PC_Clr  <= 0;
		PC_Load <= 0;
	    	PC_Inc  <= 0;
	      	// Clears IR Control Signal //
	      	IR_Load <= 0;
	      	// Clears Registers Control Signal //
	      	Reg_Load <= 0;
	      	// Clears ALU Control Signals //
	      	Alu_Add  <= 0;
	      	Alu_Sub  <= 0;
	      	Alu_Mul  <= 0;
	      	Alu_Pass <= 0;
	      	// Clears RAM Control Signals //
	      	Ram_Data_Read  <= 0;
	      	Ram_Data_Write <= 0;
	      	Ram_Inst_Read  <= 0;
	      	// Clears Other Control Signals //
	      	Load_M <= 0;
	      	Load_I <= 0;
	      	case(PresentState) 
		// The processor is idling
		`RESET : begin	
			NextState = Reset ? `RESET : `FETCH;
			PC_Clr    <= 1;
		end
		// Gets instructions from memory
      		`FETCH : begin
			NextState  = `DECODE;
	        	Ram_Inst_Read <= 1;
      		end
		// Decode the instructions
      		`DECODE : begin
	  	        NextState = `EXECUTE;
	  	        IR_Load   <= 1;
	        end
		// Performs the instruction
      		`EXECUTE : begin
			NextState = `WAIT;
	        	case(Opcode)
		        `DONE    : begin
				NextState      = `WAIT; // Moves to next state. 
		        end
		        `LOAD_M  : begin
				Load_M         <= 1; // Passes Source_Reg1 as Ram_Addr.
				Ram_Data_Read  <= 1; // Reads the data at Source_Reg1.
				Reg_Load       <= 1; // Loads the data into Dest_Reg.
		        end
		        `LOAD_I  : begin
				Load_I         <= 1; // Passes in Source_Reg1 as Reg_Data_In.
				Reg_Load       <= 1; // Loads Source_Reg1 as the value for Dest_Reg.
		        end
		        `LOAD_PC : begin
		        	PC_Load        <= 1; // Loads Dest_Reg into the program counter.
		        end
		        `STORE   : begin
		        	Load_M         <= 1; // Passes Source_Reg1 as Ram_Addr.
		        	Alu_Pass       <= 1; // Passes Reg2_Out as the Ram_Data_In.
		        	Ram_Data_Write <= 1; // Write Ram_Data_In into memory at Source_Reg1.
		        end
		        `ADD     : begin
		        	Alu_Add        <= 1; // Performs additon between Reg1_Out and Reg2_Out.
		        	Reg_Load       <= 1; // Loads Alu_Out into Dest_Reg.
		        end
		        `SUB     : begin
				Alu_Sub        <= 1; // Performs subtraction between Reg1_Out and Reg2_Out.
				Reg_Load       <= 1; // Loads Alu_Out into Dest_Reg.
		        end
		        `MUL     : begin
				Alu_Mul        <= 1; // Performs multiplication between Reg1_Out and Reg2_Out.
				Reg_Load       <= 1; // Loads Alu_Out into Dest_Reg.
		        end
		        default : begin
				NextState       = `RESET; // Catch case: Reset system.
				PC_Clr         <= 1;      // Clear program counter.
		        end
	        	endcase
		end
		// Holds for the instruction to finish
      		`WAIT : begin
			// Performs the exact same operations as EXECUTE, but
			// increments the program counter.
			NextState = `FETCH;
	        	case(Opcode)
		        `DONE    : begin
				NextState      = `FETCH; // Exception: Does not increment program counter.
		        end
		        `LOAD_M  : begin
				Load_M         <= 1;
				Ram_Data_Read  <= 1;
				Reg_Load       <= 1;
				PC_Inc 	       <= 1;
		        end
		        `LOAD_I  : begin
				Load_I         <= 1;
				Reg_Load       <= 1;
				PC_Inc 	       <= 1;
		        end
		        `LOAD_PC : begin
		        	PC_Load        <= 1;
		        	PC_Inc 	       <= 1;
		        end
		        `STORE   : begin
		        	Load_M         <= 1;
		        	Alu_Pass       <= 1;
		        	Ram_Data_Write <= 1;
		        	PC_Inc 	       <= 1;
		        end
		        `ADD     : begin
		        	Alu_Add        <= 1;
		        	Reg_Load       <= 1;	
		        	PC_Inc 	       <= 1;
		        end
		        `SUB     : begin
				Alu_Sub        <= 1;
				Reg_Load       <= 1;	
				PC_Inc 	       <= 1;
		        end
		        `MUL     : begin
				Alu_Mul        <= 1;
				Reg_Load       <= 1;
				PC_Inc 	       <= 1;
		        end
		        default : begin
				NextState       = `RESET;
				PC_Clr         <= 1;
		        end
	        	endcase
		end
		endcase
	end	
endmodule
