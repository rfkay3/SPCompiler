#include <stdio.h>
#include <iostream>
#include <fstream>
#include "SymbolTable.h"

extern std::ofstream outFile;
extern SYmbolTable symTable;

void write_expr(char id_name[])
{
   outFile << "write " << id_name << ", " << "__TYPE__" << std::endl;
}
