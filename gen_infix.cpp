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
  // std::cout << operand1 << " " << op << " " << operand2 << std::endl;
  char tempop[8];
  static char tempname[30];
  
  // hacky/doesnt check for type 
  strcpy(tempname, createTempIntegerAddress());
  
  // if(isReal(operand1) != isReal(operand2)){
  //   yyerror("Type mismatch in expression.");
  // }

  //have to type check, add different prefixes to 
  if ( strcmp( op, "add")==0 ){
     strcpy(tempop,"iadd");
   }
   else if ( strcmp(op, "sub")==0){
     strcpy(tempop,"isub" );
   }
   else if ( strcmp(op, "mult")==0){
     strcpy(tempop, "imult");
   }
   else if (strcmp(op, "div")==0){
     strcpy(tempop, "idiv");
   }
   else if (strcmp(op, "mod")==0){
    strcpy(tempop, "imod");
   }
  outFile << tempop << " " << operand1 << ", " << operand2 << ", " << tempname << std::endl;
  return (tempname);
}
