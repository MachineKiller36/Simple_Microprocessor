module DATAPATH(Clk, PC_Clr, PC_Load, PC_Inc, IR_Load, Reg_Load, Alu_Add, Alu_Sub, Alu_Mul, Alu_Pass, Ram_Data_Read, Load_M, Load_I,
Ram_Inst_Out, Ram_Data_Out, Opcode, Ram_Data_In, Ram_Addr);
	`include "parameters.v"
	/*
		Control Signals:
			Clk           - Clock Signal
			PC_Clr        - Clears program counter
			PC_Load       - Loads program counter with a new value
			PC_Inc        - Increments program counter by 1
			IR_Load       - Loads instruction register with a new instruction
			Reg_Load      - Loads destination register with data
			Alu_Add       - Makes arithmetic logic unit perform addition
			Alu_Sub       - Makes arithmetic logic unit perform subtraction
			Alu_Mul       - Makes arithmetic logic unit perform multiplication
			Alu_Pass      - Makes arithetic logic unit set its output to its operand 1
			Ram_Data_Read - Indicates procressor is reading from memory
			Load_M 	      - Selects the Ram_Addr
			Load_I 	      - Selects whether to load an immediate value or Alu_out into registers
	*/
       	input Clk, PC_Clr, PC_Load, PC_Inc, IR_Load, Reg_Load, Alu_Add, Alu_Sub, Alu_Mul, Alu_Pass, Ram_Data_Read, Load_M, Load_I;
	/*
		Inputs:
			Ram_Inst_Out - The instruction read from memory
			Ram_Data_Out - The data read from memory
	*/
       	input [`INST_WIDTH-1:0] Ram_Inst_Out;
	input [`DATA_WIDTH-1:0] Ram_Data_Out;
	/*
		Outputs:
			Opcode	    - Opcode to be decoded by the controller
			Ram_Data_In - Data to be written into memory
			Ram_Addr    - Memory address for data to be stored or read
	*/
        output [`OPCODE_WIDTH-1:0] Opcode;
        output [`DATA_WIDTH-1:0] Ram_Data_In;
	output [`ADDR_WIDTH-1:0] Ram_Addr;
	/*
		Inter connections:
			Source_Reg1 - IR Input: Either register address, memory address, or immediate value.
			Source_Reg2 - IR Input: Either register address or value to be stored in memory.
			Dest_Reg    - IR Input: Either register address or PC load value.
			PC_Out      - PC Output: Current instruction being read address.
			Reg1_Out    - REG Output: Value at Source_Reg1.
			Reg2_Out    - REG Output: Vale at Source_Reg2.
			Alu_Out     - ALU Output: Value after going through the ALU.
			Reg_Data_In - REG Input: Value to be stored into Dest_Reg
	*/
	wire [`ADDR_WIDTH-1:0] Source_Reg1, Source_Reg2, Dest_Reg, PC_Out;
	wire [`DATA_WIDTH-1:0] Reg1_Out, Reg2_Out, Alu_Out, Reg_Data_In;

	IR instruction_reg(
		.Clk(Clk),
		.IR_Load(IR_Load),
		.Ram_Inst_Out(Ram_Inst_Out),
		.Opcode(Opcode),
		.Source_Reg1(Source_Reg1),
		.Source_Reg2(Source_Reg2),
		.Dest_Reg(Dest_Reg)
	);
        PC program_counter(
		.Clk(Clk),
		.PC_Clr(PC_Clr),
		.PC_Load(PC_Load),
		.PC_Inc(PC_Inc),
		.Dest_Reg(Dest_Reg),
		.PC_Out(PC_Out)
	);
	REG registers(
		.Clk(Clk),
		.Reg_Load(Reg_Load),
		.Source_Reg1(Source_Reg1),
		.Source_Reg2(Source_Reg2),
		.Dest_Reg(Dest_Reg),
		.Reg_Data_In(Reg_Data_In),			
		.Reg1_Out(Reg1_Out),
		.Reg2_Out(Reg2_Out)
	);	
	ALU arithmetic_logic_unit(
		.Alu_Add(Alu_Add),
		.Alu_Sub(Alu_Sub),
		.Alu_Mul(Alu_Mul),
		.Alu_Pass(Alu_Pass),
		.Reg1_Out(Reg1_Out),	
		.Reg2_Out(Reg2_Out),
		.Alu_Out(Alu_Out)
	);
	
	// If we are reading data from memory it will go into the registers
	// Else the ALU output will
	MUX Data_Read_Mux(
		.True(Ram_Data_Out),
		.False(Alu_Out),
		.Cond(Ram_Data_Read),
		.Out(Ram_Data_In)
	);
	// If were a loading an immediate value then the value will be passed
	// into the register instead of the Ram_Data_In
	MUX Load_I_Mux(
		.True(Source_Reg1),
		.False(Ram_Data_In),
		.Cond(Load_I),
		.Out(Reg_Data_In)
	);
	// If we are loading a value from memory passed Source_Reg1 in as the
	// memory address, else PC_Out is memory address
	MUX Load_M_Mux(
		.True(Source_Reg1),
		.False(PC_Out),
		.Cond(Load_M),
		.Out(Ram_Addr)
	);
endmodule
