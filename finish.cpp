#include <iostream>
#include <fstream>
#include <sstream>
#include <deque>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;
extern std::stringstream * curr_buffer;
extern std::deque<std::stringstream*> outFileBuffer;

void outputASM();

void finish()
{
  *curr_buffer << "halt" << std::endl;
  outputASM();
}

void outputASM(){
	outFile << curr_buffer->str() << std::endl;
	while(!outFileBuffer.empty()) {
		curr_buffer = outFileBuffer.front();
		outFile << curr_buffer->str() << std::endl;
		outFileBuffer.pop_front();
	}
}
