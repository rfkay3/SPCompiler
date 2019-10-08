#include <iostream>
#include <fstream>
#include "SymbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable

void assign (char target[], char source[])
{
     /* Generate code for assignment. */
    	outFile << "store " << source << ", " << target << std::endl;
}
