#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <fstream>
extern std::ofstream outFile;

char * gen_infix(char operandl[], char op[], char operand2[])
{
  static int max_temp=0;
  static char tempname[30];
  
  char tempop[8];

  if ( strcmp( op, "Add") )
    strcpy(tempop,"iadd" );
  else
	strcpy(tempop,"isub" );
  max_temp++;
  sprintf(tempname, "&tempi" ,max_temp);
  outFile << tempop << " " << operandl << ", " << operand2 << ", " << tempname << std::endl;
  return (tempname);
}
