#pragma once
//////// Parameter Files
#include "parameters.h"

void parser(std::ofstream& logs, int error_line, std::string instruction, std::string& opcode, 
		std::string& src_reg1, std::string& src_reg2, std::string& dest_reg, bool& fail, std::vector<std::string>& debug) {
        std::string copy = instruction;         // Used to print error messages
	try {
                /////////               PREPS INSTRUCTION               ////////////////////////////////////////////////
                if(instruction[0] == ';' || instruction.size() < 1) {
                        opcode = "SKIP";                                // Used to indicate to skip line and not change the address
                        instruction = copy;
			return;
		}

                // Removes non-important, non-numerical and non-alphabetical characters, which allowed them to be in the code with issue
		RemoveChar(instruction, '\t');
		for(int character = 32; character < 48; character++) {
			/*
				Removes:
					' ', !, "", $, %, &, '', (, ), *, +, ',', '-', '.', /  
			 */
			if(character != 35) // 35 is for '#'
				RemoveChar(instruction, (char)character);
		}
		for(int character = 58; character < 65; character++) {
			/*
			 	Removes:
					:, ;, <, >, ?, @
			 */
			if(character != 59 && character != 61) // 59 is ';' , 61 is '='
				RemoveChar(instruction, (char)character);
		}
		for(int character = 91; character < 97; character++) {
			/*
			 	Removes:
					[, \, ], ^, _, `, 
			 */
			RemoveChar(instruction, (char)character);
		}
		for(int character = 123; character < 127; character++) {
			/*
			 	Removes:
				{, |, }, ~
			 */
			RemoveChar(instruction, (char)character);
		}
		// Removes the semicolon and everything after it
		int index = Find(instruction, ';');
                if(index > -1) Clear(instruction, index, instruction.size()); 
		
		// Uppercases the instruction, allows for case sentivity
                Uppercase(instruction);
                if(instruction.size() < 1) return;      // No instruction
                                                        /////////////////////////////////////////////////////////////////////////////////////////////////////////

                ////////        GETS OPCODE     ////////
                std::vector<std::string> wordbank = { "LOAD", "STORE", "ADD", "SUB", "MUL", "DONE" };
                bool found = false;
                for(int i = 0; i < wordbank.size(); i++) {
                        int length = wordbank[i].size();
			if(instruction.size() < length)
				continue;
                        if(Substr(instruction, 0, length) == wordbank[i]) {
                                found = true;
                                opcode = wordbank[i];
                               	debug.push_back(opcode);
			       	Clear(instruction, 0, length);
                                if(opcode == "DONE")    // Only one parameter
                                        return;
                                break;
                        }
                }
                if(!found) throw Error_invalid_command;
                ///////////////////////////////////////
		int hash_count = 0;
		int equal_count = 0;
		int R_count = 0;
		// Determines if it is Load_PC
		bool is_pc = false;
		if(instruction[0] == 'P' && instruction[1] == 'C') {
			is_pc = true;
		}
		////////    Calculating number of paramters    /////////
		for(int i = 0; i < instruction.size()-1; i++) {
			if(instruction[i] == '#' && instruction[i+1] == '#') {
				throw Error_invalid_syntax;
			}
			else if(instruction[i] == '=' && instruction[i+1] == '=') {
				throw Error_invalid_syntax;
			}
			else if(instruction[i] == 'R' && instruction[i+1] == 'R') {
				throw Error_invalid_syntax;
			}
			else if(instruction[i] == '#')  {
				hash_count++;
			}
			else if(instruction[i] == '=') {
				equal_count++;
			}
			else if(instruction[i] == 'R') {
				R_count++;	
			}
		}
		////////	Throw errors for missing or having too many arguments //////////
		if(opcode == "DONE") {
			if(hash_count || equal_count || R_count)
				throw Error_too_many_arguments;
		} else if(opcode == "LOAD") {
			int sum = hash_count+equal_count+R_count; 
			
			if(sum > 2) 
				throw Error_too_many_arguments;
			else if(sum < 2 && !is_pc)  
				throw Error_too_few_arguments;
			else if(sum < 0 && is_pc)
				throw Error_too_few_arguments;
		} else if(opcode == "STORE") {
			int sum = hash_count+equal_count+R_count; 
			if(sum > 2)
				throw Error_too_many_arguments;
			else if(sum < 2)
				throw Error_too_few_arguments;
		} else if(opcode == "ADD") {
			int sum = hash_count+equal_count+R_count; 
			if(sum > 3)
				throw Error_too_many_arguments;
			else if(sum < 3)
				throw Error_too_few_arguments;
		} else if(opcode == "SUB") {
			int sum = hash_count+equal_count+R_count; 
			if(sum > 3)
				throw Error_too_many_arguments;
			else if(sum < 3)
				throw Error_too_few_arguments;
		
		} else if(opcode == "MUL") {
			int sum = hash_count+equal_count+R_count; 
			if(sum > 3)
				throw Error_too_many_arguments;
			else if(sum < 3)
				throw Error_too_few_arguments;
		} else {
			throw Error_invalid_command;
		}
		/////////////////////////////////////////////////
		
		////////    GETS DESTINATION     ///////
	  	index = 0;
                if(instruction[0] == '=') {             // STORE =0, R0
                        index = Find(instruction, 'R');
                        if(index > -1) {
                                src_reg1 = Substr(instruction, 0, index);       // Remember store uses src_reg1 as the destination
                        	debug.push_back(src_reg1);
			} else {
                                throw Error_invalid_destination;
                        }
                } else if(instruction[0] == 'R') {      // LOAD_I, Load_M, Add, Sub, Mul
                        index = Find(instruction, 'R', 1);
                        if(index > -1) {				 
                                dest_reg = Substr(instruction, 0, index);	// For Add, Sub, Mul
                      	} else if((index = Find(instruction,'#',1)) > -1) {	
				dest_reg = Substr(instruction, 0, index);	// For Load_I
			} else if((index = Find(instruction,'=',1)) > -1) {
				dest_reg = Substr(instruction, 0, index);	// For Load_M
			} else {
                               if(opcode == "LOAD") throw Error_invalid_load_address;
				else 		    throw Error_invalid_destination;
			}
                        debug.push_back(dest_reg);
                } else if(instruction[0] == 'P' && instruction[1] == 'C') {	// For Load_PC
                        dest_reg = "PC";
                        debug.push_back(dest_reg);
			index = 2;
                } else {
                        throw Error_invalid_destination;
                }
                Clear(instruction, 0, index);

                //////  GETS OPERAND 1   //////////
                index = 0;
                if(instruction[0] == '=' && opcode == "LOAD") {         // Load_M, Load PC
                        if(dest_reg == "PC") {
                                dest_reg = instruction; // Remember: dest_reg IR output goes directly into PC
				debug.push_back(dest_reg);
				opcode = "LOAD_PC";
			} else {
                                src_reg1 = instruction; // Reminder: src_reg1 is the RAM address selector
                        	debug.push_back(src_reg1);
				opcode = "LOAD_M";
			}
                        return;                         // Both Load_M and Load_PC only use two registers
                } else if(instruction[0] == '#' && opcode == "LOAD") {  // Load_I
                        src_reg1 = instruction;         // Reminder: src_reg1 is the immediate value for the registers
                        debug.push_back(src_reg1);
                        opcode ="LOAD_I";
			return;
		} else if(instruction[0] == 'R' && opcode == "STORE") { //Store
			src_reg2 = instruction;
                        debug.push_back(src_reg2);
			return;
		} else if(instruction[0] == 'R') {      // Operand 1 for Add, Sub, Mul
                        index = Find(instruction, 'R', 1);
                        if(index > -1) {
                                src_reg1 = Substr(instruction,0,index);
                        	debug.push_back(src_reg1);
                        } else {
                                throw Error_invalid_operand_one;
                        }
                } else {
			if(opcode == "LOAD") throw Error_invalid_load_address;
                        throw Error_invalid_operand_one;
		}
                Clear(instruction, 0, index);

                //////  GETS OPERAND 2   ////////
                if(opcode == "ADD" || opcode == "SUB" || opcode == "MUL") {     // Only opcodes two use all registers
                        src_reg2 = instruction;
                        debug.push_back(src_reg2);
                }
		instruction = copy;
        } catch(int error_code) {
		fail = true;
		error::print(logs, error_code, error_line, copy);
        }
}
