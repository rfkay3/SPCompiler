#include <stdio.h>
#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;

void write_expr(char id_name[])
{
   outFile << "write " << id_name << ", " << "__TYPE__" << std::endl;
}
