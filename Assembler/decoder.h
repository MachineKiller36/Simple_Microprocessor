#pragma once
//////// Parameter Files
#include "parameters.h"

void decoder(std::ofstream& logs, int error_line, std::string instruction, std::string opcode, std::string src_reg1, std::string src_reg2, std::string dest_reg, int& binary_opcode, int& binary_src_reg1, int& binary_src_reg2, int& binary_dest_reg) {
	try {
		if(opcode == "DONE") {
			binary_opcode = DONE;
			binary_src_reg1 = 0;
			binary_src_reg2 = 0;
			binary_dest_reg = 0;
		} else if(opcode == "LOAD_M") {
			binary_opcode = LOAD_M;
			
			///////
			src_reg1[0] = ' ';
			binary_src_reg1 = string_to_int(logs, error_line, instruction, src_reg1);
			if(binary_src_reg1 < 0 || binary_src_reg1 >= MAX_ADDR_VAL) {		
				throw Error_invalid_memory_address;
			}
			///////
			
			binary_src_reg2 = 0;
			
			///////
			dest_reg[0] = ' ';
			binary_dest_reg = string_to_int(logs, error_line, instruction, dest_reg);
			if(binary_dest_reg < 0 || binary_dest_reg >= NUM_REG_ADDR) {				
				throw Error_invalid_destination;
			}
		} else if(opcode == "LOAD_I") {	// Load_I
			binary_opcode = LOAD_I;
			
			///////
			src_reg1[0] = ' ';
			binary_src_reg1 = string_to_int(logs, error_line, instruction, src_reg1);
			if(binary_src_reg1 < 0 || binary_src_reg1 >= MAX_DATA_VAL) {
				throw Error_invalid_immediate_value;
			}

			///////
			
			binary_src_reg2 = 0;
			
			///////
			dest_reg[0] = ' ';
			binary_dest_reg = string_to_int(logs, error_line, instruction, dest_reg);
			if(binary_dest_reg < 0 || binary_dest_reg >= NUM_REG_ADDR) {
				std::cout << "Dest_Reg: " << dest_reg << "\n";
				throw Error_invalid_destination;
			}
		} else if(opcode == "LOAD_PC") {		// Load_PC
			binary_opcode = LOAD_PC;

			//////
			binary_src_reg1 = 0;
			
			//////
			binary_src_reg2 = 0;
			
			//////
			dest_reg[0] = ' ';
			binary_dest_reg = string_to_int(logs, error_line, instruction, dest_reg);
			if(binary_dest_reg < 0 || binary_dest_reg >= MAX_ADDR_VAL) {
				throw Error_invalid_pc_address;
			}
			
		} else if(opcode == "STORE") {
			binary_opcode = STORE;
			
			//////
			src_reg1[0] = ' '; 
			binary_src_reg1 = string_to_int(logs, error_line, instruction, src_reg1);
			if(binary_src_reg1 < 0 || binary_src_reg1 >= MAX_ADDR_VAL) {
				throw Error_invalid_memory_address;
			}

			//////
			src_reg2[0] = ' ';
			binary_src_reg2 = string_to_int(logs, error_line, instruction, src_reg2);
			if(binary_src_reg2 < 0 || binary_src_reg2 >= NUM_REG_ADDR) {
				Error_invalid_syntax;
			}

			/////
			binary_dest_reg = 0;
				
		} else if(opcode == "ADD") {
			binary_opcode = ADD;
			
			/////
			src_reg1[0] = ' ';
			binary_src_reg1 = string_to_int(logs, error_line, instruction, src_reg1);
			if(binary_src_reg1 < 0 || binary_src_reg1 >= NUM_REG_ADDR) {
				throw Error_invalid_operand_one;	
			}

			////
			src_reg2[0] = ' ';
			binary_src_reg2 = string_to_int(logs, error_line, instruction, src_reg2);
			if(binary_src_reg2 < 0 || binary_src_reg2 >= NUM_REG_ADDR) {
				throw Error_invalid_operand_two;	
			}
			
			////
			dest_reg[0] = ' ';
			binary_dest_reg = string_to_int(logs, error_line, instruction, dest_reg);
			if(binary_dest_reg < 0 || binary_dest_reg >= NUM_REG_ADDR) {
				throw Error_invalid_destination;	
			}
	
		} else if(opcode == "SUB") {
			binary_opcode = SUB;
			
			/////
			src_reg1[0] = ' ';
			binary_src_reg1 = string_to_int(logs, error_line, instruction, src_reg1);
			if(binary_src_reg1 < 0 || binary_src_reg1 >= NUM_REG_ADDR) {
				throw Error_invalid_operand_one;	
			}

			////
			src_reg2[0] = ' ';
			binary_src_reg2 = string_to_int(logs, error_line, instruction, src_reg2);
			if(binary_src_reg2 < 0 || binary_src_reg2 >= NUM_REG_ADDR) {
				throw Error_invalid_operand_two;	
			}
			
			////
			dest_reg[0] = ' ';
			binary_dest_reg = string_to_int(logs, error_line, instruction, dest_reg);
			if(binary_dest_reg < 0 || binary_dest_reg >= NUM_REG_ADDR) {
				throw Error_invalid_destination;	
			}
	

		} else if(opcode == "MUL") {
			binary_opcode = MUL;
			
			/////
			src_reg1[0] = ' ';
			binary_src_reg1 = string_to_int(logs, error_line, instruction, src_reg1);
			if(binary_src_reg1 < 0 || binary_src_reg1 >= NUM_REG_ADDR) {
				throw Error_invalid_operand_one;	
			}

			////
			src_reg2[0] = ' ';
			binary_src_reg2 = string_to_int(logs, error_line, instruction, src_reg2);
			if(binary_src_reg2 < 0 || binary_src_reg2 >= NUM_REG_ADDR) {
				throw Error_invalid_operand_two;	
			}
			
			////
			dest_reg[0] = ' ';
			binary_dest_reg = string_to_int(logs, error_line, instruction, dest_reg);
			if(binary_dest_reg < 0 || binary_dest_reg >= NUM_REG_ADDR) {
				throw Error_invalid_destination;	
			}
	
		
		} else {
			throw Error_invalid_command;
		}
				
	} catch(int error_code) {
		error::print(logs, error_code, error_line, instruction);
	}	
}
