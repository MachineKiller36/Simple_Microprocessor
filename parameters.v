/////		CLOCK PARAMETERS	/////
`define DUTY        5			
`define PERIOD      10		
`define NUM_CYCLES  500				// Testbenching: The number of cycles the testbench should perform before stopping.

/////		STATES			/////
`define NUM_STATES 4
`define	RESET    0			
`define FETCH    1
`define DECODE   2
`define EXECUTE  3
`define WAIT     4

/////		BUS WIDTHS		/////
`define OPCODE_WIDTH  3
`define ADDR_WIDTH    6
`define DATA_WIDTH    6
`define INST_WIDTH    21
`define MEM_WIDTH     27

/////		MEMORY PARAMETERS	/////
`define NUM_MEM_ADDR  64			// Number of memory address.
`define NUM_REG_ADDR  8				// Number of registers.
`define MAX_ADDR_VAL  64			// Maximum address value an address bus can carry
`define MAX_DATA_VAL  64			// Maximum data value an data bus can carry

/////		OPCODES			/////
`define DONE 	 0				// No more instructions in memory.
`define LOAD_M 	 1				// Loads a register with an memory address's value.
`define LOAD_I 	 2				// Loads a register with a immediate value.
`define LOAD_PC  3				// Load the program counter with a value.
`define STORE	 4				// Stores the value of a register into memory.
`define ADD	 5				// Performs addition between two register values.
`define SUB	 6				// Performs subtraction between two register values.
`define MUL	 7				// Performs multiplication between two register values.

/////		RANGES			/////
`define OPCODE_UPPER_BIT  21			// Opcode upper bit in an instruction.
`define OPCODE_LOWER_BIT  18 			// Opcode lower bit in an instruction.
`define REG1_UPPER_BIT  18			// Source_Reg1 upper bit in an instruction.
`define REG1_LOWER_BIT  12 			// Source_Reg1 lower bit in an instruction.
`define REG2_UPPER_BIT  12			// Source_Reg2 upper bit in an instruction.
`define REG2_LOWER_BIT  6			// Source_Reg2 lower bit in an instruction.
`define DREG_UPPER_BIT  6			// Dest_Reg upper bit in an instruction.
`define DREG_LOWER_BIT  0			// Dest_Reg lower bit in an instruction.

////		TESTING			////
/*
	WARNING: Random Number Generator Bounds
		- Upper bound CANNOT exceed pow(2, ADDR_WIDTH) OR be negative.
		- Lower bound CANNOT exceed pow(2, ADDR_WIDTH) OR be negative.
*/
//// ALU
`define NUM_ALU_TEST 64				// Number of tests the Alu will perform.
`define REG_UPPER_BOUND 64			// Upper bound of the random number generator.
`define REG_LOWER_BOUND 0			// Lower bound of the random number generator.

// CONTROLLER
`define NUM_CONTROLLER_TEST 64			// Number of tests the Controller will perform.
`define CONT_GEN_RAND_OPCODE 1'b0		// Selects whether to randomize the inputs or use the file input.

// IR
`define NUM_IR_TEST 64				// Upper bound of the random number generator.
`define IR_GEN_RAND_INST 1			// Lower bound of the random number generator.

// MUX
`define NUM_MUX_TEST  64			// Number of tests the Mux will perform.
`define MUX_UPPER_BOUND 64			// Upper bound of the random number generator.
`define MUX_LOWER_BOUND 0			// Lower bound of the random number generator.

// PC
`define NUM_PC_TEST 64				// Number of tests the PC will perform.
`define DREG_UPPER_BOUND 64			// Upper bound of the random number generator.
`define DREG_LOWER_BOUND 0			// Lower bound of the random number generator.

// RAM
`define NUM_RAM_TEST 64				// Number of tests the RAM will perform.
`define RAM_GEN_RAND_INPUT 1'b1			// Selects whether to randomize the inputs or use the file input.
