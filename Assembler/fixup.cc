#include <iostream>
#include <string>
#include <fstream>

// Iterates through string and if it finds an ' ` ' its replaced with #
void fix(std::string& line, bool& skip) {
	int occurence = 0;
	for(int i = 0; i < line.size(); i++) {
		if(line[i] == '`') {
			line[i] = '#';
			occurence++;
			// If an ' ` ' occurs more than twice on a line it will not print it into parameters.h
			if(occurence == 2) {
				skip = true;
				break;
			}
		}
	}
}

int main() {
	std::ifstream input("parameters.v");			// Opens the parameters.v file,  Verilog header
	std::ofstream output("Assembler/parameters.h");		// Outputs into parameters.h file, C++ header
	std::string line = "";					// Hold the line read in from the Verilog header
	while(getline(input, line)) {				// Reads through the parameters.v until it reaches the end
			bool skip = false;
			fix(line, skip);			// Fixes the line
			if(!skip) {			
				output << line << "\n";
			}
	}
	input.close();
	output.close();
}
