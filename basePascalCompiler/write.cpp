#include <stdio.h>
#include <iostream>
#include <fstream>
extern std::ofstream outFile;

void write_expr(char * id_name)
{
   outFile << "Write" << id_name << ", integer" << std::endl;
}
