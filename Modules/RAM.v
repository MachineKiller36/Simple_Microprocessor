module RAM(Clk, Ram_Data_Read, Ram_Data_Write, Ram_Inst_Read, Ram_Inst_Write, Ram_Addr, Inst_Addr, Ram_Data_In, Ram_Inst_In, Ram_Data_Out, Ram_Inst_Out);
	`include "parameters.v"
	/*
		Memory Layout:
			[ 26 : 24 ]	 [ 23 : 18 ]     [ 17 : 12 ]	[ 11 : 6 ]	[ 5 : 0 ]
			   Opcode        Source_Reg1	 Source_Reg2     Dest_Reg	   Data
		
		Instruction Layout:
			[ 20 : 18 ]	 [ 17 : 12 ]     [ 11 : 6 ]	[ 5 : 0 ]
			   Opcode        Source_Reg1	 Source_Reg2     Dest_Reg

	*/
	/*
		Control Signals:
			Clk 	       : Clock signal
		        Ram_Data_Read  : Reads the data at Ram_Addr into Ram_Data_Out
			Ram_Data_Write : Writes Ram_Data_In into Ram_Addrs data
		        Ram_Inst_Read  : Reads the isntruction at Ram_Addr into Ram_Inst_Out
			Ram_Inst_Write : Writes Ram_Inst_In into Ram_Addrs instruction
	*/
	input Clk, Ram_Data_Read, Ram_Data_Write, Ram_Inst_Read, Ram_Inst_Write; 
	/*
		Inputs:
			Ram_Addr    : Memory address selected
			Ram_Data_In : Data to be written
			Ram_Inst_In : Instruction to be written
	*/
        input [`ADDR_WIDTH-1:0] Ram_Addr, Inst_Addr;
	input [`DATA_WIDTH-1:0] Ram_Data_In;
	input [`INST_WIDTH-1:0] Ram_Inst_In;
	/*
		Outputs:
			Ram_Data_Out : Data that is read from memory
			Ram_Inst_Out : Instruction that is read from memory
	*/
        output reg [`DATA_WIDTH-1:0] Ram_Data_Out;
        output reg [`INST_WIDTH-1:0] Ram_Inst_Out;
	//	Memory
	reg [`MEM_WIDTH-1:0] Memory [`NUM_MEM_ADDR-1:0];
	
	//	Read Signals
	always @(posedge Clk) begin
		// Data
		if(Ram_Data_Read) Ram_Data_Out <= Memory[Ram_Addr][`DATA_WIDTH-1:0];
		else		  Ram_Data_Out <= 0;
		// Instruction
		if(Ram_Inst_Read) Ram_Inst_Out <= Memory[Ram_Addr][`MEM_WIDTH-1:`DATA_WIDTH];
		else              Ram_Inst_Out <= 0; 
	end
	//	Write Signals
	always @(posedge Clk) begin
		// Data
		if(Ram_Data_Write) Memory[Ram_Addr][`DATA_WIDTH-1:0] <= Ram_Data_In;
		else		   Memory[Ram_Addr][`DATA_WIDTH-1:0] <= Memory[Ram_Addr][`DATA_WIDTH-1:0];
		// instruction
		if(Ram_Inst_Write) Memory[Inst_Addr][`MEM_WIDTH-1:`DATA_WIDTH] <= Ram_Inst_In;
		else		   Memory[Inst_Addr][`MEM_WIDTH-1:`DATA_WIDTH] <= Memory[Inst_Addr][`MEM_WIDTH-1:`DATA_WIDTH];
	end
endmodule
