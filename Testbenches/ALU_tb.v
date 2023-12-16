module ALU_tb();
	`include "../parameters.v"

	/*
		Control Signals:
			Alu_Add - Performs addition between Reg1_Out & Reg2_Out.
			Alu_Sub - Performs subtraction between Reg1_Out & Reg2_Out.
			Alu_Mul - Performs multiplication between Reg1_Out & Reg2_Out.
			Alu_Padd - Passes Reg2_Out to Alu_Out.
	*/
	reg Alu_Add=0, Alu_Sub=0, Alu_Mul=0, Alu_Pass=0;
	/*
		Inputs:
			Reg1_Out - Operand 1.
			Reg2_Out - Operand 2 or value to be stored in memory.
	*/
	reg [`DATA_WIDTH-1:0] Reg1_Out=0, Reg2_Out=0;

	/*
		Output:
			Alu_Out - Output from the ALU.
	*/
        wire [`DATA_WIDTH-1:0] Alu_Out;
	
	ALU arithmetic_logic_unit(
		.Alu_Add(Alu_Add),
		.Alu_Sub(Alu_Sub),
		.Alu_Mul(Alu_Mul),
		.Alu_Pass(Alu_Pass),
		.Reg1_Out(Reg1_Out),
		.Reg2_Out(Reg2_Out),
		.Alu_Out(Alu_Out)
	);
	
	integer file;
	integer test;
	integer operation;
	initial begin
		$dumpfile("../Junk/ALU.vcd");
		$dumpvars(0, ALU_tb);
		file = $fopen("../Results/ALU.r", "w");
		for(test = 0; test < `NUM_ALU_TEST; test = test + 1) begin
			operation = $urandom % 4;	// Used to determine what operation is perform
			if(operation == 0) 
				Alu_Add = 1;
			else if(operation == 1) 
				Alu_Sub = 1;
			else if(operation == 2) 
				Alu_Mul = 1;
			else if(operation == 3) 
				Alu_Pass = 1;
			Reg1_Out = $urandom % (`REG_UPPER_BOUND-`REG_LOWER_BOUND+1) + `REG_LOWER_BOUND;	
			Reg2_Out = $urandom % (`REG_UPPER_BOUND-`REG_LOWER_BOUND+1) + `REG_LOWER_BOUND;	
			#5;
			$fwrite(file, "Test = %d", test);	
			$fwrite(file, "\tAlu_Add = %b", Alu_Add);	
			$fwrite(file, "\tAlu_Sub = %b", Alu_Sub);	
			$fwrite(file, "\tAlu_Mul = %b", Alu_Mul);	
			$fwrite(file, "\tAlu_Pass = %b", Alu_Pass);	
			$fwrite(file, "\tReg1_Out = %d", Reg1_Out);	
			$fwrite(file, "\tReg2_Out = %d", Reg2_Out);	
			$fwrite(file, "\tAlu_Out = %d\n\n", Alu_Out);	
			Alu_Add = 0;
			Alu_Sub = 0;
			Alu_Mul = 0;
			Alu_Pass = 0;
		end
		$fclose(file);
		$finish();
		$stop;
	end
endmodule

