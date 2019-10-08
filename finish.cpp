#include <iostream>
#include <fstream>
#include "SymbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;

void finish()
{
  outFile << "halt" << std::endl;
}
