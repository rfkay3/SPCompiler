#include <iostream>
#include <fstream>
#include <sstream>
#include "symbolTable.h"

extern SymbolTable symTable;
extern std::stringstream * curr_buffer;

void decl_id (char identifier[], const char type[])
{
     /* Generate code for declaration. */
    	*curr_buffer << "declare " << identifier << ", " << type << std::endl;
}
