module RAM_tb();
	`include "parameters.v"
        /*
                Control Signals:
                        Clk            - Clock signal
                        Ram_Data_Read  - Reads the data at Ram_Addr into Ram_Data_Out
                        Ram_Data_Write - Writes Ram_Data_In into Ram_Addrs data
                        Ram_Inst_Read  - Reads the isntruction at Ram_Addr into Ram_Inst_Out
                        Ram_Inst_Write - Writes Ram_Inst_In into Ram_Addrs instruction
        */
	reg Clk=0, Ram_Data_Read=0, Ram_Data_Write=0, Ram_Inst_Read=0, Ram_Inst_Write=0;
        /*
                Inputs:
                        Ram_Addr    - Memory address selected
                        Ram_Data_In - Data to be written
                        Ram_Inst_In - Instruction to be written
        */
	reg [`ADDR_WIDTH-1:0] Ram_Addr, Inst_Addr;
	reg [`DATA_WIDTH-1:0] Ram_Data_In;
	reg [`INST_WIDTH-1:0] Ram_Inst_In;
        /*
                Outputs:
                        Ram_Data_Out - Data that is read from memory
                        Ram_Inst_Out - Instruction that is read from memory
        */
	wire [`DATA_WIDTH-1:0] Ram_Data_Out;
	wire [`INST_WIDTH-1:0] Ram_Inst_Out;

	RAM random_access_memory(
        	.Clk(Clk),
                .Ram_Data_Read(Ram_Data_Read),
                .Ram_Data_Write(Ram_Data_Write),
                .Ram_Inst_Read(Ram_Inst_Read),
                .Ram_Inst_Write(Ram_Inst_Write),
                .Ram_Addr(Ram_Addr),
                .Inst_Addr(Inst_Addr),
                .Ram_Data_In(Ram_Data_In),
                .Ram_Inst_In(Ram_Inst_In),
                .Ram_Data_Out(Ram_Data_Out),
                .Ram_Inst_Out(Ram_Inst_Out)
        );
	integer status;
	integer in_file1;  // Input for instruction
	integer in_file2;  // Input for data
	integer out_file;  // Output for results
	integer address;
	integer run;

	always #(`DUTY) Clk = ~Clk;
	initial begin
		$dumpfile("Junk/RAM.vcd");
		$dumpvars(0, RAM_tb);
		in_file1 = $fopen("Testbenches/binary.mac","r");
		in_file2 = $fopen("Testbenches/data.mac","r");
		out_file = $fopen("Results/RAM.r", "w");
		if(`RAM_GEN_RAND_INPUT) begin
			run = `NUM_RAM_TEST;		
		end
		else begin
			run = `NUM_MEM_ADDR;
		end
		$fwrite(out_file, "Randomized Input = %b\n\n", `RAM_GEN_RAND_INPUT);
		
		for(address = 0; address < run; address = address + 1) begin
			#(`PERIOD);
			Inst_Addr = address;
			Ram_Addr = address;
			if(`RAM_GEN_RAND_INPUT) begin
				Ram_Inst_Write = $urandom % 2;
				Ram_Data_Write = $urandom % 2;
				Ram_Inst_In = $urandom % `INST_WIDTH;
				Ram_Data_In = $urandom % `DATA_WIDTH;
			end
			else begin
				Ram_Inst_Write = 1;
				Ram_Data_Write = 1;
				status = $fscanf(in_file1, Ram_Inst_In);
				status = $fscanf(in_file2, Ram_Data_In);
			end
			#(`PERIOD);
			Ram_Inst_Read = 1;
			Ram_Data_Read = 1;
			#(`PERIOD);
			$fwrite(out_file, "Address = %d", address);
			$fwrite(out_file, "\tRam_Inst_Write = %b", Ram_Inst_Write);
			$fwrite(out_file, "\tRam_Inst_In = %b", Ram_Inst_In);
			$fwrite(out_file, "\tRam_Inst_Out = %b\n", Ram_Inst_Out);
			$fwrite(out_file, "\t\t\tRam_Data_Write = %b", Ram_Data_Write);
			$fwrite(out_file, "\tRam_Data_In = %b", Ram_Data_In);
			$fwrite(out_file, "\t\t\tRam_Data_Out = %b\n\n", Ram_Data_Out);
		end

		$fclose(in_file1);
		$fclose(in_file2);
		$fclose(out_file);
		$finish();
		$stop;
	end
endmodule
