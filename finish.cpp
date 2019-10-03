#include <iostream>
#include <fstream>
extern std::ofstream outFile;

void finish()
{
  outFile << "halt" << std::endl;
}
