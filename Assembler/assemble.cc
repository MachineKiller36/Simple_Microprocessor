///////// STD Files
#include <bitset>		// Printing of decimal number of number of binary bits
#include <fstream>		// File operations
#include <iostream>		// Terminal operation
#include <string>	
#include <cstring>
#include <vector>
//////// Custom Files 	
#include "error.h"		// Holds all the error code and messaging functions
#include "string_func.h"	// Holds string manipulating functions *STD were being nitpicky
#include "parser.h"		// Holds the parser function
#include "decoder.h"		// Holds the decoder function
//////// Parameter Files
#include "parameters.h"

// Used to check if the file types passed through the command line are the right type
bool Checktype(const char* file, std::string expected) {
	int index = 0;
	for(int i = strlen(file)-1; i > strlen(file)-expected.size()-1; i--) {
		if(file[i] == '.') {
			index = i;
			break;
		}
		index = i;
	}
	for(int i = 0; i < expected.size(); i++) {
		if(expected[i] != file[i+index])
			return false;
	}
	return true;
}

int main(int argc, const char* argv[]) {	// Uses command lines to get input and output file names
	int warning_count = 0;
	///////  	Command Line Error (fatal) 	 //////
	if(argc == 1) {
		throw std::runtime_error("\nMissing assembly code and machine code file names.\n");
	}
	if(argc < 3) {
		if(!Checktype(argv[1], ".asm")) throw std::runtime_error("\nMissign assemble code file name (.asm).\n");
		if(!Checktype(argv[1], ".mac")) throw std::runtime_error("\nMissign machine code file name (.mac).\n");
	}
	if(!Checktype(argv[1], ".asm")) {
		throw std::runtime_error("\n\tAssembly code file must be a .asm file\n");
	}	
	if(!Checktype(argv[2], ".mac")) {
		throw std::runtime_error("\n\tMachine code file must be a .mac file\n");
	}	

	int address = 0;	// Is the current instruction address where the machine code will be stored
	int line = 1;	 	// Current line in the assembly code file being read	

	/////   Files   ////////////////////
	std::ifstream assembly(argv[1]);    		// Contains the assembly code
	std::ofstream machine(argv[2]);      		// The created machine code will be stored here
	std::ofstream debugger("debugger");     	// Used to see the assembly code and machine code side by side
	std::ofstream logs("assembler.logs");           // Holds the assembler error logs

	///// Command Line Warnings /////////////
	if(argc > 3) {
		std::cout << "\033[35m" << "Warning:\n\tThe following commands are ignored" << "\033[37m" << "\n";	
		logs << "\033[35m" << "Warning:\n\tThe following commands are ignored" << "\033[37m" << "\n";	
		for(int i = 3; i < argc; i++) {
			std::cout << "\033[35m" << argv[i] << "\033[37m" << "\n";	
			logs << "\033[35m" << argv[i] << "\033[37m" << "\n";	
			warning_count++;
		}
		std::cout << "\n";
	}

	/////	Debugger Prep	    /////
	std::vector<std::string> debug;		// Holds the individual word in an instruction, unmodified
	debugger << "Assembly Code\t\t\t\t\t\tBinary Code\n";
	debugger << "--------------------------------------\t\t      --------------------------------------\n";
	debugger << "\t\t\t\t\t\t\tOp      Src_R1     Src_R2     Dreg\n";
	debugger << "\t\t\t\t\t\t\t\t\(I/M)\n"; 
	/////	Assembler Log Prep    /////
	logs << "Assembly Filename: " << argv[2] << "\n";
	logs << "Machine Filename: " << argv[3] << "\n";
	/////	Instruction containers //////
	std::string instruction = "";
	std::string copy     = "";
	std::string opcode   = "";
	std::string dest_reg = "";
	std::string src_reg1 = "";
	std::string src_reg2 = "";
	int binary_opcode    = 0;
	int binary_dest_reg  = 0;
	int binary_src_reg1  = 0;
	int binary_src_reg2  = 0;
	// If an error appears this clears the .mac file
	bool clear_mac = false;
	try {
		bool fail	     = false;		// Used to stop decoder from being perform if the parser ran into an error
		while(getline(assembly, instruction)) {
			debug.clear(); 			// Clears saved instructions	
			fail = false;			// Reset false
			if(address >= NUM_MEM_ADDR) {	// Remember the address counter starts from 0
				throw Error_file_too_large;
			}
			copy = instruction;		// In the parser the instruction is modified
			opcode = "";			// Clears
			dest_reg = "";			// Clears
			src_reg1 = "";			// Clears
			src_reg2 = "";			// Clears
			// Parses instruction into individual words
			parser(logs, line, instruction, opcode, src_reg1, src_reg2, dest_reg, fail, debug);
			clear_mac = fail;		// Trips the file clear if it failed
			if(opcode == "SKIP") {	// A line is just a comment
				continue;
				line++;
			}
			else if(opcode == "DONE") {			// We are done
				std::bitset<OPCODE_WIDTH>  op(0);	// Converts only opcode to a binary print format
				std::bitset<ADDR_WIDTH> s1(0);		// Converts only src_reg1 to a binary print format
				std::bitset<ADDR_WIDTH> s2(0);		// Converts only src_reg2 to a binary print format
				std::bitset<ADDR_WIDTH> d(0);		// Converts only dest_reg to a binary print format
									// Prints machine code
				machine << op << s1 << s2 << d << "\n";
				//////// 	Prints debugger info	////////////////
				debugger << address << ":\t";		// Print address
				for(int i = 0; i < debug.size(); i++) 
					debugger << debug[i] << "\t";
				if(debug.size() < 4)
					debugger << "\t";
				debugger << "\t\t\t\t";
				debugger << op << "     ";
				debugger << s1 << "     ";
				debugger << s2 << "     "; 
				debugger << d << "\n";
				address++;
				break; 
			}
			// Decodes the individual words into the proper machine code values
			if(!fail) 
				decoder(logs, line, copy, opcode, src_reg1, src_reg2, dest_reg, binary_opcode, binary_src_reg1, binary_src_reg2, binary_dest_reg);
			std::bitset<OPCODE_WIDTH>  op(binary_opcode);	// Converts only opcode to a binary print format
			std::bitset<ADDR_WIDTH> s1(binary_src_reg1);	// Converts only src_reg1 to a binary print format
			std::bitset<ADDR_WIDTH> s2(binary_src_reg2);	// Converts only src_reg2 to a binary print format
			std::bitset<ADDR_WIDTH> d(binary_dest_reg);	// Converts only dest_reg to a binary print format
								// Prints machine code
			machine << op << s1 << s2 << d << "\n";
			//////// 	Prints debugger info	////////////////
			debugger << address << ":\t";		// Print address
			for(int i = 0; i < debug.size(); i++) 
				debugger << debug[i] << "\t";
			if(debug.size() < 4)
				debugger << "\t";
			debugger << "\t\t";
			debugger << op << "     ";
			debugger << s1 << "     ";
			debugger << s2 << "     "; 
			debugger << d << "\n";
			address++;
			line++;
		}
	} catch(int error_code) {
		error::print(logs, error_code, line, "");
	}

	// Zeros the reset of the machine code addresses
	for(int i = address; i < NUM_MEM_ADDR; i++) {
		std::bitset<INST_WIDTH> convert(0);
		machine << convert << "\n";
	}
	// Print Final Result of Assembling
	error::print_status(logs);
	std::cout << "\033[35m" << "WARNING COUNT: " << "\033[37m"  << warning_count << "\n";	
	logs << "WARNING COUNT: " << warning_count << "\n";	
	// Clears the .mac file if an error occured
	if(clear_mac) {
		machine.close();
		machine.open(argv[2]);
	}
	// Closes Files
	assembly.close();
	machine.close();
	debugger.close();
	logs.close();
}
