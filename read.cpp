#include <stdio.h>
#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;

void read_id (char id_name[])
{
     outFile << "read " << id_name << ", " << symTable.typeOf(id_name) << std::endl;;
}
