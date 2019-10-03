#include <iostream>
#include <fstream>
extern std::ofstream outFile;

void decl_id (char identifier[])
{
     /* Generate code for declaration. */
    	outFile << "declare " << identifier << ", integer" << std::endl;
}

  
  
  