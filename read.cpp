#include <stdio.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include "symbolTable.h"

extern SymbolTable symTable;
extern std::stringstream * curr_buffer;

void read_id (char id_name[])
{
     *curr_buffer << "read " << id_name << ", " << symTable.typeOf(id_name) << std::endl;;
}
