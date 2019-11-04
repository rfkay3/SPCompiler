#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;
extern char * createTempIntegerAddress();
extern char * createTempRealAddress();
extern bool isReal(char value[]);
extern void yyerror(const char s[]);

char *gen_infix(char * operand1, char * op, char * operand2)
{
  char tempop[8];
  static char tempname[30];
  
  // hacky
  strcpy(tempname, createTempIntegerAddress());
  
  if(isReal(operand1) != isReal(operand2)){
    yyerror("Type mismatch in expression.");
  }

  //have to type check, add different prefixes to 
  if ( strcmp( op, "Add")==0 ){
     strcpy(tempop,"iadd");
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
  outFile << tempop << " " << operand1 << ", " << operand2 << ", " << tempname << std::endl;
  return (tempname);
}
