module MUX(True, False, Cond, Out);
	`include "parameters.v"
	
	input [`DATA_WIDTH-1:0] True, False;
	input Cond;
	output reg [`DATA_WIDTH-1:0] Out;
	
	always @(*) begin
		Out = Cond ? True : False;
	end
endmodule
