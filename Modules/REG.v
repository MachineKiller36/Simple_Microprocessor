module REG(Clk, Reg_Load, Source_Reg1, Source_Reg2, Dest_Reg, Reg_Data_In, Reg1_Out, Reg2_Out);
	`include "parameters.v"
	/*
		Control Signals:
			Clk : Clock signal
			Reg_Load : Loads Reg_Data_In into Dest_Reg;
	*/
	input Clk, Reg_Load;
	/*
	* 	Inputs:
			Source_Reg1 : Address for Operand 1
			Source_Reg2 : Address for Operand 2
			Dest_Reg    : Address for Reg_Data_In
			Reg_Data_In : Value to stored in registers
	*/
        input [`ADDR_WIDTH-1:0] Source_Reg1, Source_Reg2, Dest_Reg;
	input [`DATA_WIDTH-1:0] Reg_Data_In;
	//	Outputs
	output reg [`DATA_WIDTH-1:0] Reg1_Out, Reg2_Out;
	//	Register
	reg [`DATA_WIDTH-1:0] Register[`NUM_REG_ADDR-1:0];

	always @(posedge Clk) begin
		if(Reg_Load) begin
			case(Dest_Reg)
				0 : Register[0] <= Reg_Data_In;
				1 : Register[1] <= Reg_Data_In;
				2 : Register[2] <= Reg_Data_In;
				3 : Register[3] <= Reg_Data_In;
				4 : Register[4] <= Reg_Data_In;
				5 : Register[5] <= Reg_Data_In;
				6 : Register[6] <= Reg_Data_In;
				7 : Register[7] <= Reg_Data_In;
				default : Register[0] <= Register[0];
			endcase		
		end
		else begin
			case(Dest_Reg)
				0 : Register[0] <= Register[0];
				1 : Register[1] <= Register[1];
				2 : Register[2] <= Register[2];
				3 : Register[3] <= Register[3];
				4 : Register[4] <= Register[4];
				5 : Register[5] <= Register[5];
				6 : Register[6] <= Register[6];
				7 : Register[7] <= Register[7];
				default : Register[0] <= Register[0];
			endcase		
	
		end
	end
	always @(posedge Clk) begin
		case(Source_Reg1)
			0 : Reg1_Out <= Register[0];
			1 : Reg1_Out <= Register[1];
			2 : Reg1_Out <= Register[2];
			3 : Reg1_Out <= Register[3];
			4 : Reg1_Out <= Register[4];
			5 : Reg1_Out <= Register[5];
			6 : Reg1_Out <= Register[6];
			7 : Reg1_Out <= Register[7];
			default : Reg1_Out <= 0;
		endcase
		case(Source_Reg2)
			0 : Reg2_Out <= Register[0];
			1 : Reg2_Out <= Register[1];
			2 : Reg2_Out <= Register[2];
			3 : Reg2_Out <= Register[3];
			4 : Reg2_Out <= Register[4];
			5 : Reg2_Out <= Register[5];
			6 : Reg2_Out <= Register[6];
			7 : Reg2_Out <= Register[7];
			default : Reg2_Out <= 0;
		endcase
	end
endmodule

