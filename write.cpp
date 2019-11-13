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

// TODO: Labels currently output to assembly do not correctly represent
//       desired control flow. Could be grammar problem. Fix it!!!!!!!!!

ParsedValue * jump () {
   char * label = strdup(createTempLabel());
   outFile << "jmp " << label << std::endl;
   return new ParsedValue(label, "label");
}

ParsedValue * conditionalJump(const char * jump_if, ParsedValue * cond) {
   if ( strcmp(cond->getType(), "boolean") != 0){
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