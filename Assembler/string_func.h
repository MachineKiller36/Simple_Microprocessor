#pragma once 
//////// Parameter Files
#include "parameters.h"

int string_to_int(std::ofstream& logs, int address, std::string instruction, std::string word) {
        int sum = 0;
	std::string copy = word;
	try {
        	for(char x : word) {
        	        if(x == '\'' || x == ' ' || x == '\t')
				continue;
			else if((int)x-48 < 0 || (int)x-48 > 9) {
				throw Error_invalid_syntax;
			}
			sum *= 10;
        	        sum += (int)x-48;
        	}
        	return sum;
	} catch(int error_code) {
		error::print(logs, error_code, address, copy);
	}
	return -1;
}

void RemoveChar(std::string& word, char ch) {
        size_t found = word.find(ch);
        while(found != std::string::npos) {
                word.erase(found, 1);
                found = word.find(ch, found);
        }
}
void Uppercase(std::string& word) {
        for(int i = 0; i < word.size(); i++) {
                word[i] = std::toupper(word[i]);
        }
}
void Clear(std::string& word, int startpoint, int endpoint) {
        if(startpoint < 0 || startpoint > word.size())
                throw std::runtime_error("Clear: Startpoint is either negative or greater than the words size\n");
        if(endpoint < 0 || endpoint > word.size())
                throw std::runtime_error("Clear: Endpoint is either negative or greater than the words size\n");
        word.erase(startpoint, endpoint);
}
std::string Substr(std::string& word, int startpoint, int endpoint) {
        if(startpoint < 0 || startpoint > word.size()) {
		throw std::runtime_error("Substr: Startpoint is either negative or greater than the words size\n");
	}
	if(endpoint < 0 || endpoint > word.size()) {
                throw std::runtime_error("Substr: Endpoint is either negative or greater than the words size\n");
	}
	std::string temp = "";
        for(int i = startpoint; i < endpoint; i++)
                temp += word[i];
        return temp;
}
int Find(std::string& word, char ch, int start=0) {
        for(int i = start; i < word.size(); i++)
                if(word[i] == ch)
                        return i;
        return -1;
}
