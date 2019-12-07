#include <stdio.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include "symbolTable.h"
#include "parsedValue.h"

extern SymbolTable symTable;
extern const char * createTempLabel();
extern void yyerror(const char s[]);
extern std::stringstream * curr_buffer;

void write_expr(char id_name[]) {
   *curr_buffer << "write " << id_name << std::endl;
}

void write_label(const char * label) {
   *curr_buffer << label << std::endl;
}

ParsedValue * jump (char * label) {
   *curr_buffer << "jmp " << label << std::endl;
   return new ParsedValue(label, "label");
}

ParsedValue * conditionalJump(const char * jump_if, ParsedValue * cond, char * label) {
   if ( strcmp(cond->getType(), "integer") != 0){
    yyerror("Conditional must evaluate to boolean.");
   }

   if(strcmp(jump_if, "true") == 0) {
      *curr_buffer << "jt " << cond->getValue() << ", " << label << std::endl;
   } else if (strcmp(jump_if, "false") == 0) {
      *curr_buffer << "jf " << cond->getValue() << ", " << label << std::endl;
   }
   return new ParsedValue(strdup(label), "label");
}
