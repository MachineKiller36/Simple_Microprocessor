module IR(Clk, IR_Load, Ram_Inst_Out, Opcode, Source_Reg1, Source_Reg2, Dest_Reg);
	`include "parameters.v"
	/*
		Control Signals:
			Clk     - Clock signal
			IR_Load - Loads Ram_Inst_Out
	*/
        input Clk, IR_Load;

	//	Instruction being read currently
	input [`INST_WIDTH-1:0] Ram_Inst_Out;
	/*
		Outputs:
			Opcode	    : Retrieves opcode from instruction
			Source_Reg1 : Address of Operand 1 or Immedate value or Memory Address
			Source_Reg2 : Address of Operand 2 or Value to be Stored
			Dest_Reg    : Address to store Alu_Out
	*/
        output reg [`OPCODE_WIDTH-1:0] Opcode;
        output reg [`ADDR_WIDTH-1:0] Source_Reg1, Source_Reg2, Dest_Reg;
	
	always @(posedge Clk) begin
		if(IR_Load) begin
			Opcode      <= Ram_Inst_Out[`OPCODE_UPPER_BIT-1 : `OPCODE_LOWER_BIT];
			Source_Reg1 <= Ram_Inst_Out[`REG1_UPPER_BIT-1   : `REG1_LOWER_BIT]; 
			Source_Reg2 <= Ram_Inst_Out[`REG2_UPPER_BIT-1   : `REG2_LOWER_BIT]; 
			Dest_Reg    <= Ram_Inst_Out[`DREG_UPPER_BIT-1   : `DREG_LOWER_BIT];
		end
		else begin
			Opcode      <= Opcode;
			Source_Reg1 <= Source_Reg1;
			Source_Reg2 <= Source_Reg2;
			Dest_Reg    <= Dest_Reg;
		end	
	end
endmodule
