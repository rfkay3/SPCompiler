#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;
std::string createTempIntegerAddress();
std::string createTempRealAddress();

char * gen_infix(char operandl[], char op[], char operand2[])
{
  static int max_temp=0;
  static char tempname[30];
  
  char tempop[8];


  //have to type check, add different prefixes to 
  if ( strcmp( op, "Add")==0 ){
     strcpy(tempop,"iadd" );
   }
   else if ( strcmp(op, "Sub")==0){
     strcpy(tempop,"isub" );
   }
   else if ( strcmp(op, "Mult")==0){
     strcpy(tempop, "imult");
   }
   else if (strcmp(op, "Div")==0){
     strcpy(tempop, "idiv");
   }
   else if (strcmp(op, "Mod")==0){
    strcpy(tempop, "imod");
   }
  max_temp++;
  sprintf(tempname, "&tempi" ,max_temp);
  outFile << tempop << " " << operandl << ", " << operand2 << ", " << tempname << std::endl;
  return (tempname);
}
