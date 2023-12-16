#pragma once
//////// Parameter Files
#include "parameters.h"
//// Error Code Names ////
#define Error_invalid_command		0
#define Error_invalid_destination	1
#define Error_invalid_load_immediate  	2
#define Error_invalid_load_address	3
#define Error_invalid_operand_one	4
#define Error_invalid_operand_two	5
#define Error_invalid_syntax		6
#define Error_too_many_arguments	7
#define Error_too_few_arguments		8
#define Error_file_too_large		9
#define Error_invalid_pc_address	10
#define Error_invalid_memory_address	11
#define Error_invalid_immediate_value	12

namespace error {
	// Number of Errors that Occured //
	int count = 0;
	std::vector<std::string> interpreter = {
	/* Error Code: 0 */	"Invalid Command",		
	/* Error Code: 1 */	"Invalid Destination",
	/* Error Code: 2 */	"Invalid Load Immediate Value",
	/* Error Code: 3 */	"Invalid Load Address Value",		
	/* Error Code: 4 */	"Invalid Operand 1 Register",
	/* Error Code: 5 */	"Invalid Operand 2 Register",
	/* Error Code: 6 */	"Syntax Error Exists",
	/* Error Code: 7 */	"Too Many Arguments",
	/* Error Code: 8 */	"Too Few Arguments",
	/* Error Code: 9 */	"Assembly file is too large. Exceeds 64 lines of code (comments don't affect this)",
	/* Error Code: 10 */	("Invalid PC Load Address, out of range: 0 - " + std::to_string(MAX_ADDR_VAL)),
	/* Error Code: 11 */	("Invalid Memory Load Address, out of range: 0 - " + std::to_string(MAX_ADDR_VAL)),
	/* Error Code: 12 */	("Invalid Immediate Load Value, out of range range: 0 - " + std::to_string(MAX_DATA_VAL))
	};
	void print(std::ofstream& logs, int error_code, int error_line, std::string bad_instruction) {
		error::count++;
		if(error_code > error::interpreter.size()) throw std::runtime_error("Error: - Castrophic Failure\n");
		std::cout << "Error Code: " << std::to_string(error_code) << " - " << error::interpreter[error_code] <<
			"\n\t\tLine: " << std::to_string(error_line) << "\t\t"<< bad_instruction << "\n\n";
		logs << "Error Code: " << std::to_string(error_code) << " - " << error::interpreter[error_code] <<
			"\n\t\tLine: " << std::to_string(error_line) << "\t\t"<<  bad_instruction << "\n\n";
	}
	void print_status(std::ofstream& logs) {		
		if(error::count) {
			std::cout << "\n\n\n" << "\033[1m\033[31m" << "UNSUCCESSFUL" << "\033[37m" << "\tError Count: " << error::count << "\n\n\n";
			logs << "\n\n\n" << "UNSUCCESSFUL" << "\tError Count: " << error::count << "\n\n\n";
		} else {
			std::cout << "\n\n\n" << "\033[1m\033[32m" << "SUCCESSFUL" << "\033[37m" << "\n\n\n";
			logs << "\n\n\n" << "SUCCESSFUL" << "\n\n\n";
		}
	}
};
