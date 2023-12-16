module PROCESSOR(Clk, Reset, Ram_Inst_Write, Inst_Addr, Ram_Inst_In, Ram_Data_Out);
	`include "parameters.v"
	/*
		External Control Signals:
			Clk 	     - Clock signal
			Reset 	     - Prevents procressor from running instructions.
			Ram_Write_In - Used to burn instruction onto the memory.
			Ram_Inst_In  - Instructions to be stored onto the memory.
			Inst_Addr    - Memory for the instructions to be stored at.
	*/
        input Clk, Reset, Ram_Inst_Write;
	input [`INST_WIDTH-1:0] Ram_Inst_In;
        input [`ADDR_WIDTH-1:0] Inst_Addr;
	/*
		Output:
			Ram_Data_Out - Data that read from RAM.
	*/
	output [`DATA_WIDTH-1:0] Ram_Data_Out;
	/*
		Inter connections:
			PC_Clr 		- Clears program counter.
			PC_Load 	- Loads program counter with a value.
			PC_Inc  	- Increments program counter.
			IR_Load 	- Registers the instruction read.
			Reg_Load 	- Loads Dest_Reg with a value.
			Alu_Add  	- Dest_Reg = Reg1_Out + Reg2_Out.
			Alu_Sub  	- Dest_Reg = Reg1_Out - Reg2_Out.
			Alu_Mul  	- Dest_Reg = Reg1_Out * Reg2_Out.
			Alu_Pass	- Ram_Data_In = Reg2_Out.
			Ram_Data_Read   - Reads data at Ram_Addr.
			Ram_Data_Write  - Writes Ram_Data_In into Ram_Addr.
			Ram_Inst_Read   - Reads instruction at Ram_Addr.
			Load_M 	 	- Sets Source_Reg1 as Ram_Addr.
			Load_I 		- Sets Source_Reg1 as Reg_Data_In.
	*/
	wire PC_Clr, PC_Load, PC_Inc, IR_Load, Reg_Load, Alu_Add, Alu_Sub, Alu_Mul, Alu_Pass, Ram_Data_Read, Ram_Data_Write, Ram_Inst_Read, Load_M, Load_I;
        wire [`INST_WIDTH-1:0]   Ram_Inst_Out;
	wire [`OPCODE_WIDTH-1:0] Opcode;
	wire [`DATA_WIDTH-1:0]   Ram_Data_In;	
	wire [`ADDR_WIDTH-1:0]   Ram_Addr;

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
	CONTROLLER controller(
		.Clk(Clk),
		.Reset(Reset),
		.Opcode(Opcode),		
		.PC_Clr(PC_Clr),
		.PC_Load(PC_Load),
		.PC_Inc(PC_Inc),
		.IR_Load(IR_Load),
		.Reg_Load(Reg_Load),
		.Alu_Add(Alu_Add),
		.Alu_Sub(Alu_Sub),
		.Alu_Mul(Alu_Mul),
		.Alu_Pass(Alu_Pass),
		.Ram_Data_Read(Ram_Data_Read),
		.Ram_Data_Write(Ram_Data_Write),
		.Ram_Inst_Read(Ram_Inst_Read),
		.Load_M(Load_M),
		.Load_I(Load_I)
	);
	DATAPATH datapath(
		.Clk(Clk),
		.PC_Clr(PC_Clr),
		.PC_Load(PC_Load),
		.PC_Inc(PC_Inc),
		.IR_Load(IR_Load),
		.Reg_Load(Reg_Load),
		.Alu_Add(Alu_Add),
		.Alu_Sub(Alu_Sub),
		.Alu_Mul(Alu_Mul),
		.Alu_Pass(Alu_Pass),
		.Ram_Data_Read(Ram_Data_Read),
		.Load_M(Load_M),
		.Load_I(Load_I),
		.Ram_Inst_Out(Ram_Inst_Out),
		.Ram_Data_Out(Ram_Data_Out),
		.Opcode(Opcode),
		.Ram_Data_In(Ram_Data_In),
		.Ram_Addr(Ram_Addr)
	);
endmodule
