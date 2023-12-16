module PC_tb();
	`include "../parameters.v"	
	/*
		Control Signals:
			Clk - Clock signals.
			PC_Clr - Clears counter.
			PC_Load - Counter is set to Dest_Reg.
			PC_Inc - Increments count by 1.
	*/
	reg Clk=0, PC_Clr=1, PC_Load=0, PC_Inc=0;
	/*
		Inputs:
			Dest_Reg - Value to be stored into the counter.
	*/
	reg [`ADDR_WIDTH-1:0] Dest_Reg=0;
	/*
		Outputs:
			PC_Out - The current counter value.
	*/
	wire [`ADDR_WIDTH-1:0] PC_Out;

	integer file;
	integer status;
	integer test;
	PC program_counter(
		.Clk(Clk),
		.PC_Clr(PC_Clr),
		.PC_Load(PC_Load),
		.PC_Inc(PC_Inc),
		.Dest_Reg(Dest_Reg),
		.PC_Out(PC_Out)
	);
	always #(`DUTY) Clk = ~Clk;
	initial begin
		$dumpfile("../Junk/PC.vcd");
		$dumpvars(0, PC_tb);
		file = $fopen("../Results/PC.r", "w");
		for(test = 0; test < `NUM_PC_TEST; test = test + 1) begin
			#(`PERIOD);
				PC_Clr = $urandom % 2;	// Generates a unsigned value between 0-1.
				PC_Load = $urandom % 2;	// Generates a unsigned value between 0-1.
				PC_Inc = $urandom % 2;	// Generates a unsigned value between 0-1.
				Dest_Reg = $urandom % (`DREG_UPPER_BOUND-`DREG_LOWER_BOUND+1)+`DREG_LOWER_BOUND; // Generates a unsigned value
				$fwrite(file, "Test = %d", test);
				$fwrite(file, "\tPC_Clr = %b", PC_Clr);
				$fwrite(file, "\tPC_Load = %b", PC_Load);
				$fwrite(file, "\tPC_Inc = %b", PC_Inc);
				$fwrite(file, "\tDest_Reg = %d", Dest_Reg);
				$fwrite(file, "\tPC_Out = %d\n\n", PC_Out);
			#(`PERIOD);
		end
		#(2*`PERIOD*`NUM_PC_TEST);
		$fclose(file);
		$finish();
		$stop;
	end

endmodule
