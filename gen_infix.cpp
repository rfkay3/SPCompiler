#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;
extern std::string createTempIntegerAddress();
extern std::string createTempRealAddress();
extern bool isReal(char value[]);
extern void yyerror(const char s[]);

char * gen_infix(char operand1[], char op[], char operand2[])
{
  //TODO:
  /* 
  * Currently, operand1 contains the math op instead of the first operand provided
  * in the expression. Need to take a look at the grammar and figure out why the
  * args are passed this way instead of the correct way.
  */
  static int max_temp=0;
  static char tempname[30];
  char tempop[8];

  /*TODO: sun upon fixing of the argument problem.
  if(isReal(operand1) != isReal(operand2)){
    yyerror("Type mismatch in expression.");
  }
  */

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
  outFile << tempop << " " << operand1 << ", " << operand2 << ", " << tempname << std::endl;
  return (tempname);
}
