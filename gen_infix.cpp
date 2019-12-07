#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include "symbolTable.h"
#include "parsedValue.h"

extern SymbolTable symTable;
extern char * createTempIntegerAddress();
extern char * createTempRealAddress();
extern char * createTempStringAddress();
extern bool isReal(char value[]);
extern void yyerror(const char s[]);
extern char * integerToReal(char source[]);
extern std::stringstream * curr_buffer;

ParsedValue * gen_infix(ParsedValue * operand1, char * op, ParsedValue * operand2){
  // std::cout << operand1->getType() << " " << op << " " << operand2->getType() << std::endl;

  if( strcmp(operand1->getType(), "string") == 0 && strcmp(operand2->getType(), "string") == 0) {
    if( strcmp(op, "add") == 0){
      *curr_buffer << "concat " << operand1->getValue() << ", " << operand2->getValue() << ", " 
              << operand1->getValue() << std::endl;
      return operand1;
    } else {
      yyerror("Operator not supported for type STRING.");
    }
  }

  if ( strcmp(operand1->getType(), "char") == 0 || strcmp(operand2->getType(), "char") == 0){
    yyerror("Unsupported operator for type: character.");
  }

  char * tempname;

  if (strcmp(operand1->getType(), "real") == 0 && strcmp(operand2->getType(), "integer") == 0) {
    char * newVal = integerToReal(operand2->getValue());
    operand2 = new ParsedValue(strdup(newVal), "real");
  } else if (strcmp(operand1->getType(), "integer") == 0 && strcmp(operand2->getType(), "real") == 0) {
    char * newVal = integerToReal(operand1->getValue());
    operand1 = new ParsedValue(strdup(newVal), "real");
  }

  if (strcmp(operand1->getType(), "real") == 0){
    tempname = createTempRealAddress();
    *curr_buffer << "r";
  } else {
    tempname = createTempIntegerAddress();
    *curr_buffer << "i";
  }

  *curr_buffer << op << " " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
  return (new ParsedValue(strdup(tempname), operand1->getType()));
}


ParsedValue * relation_infix(ParsedValue * operand1, char * op, ParsedValue * operand2) {
  // Type check for disallowed types. If found, raise an error.
  if ( strcmp(operand1->getType(), "string") == 0 || strcmp(operand2->getType(), "string") == 0){
    yyerror("Unsupported operator for type: character.");
  }

  if ( strcmp(operand1->getType(), "char") == 0 || strcmp(operand2->getType(), "char") == 0){
    yyerror("Unsupported operator for type: character.");
  }
  
  //Initialize tempname to a new temporary boolean
  char * tempname = strdup(createTempIntegerAddress());

  if (strcmp(operand1->getType(), "real") == 0 && strcmp(operand2->getType(), "integer") == 0) {
    char * newVal = integerToReal(operand2->getValue());
    operand2 = new ParsedValue(strdup(newVal), "real");
  } else if (strcmp(operand1->getType(), "integer") == 0 && strcmp(operand2->getType(), "real") == 0) {
    char * newVal = integerToReal(operand1->getValue());
    operand1 = new ParsedValue(strdup(newVal), "real");
  }

  if(strcmp(op, "gt") == 0) {
    *curr_buffer << "high " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    return new ParsedValue(strdup(tempname), "integer");
  } else if(strcmp(op, "lt") == 0) {
    *curr_buffer << "low " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    return new ParsedValue(strdup(tempname), "integer");
  } else if(strcmp(op, "ltequal") == 0) {
    *curr_buffer << "high " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    char * tempname2 = strdup(createTempIntegerAddress());
    *curr_buffer << "not " << tempname << ", " << tempname2 << std::endl;
    return new ParsedValue(strdup(tempname2), "integer");
  } else if(strcmp(op, "gtequal") == 0) {
    *curr_buffer << "low " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    char * tempname2 = strdup(createTempIntegerAddress());
    *curr_buffer << "not " << tempname << ", " << tempname2 << std::endl;
    return new ParsedValue(strdup(tempname2), "integer");
  } else if(strcmp(op, "equal") == 0) {
    *curr_buffer << "equ " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    return new ParsedValue(strdup(tempname), "integer");
  } else if(strcmp(op, "notequal") == 0) {
    *curr_buffer << "equ " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    char * tempname2 = strdup(createTempIntegerAddress());
    *curr_buffer << "not " << tempname << ", " << tempname2 << std::endl;
    return new ParsedValue(strdup(tempname2), "integer");
  } else {
    yyerror("Unsupported relational operator.");
  }
}

ParsedValue * boolean_infix(ParsedValue * operand1, char * op, ParsedValue * operand2) {
  //Same principle as gen_infix
  /**
  ONLY BOOLEANS
  IMPLEMENT AND & OR
  */
  // Type check for disallowed types. If found, raise an error.
  if ( strcmp(operand1->getType(), "integer") != 0 || strcmp(operand2->getType(), "integer") != 0){
    yyerror("Unsupported operator for type: character.");
  }

  //Initialize tempname to a new temporary boolean
  char * tempname = strdup(createTempIntegerAddress());

  if(strcmp(op, "and") == 0) {
    *curr_buffer << "and " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    return new ParsedValue(strdup(tempname), "integer");
  } else if(strcmp(op, "or") == 0) {
    *curr_buffer << "or " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    return new ParsedValue(strdup(tempname), "integer");
  } else {
    yyerror("Unsupported boolean operator.");
  }
  
}

ParsedValue * boolean_not(char * op, ParsedValue * operand1) {
  if ( strcmp(operand1->getType(), "integer") != 0 ){
    yyerror("Unsupported operator for type: character.");
  }

  //Initialize tempname to a new temporary boolean
  char * tempname = strdup(createTempIntegerAddress());
  *curr_buffer << "not " << operand1->getValue() << ", " << tempname << std::endl;
  return new ParsedValue(strdup(tempname), "integer");
}
