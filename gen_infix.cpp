#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;

char * gen_infix(char operandl[], char op[], char operand2[])
{

  std::cout << op << " | " << operandl << " | " << operand2 << std::endl;
  std::cout << (void*)op << " | " << (void*)operandl << " | " << (void*)operand2 << std::endl;
  static int max_temp=0;
  static char tempname[30];

  char tempop[8];

  if ( strcmp( op, "Add") )
    	strcpy(tempop,"iadd" );
  else if ( strcmp(op, "Sub"))
	strcpy(tempop,"isub" );
  else if ( strcmp(op, "Mult"))
	strcpy(tempop, "imult");
  else if (strcmp(op, "Div"))
	strcpy(tempop, "idiv");
  else if (strcmp(op, "Mod"))
	strcpy(tempop, "imod");
  max_temp++;
  sprintf(tempname, "&tempi%d" ,max_temp);
  outFile << tempop << " " << operandl << ", " << operand2 << ", " << tempname << std::endl;

  symTable.insertSymbol(tempname, "integer");

  return (tempname);
}
