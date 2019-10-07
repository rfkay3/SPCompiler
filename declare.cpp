#include <iostream>
#include <fstream>
extern std::ofstream outFile;

void decl_id (char identifier[], const char type[])
{
     /* Generate code for declaration. */
    	outFile << "declare " << identifier << ", " << type << std::endl;
}

  
  
  
