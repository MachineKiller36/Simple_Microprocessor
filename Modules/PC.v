module PC(Clk, PC_Clr, PC_Load, PC_Inc, Dest_Reg, PC_Out);
	`include "parameters.v"
	/*
		Control Signals:
			Clk  	: Clock signal
			PC_Clr  : Clears PC_Out to 0
			PC_Load : Loads Dest_Reg into PC_Out
			PC_Inc 	: Increments PC_Out by 1
	*/
	input Clk, PC_Clr, PC_Load, PC_Inc;
	//	Input Register
	input [`ADDR_WIDTH-1:0] Dest_Reg;
	//	Output
	output reg [`ADDR_WIDTH-1:0] PC_Out;
	always @(posedge Clk) begin
		if(PC_Clr) 	 PC_Out <= 0;
		else if(PC_Load) PC_Out <= Dest_Reg;
		else if(PC_Inc)  PC_Out <= PC_Out + 1;
		else		 PC_Out <= PC_Out;
	end
endmodule
