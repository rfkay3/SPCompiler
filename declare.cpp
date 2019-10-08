#include <iostream>
#include <fstream>
#include "SymbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;

void decl_id (char identifier[], const char type[])
{
     /* Generate code for declaration. */
    	outFile << "declare " << identifier << ", " << type << std::endl;
}
