#include <stdio.h>
#include <iostream>
#include <fstream>
#include "SymbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;

void read_id (char id_name[])
{
     outFile << "read " << id_name << ", integer" << std::endl;;
}
