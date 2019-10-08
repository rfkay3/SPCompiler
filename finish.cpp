#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;

void finish()
{
  outFile << "halt" << std::endl;
}
