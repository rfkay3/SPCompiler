#include <stdio.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include "symbolTable.h"
#include "parsedValue.h"

extern std::ofstream outFile;
extern SymbolTable symTable;
extern const char * createTempLabel();
extern void yyerror(const char s[]);


void write_expr(char id_name[]) {
   outFile << "write " << id_name << std::endl;
}

void write_label(const char * label) {
   outFile << label << std::endl;
}

ParsedValue * jump () {
   char * label = strdup(createTempLabel());
   outFile << "jmp " << label << std::endl;
   return new ParsedValue(label, "label");
}

ParsedValue * conditionalJump(const char * jump_if, ParsedValue * cond) {
   if ( strcmp(cond->getType(), "integer") != 0){
    yyerror("Conditional must evaluate to boolean.");
   }

   char * jumpLabel = strdup(createTempLabel());
   if(strcmp(jump_if, "true") == 0) {
      outFile << "jt " << cond->getValue() << ", " << jumpLabel << std::endl;
   } else if (strcmp(jump_if, "false") == 0) {
      outFile << "jf " << cond->getValue() << ", " << jumpLabel << std::endl;
   }
   return new ParsedValue(strdup(jumpLabel), "label");
}

int expCheck(ParsedValue * cond, int whileCounter) {
   if (strcmp(cond->getType(), "integer") != 0) {
      yyerror("Conditional must evaluate to boolean.");
   }

   if (strcmp(cond->getValue(), "1") == 0 && whileCounter < 1) {
      whileCounter++;
      return 1;
   } else if (strcmp(cond->getValue(), "1") == 0 && whileCounter > 0) {
      return 2; // return number of times it has to go through the loop
   } else {
      whileCounter = 0;
      return 0;
   }
}