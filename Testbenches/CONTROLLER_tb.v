module CONTROLLER_tb();
	`include "parameters.v"
	/*
		Control Signals:
			Clk - Clock Signals.
			Reset - Sets State to RESET and clears PC while HIGH.
			Opcode - Selects the action to be executed.
	*/
	reg Clk=0, Reset=0;
        reg [`OPCODE_WIDTH-1:0] Opcode=0;
	
	/*
		Outputs:
                        PC_Clr          - Clears the program counter to 0
                        PC_Load         - Loads Dest_Reg from the instruction register into the program counter
                        PC_Inc          - Increments the program counter by 1
                        IR_Load         - Loads a new set of instructions from the RAM into the instruction register
                        Reg_Load        - Loads the Reg_Data_In into the Dest_Reg for the general purpose registers
                        Alu_Add         - Makes arithmetic logic unit perform addition between its operands
                        Alu_Sub         - Makes arithmetic logic unit perform subtraction between its operands
                        Alu_Mul         - Makes arithmetic logic unit perform multplication between its operands
                        Alu_Pass        - Passes the first operand of the arithmetic logic unit into it's output
                        Ram_Data_Read   - Reads data from the address inputted into the random access memory
                        Ram_Data_Write  - Writes the data inputted into the random access memory at the inputted address
                        Ram_Inst_Read   - Reads instruction from the address inputted into the random access memory
                        Load_M          - Passes Source_Reg1 as the random access memory's address
                        Load_I          - Pass Source_Reg1 as the Reg_Data_In for the register into the Dest_Reg
	*/
	wire PC_Clr, PC_Load, PC_Inc, IR_Load, Reg_Load, Alu_Add, Alu_Sub, Alu_Mul, Alu_Pass, Ram_Data_Read, Ram_Data_Write, Ram_Inst_Read, Load_M, Load_I;

	CONTROLLER controller(
                .Clk(Clk),
                .Reset(Reset),
                .Opcode(Opcode),
                .PC_Clr(PC_Clr),
                .PC_Load(PC_Load),
                .PC_Inc(PC_Inc),
                .IR_Load(IR_Load),
                .Reg_Load(Reg_Load),
                .Alu_Add(Alu_Add),
                .Alu_Sub(Alu_Sub),
                .Alu_Mul(Alu_Mul),
                .Alu_Pass(Alu_Pass),
                .Ram_Data_Read(Ram_Data_Read),
                .Ram_Data_Write(Ram_Data_Write),
                .Ram_Inst_Read(Ram_Inst_Read),
                .Load_M(Load_M),
                .Load_I(Load_I)
	);

	integer in_file;	// Input file handle.
	integer out_file;	// Output file handle.
	integer status;		// Status of reading input file.
	integer address;	// Keeps track of the instruction's address.
	integer state;		// Keeps track of what state the Controller is in for one instruction. 
	integer inst;		// Holdsd the read instruction.
	integer run;		// Holds how many times to run the test.
	always #(`DUTY) Clk = ~Clk;
	initial begin
		$dumpfile("Junk/CONTROLLER.vcd");
		$dumpvars(0, CONTROLLER_tb);
		state = 0;
		// Checks if we are randomly generating values or using
		// a premade input list.
		if(`CONT_GEN_RAND_OPCODE) begin		// If we are randomly generating, perform `NUM_CONTROLER_ADDR tests
			run = `NUM_CONTROLLER_TEST;
		end 
		else begin				// Else, perform `NUM_MEM_ADDR tests
			run = `NUM_MEM_ADDR;
		end
		Reset = 1;
		#(`PERIOD);
		Reset = 0;

		in_file = $fopen("Testbenches/binary.mac", "r");
		out_file = $fopen("Results/CONTROLLER.r", "w");
		$fwrite(out_file, "Randomized Opcode = %b", `CONT_GEN_RAND_OPCODE);
		$fwrite(out_file, "\n\n");
		for(address = 0; address < run; address = address + 1) begin
			for(state = 0; state < `NUM_STATES; state = state + 1) begin
				#(`PERIOD);
				if(`CONT_GEN_RAND_OPCODE && IR_Load)
					Opcode = $urandom % 8;
				else if(IR_Load) begin
					status = $fscanf(in_file, "%b\n", inst);
					Opcode = inst[`OPCODE_UPPER_BIT-1:`OPCODE_LOWER_BIT];	
				end	
				$fwrite(out_file, "Address = %d", address);
				$fwrite(out_file, "\tReset = %b", Reset);
				$fwrite(out_file, "\tOpcode = %b", Opcode);
				$fwrite(out_file, "\tPC_Clr = %b", PC_Clr);
				$fwrite(out_file, "\tPC_Load = %b", PC_Load);
				$fwrite(out_file, "\t\tPC_Inc = %b", PC_Inc);
				$fwrite(out_file, "\t\tIR_Load = %b", IR_Load);
				$fwrite(out_file, "\t\tReg_Load = %b", Reg_Load);
				$fwrite(out_file, "\tAlu_Add = %b", Alu_Add);
				$fwrite(out_file, "\nState = %d", state);
				$fwrite(out_file, "\tAlu_Sub = %b", Alu_Sub);
				$fwrite(out_file, "\tAlu_Mul = %b", Alu_Mul);
				$fwrite(out_file, "\tAlu_Pass = %b", Alu_Pass);
				$fwrite(out_file, "\tRam_Data_Read = %b", Ram_Data_Read);
				$fwrite(out_file, "\tRam_Data_Write = %b", Ram_Data_Write);
				$fwrite(out_file, "\tRam_Inst_Read = %b", Ram_Inst_Read);
				$fwrite(out_file, "\tLoad_M = %b", Load_M);
				$fwrite(out_file, "\tLoad_I = %b\n\n\n", Load_I);
			end
				$fwrite(out_file, "\n\n----------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n\n");
		end
		#(`NUM_STATES*`PERIOD*`NUM_CONTROLLER_TEST);
		$fclose(in_file);
		$fclose(out_file);
		$finish();
		$stop;
	end
endmodule
