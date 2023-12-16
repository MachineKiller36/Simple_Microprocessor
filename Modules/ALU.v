// Arithmetic Logic Unit
module ALU(Alu_Add, Alu_Sub, Alu_Mul, Alu_Pass, Reg1_Out, Reg2_Out, Alu_Out); 
	`include "parameters.v"	
	/*
		Control Signals:
			Alu_Add : Performs addition between the to Source_Reg values
			Alu_Sub : Performs subtraction between the to Source_Reg values
			Alu_Mul : Performs multiplication between the to Source_Reg values
			Alu_Pass : Passes Source_Reg2 into Alu_Out
	*/
	input Alu_Add, Alu_Sub, Alu_Mul, Alu_Pass;
	/*
		Input Registers:
			Source_Reg1 : Operand 1
			Reg2_Out :    Operand 2 and is used for the value to be stored in memory 
	*/
	input [`DATA_WIDTH-1:0] Reg1_Out, Reg2_Out;
	//	Output
	output reg [`DATA_WIDTH-1:0] Alu_Out;
	
	always @(*) begin
		if(Alu_Add) 	  Alu_Out = Reg1_Out + Reg2_Out;
		else if(Alu_Sub)  Alu_Out = Reg1_Out - Reg2_Out;
		else if(Alu_Mul)  Alu_Out = Reg1_Out * Reg2_Out;
		else if(Alu_Pass) Alu_Out = Reg2_Out;
		else		  Alu_Out = 0;
	end
endmodule
