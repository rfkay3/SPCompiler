#include <stdio.h>
#include <iostream>
#include <fstream>
extern std::ofstream outFile;

void read_id (char * id_name)
{
     outFile << "Read" << id_name << ", integer" << std::endl;;
}
