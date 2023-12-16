module IR_tb();
	`include "parameters.v"
	/*
		Control Signals:
			Clk 	- Clock signal.
			IR_Load - Registers instruction.
	*/
	reg Clk=1, IR_Load=0;
	/*
		Inputs:
			Ram_Inst_Out - Instruction that was read.
	*/
	reg [`INST_WIDTH-1:0] Ram_Inst_Out;
	/*
		Outputs:
			Opcode      - bits [ 20 : 18 ].
			Source_Reg1 - bits [ 17 : 12 ].
			Source_Reg2 - bits [ 11 : 6 ].
			Dest_Reg    - bits [ 5 : 0 ].
	*/
       	wire [`OPCODE_WIDTH-1:0] Opcode;
	wire [`ADDR_WIDTH-1:0] Source_Reg1, Source_Reg2, Dest_Reg;

	IR instruction_register(
		.Clk(Clk),
		.IR_Load(IR_Load),
		.Ram_Inst_Out(Ram_Inst_Out),
		.Opcode(Opcode),
		.Source_Reg1(Source_Reg1),
		.Source_Reg2(Source_Reg2),
		.Dest_Reg(Dest_Reg)
	);
	integer in_file;
	integer out_file;
	integer status;
	integer address;
	always #(`DUTY) Clk = ~Clk;
	initial begin
		$dumpfile("Junk/IR.vcd");
		$dumpvars(0, IR_tb);
		in_file = $fopen("Testbenches/binary.mac", "r");
		out_file = $fopen("Results/IR.r", "w");
		for(address = 0; address < `NUM_IR_TEST; address = address + 1) begin
			#(`PERIOD) IR_Load = 1;
			if(`IR_GEN_RAND_INST) begin
				Ram_Inst_Out = $urandom % 2097152;	// Generates a random instruction
			end
			else begin
				status = $fscanf(in_file, "%b\n", Ram_Inst_Out); // Uses binary.txt to get instruction
			end
			#(`PERIOD) IR_Load = 0;
			$fwrite(out_file, "Address = %d", address);
			$fwrite(out_file, " \tInstruction = %b", Ram_Inst_Out);
			$fwrite(out_file, " \tOpcode = %b", Opcode);
			$fwrite(out_file, "\tSource_Reg1 = %b", Source_Reg1);
			$fwrite(out_file, "\tSource_Reg2 = %b", Source_Reg2);
			$fwrite(out_file, "\tDest_Reg = %b\n\n", Dest_Reg);
		end
		#(2*`PERIOD*`NUM_IR_TEST);
		$fclose(in_file);
		$fclose(out_file);
		$finish();
		$stop;
	end
endmodule

