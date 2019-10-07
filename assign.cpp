#include <iostream>
#include <fstream>
extern std::ofstream outFile;

void assign (char target[], char source[])
{
     /* Generate code for assignment. */
    	outFile << "store " << source << ", " << target << std::endl;
}

  
  
  
