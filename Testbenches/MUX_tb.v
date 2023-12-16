module MUX_tb();
	`include "parameters.v"
	/*
		Control Signal:
			Cond - Selects the data that will pass through.
	*/
	reg Cond=0;
	/*
		Inputs:
			True - Is the data that will be passed through if the condition is true.
			False - Is the data that will be passed through if the condition is false.
	*/
        reg [`DATA_WIDTH-1:0] True=0, False=0;
	/*
		Output:
			Out - The output.
	*/
        wire [`DATA_WIDTH-1:0] Out;

	MUX multiplexor(
		.True(True),
		.False(False),
		.Cond(Cond),
		.Out(Out)	
	);

	integer file;
	integer test;
	initial begin
		$dumpfile("Junk/MUX.vcd");
		$dumpvars(0, MUX_tb);
		file = $fopen("Results/MUX.r", "w");
		for(test = 0; test < `NUM_MUX_TEST; test = test + 1) begin
			Cond = $urandom % 2;	// Generates a unsigned value between 0-1.
			True = $urandom % (`MUX_UPPER_BOUND-`MUX_LOWER_BOUND+1)+`MUX_LOWER_BOUND;
			False = $urandom % (`MUX_UPPER_BOUND-`MUX_LOWER_BOUND+1)+`MUX_LOWER_BOUND;
			#5;
			$fwrite(file, "Test = %d", test);
			$fwrite(file, "\tCond = %d", Cond);
			$fwrite(file, "\tTrue = %d", True);
			$fwrite(file, "\tFalse = %d", False);
			$fwrite(file, "\tOut = %d\n\n", Out);
		end
		#(2*`PERIOD*`NUM_MUX_TEST);
		$fclose(file);
		$finish();
		$stop;
	end
endmodule
