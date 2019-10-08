#include <stdio.h>
#include <iostream>
#include <fstream>
extern std::ofstream outFile;

void write_expr(char id_name[])
{
   outFile << "write " << id_name << ", " << "__TYPE__" << std::endl;
}
