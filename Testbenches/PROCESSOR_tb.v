module PROCESSOR_tb();
	`include "../parameters.v"
	reg Clk=0, Reset=1, Ram_Inst_Write=0;
	reg [`INST_WIDTH-1:0] Ram_Inst_In;
	reg [`ADDR_WIDTH-1:0] Inst_Addr;

	wire [`DATA_WIDTH-1:0] Ram_Data_Out;

	integer file;
	integer status;
	integer address;
	PROCESSOR Simple(
		.Clk(Clk),
		.Reset(Reset),
		.Ram_Inst_Write(Ram_Inst_Write),
		.Inst_Addr(Inst_Addr),
		.Ram_Inst_In(Ram_Inst_In),
		.Ram_Data_Out(Ram_Data_Out)
	);
	always #(`DUTY) Clk = ~Clk;
	initial begin
		$dumpfile("../Junk/PROCESSOR.vcd");
		$dumpvars(0, PROCESSOR_tb);
		file = $fopen("binary.mac", "r");	
		for(address = 0; address < `NUM_MEM_ADDR; address = address + 1) begin
			#(`PERIOD) Ram_Inst_Write = 1;
			Inst_Addr = address;
			status = $fscanf(file, "%b\n", Ram_Inst_In);
			#(`PERIOD) Ram_Inst_Write = 0;
		end
		Reset = 0;
		#(4*(`PERIOD)*(`NUM_CYCLES));
		$fclose(file);
		$finish();
		$stop;
	end
endmodule
