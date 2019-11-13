#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <fstream>
#include "symbolTable.h"
#include "parsedValue.h"

extern std::ofstream outFile;
extern SymbolTable symTable;
extern char * createTempIntegerAddress();
extern char * createTempRealAddress();
extern char * createTempStringAddress();
extern char * createTempBooleanAddress();
extern bool isReal(char value[]);
extern void yyerror(const char s[]);
extern char * integerToReal(char source[]);

ParsedValue * gen_infix(ParsedValue * operand1, char * op, ParsedValue * operand2){
  // std::cout << operand1->getValue() << " " << op << " " << operand2->getValue() << std::endl;

  if( strcmp(operand1->getType(), "string") == 0 && strcmp(operand2->getType(), "string") == 0) {
    if( strcmp(op, "add") == 0){
      outFile << "concat " << operand1->getValue() << ", " << operand2->getValue() << ", " 
              << operand1->getValue() << std::endl;
      return operand1;
    } else {
      yyerror("Operator not supported for type STRING.");
    }
  }

  if ( strcmp(operand1->getType(), "char") == 0 || strcmp(operand2->getType(), "char") == 0){
    yyerror("Unsupported operator for type: character.");
  }

  if ( strcmp(operand1->getType(), "boolean") == 0 || strcmp(operand2->getType(), "boolean") == 0){
    yyerror("Unsupported operator for type: boolean.");
  }

  char * tempname;

  if (strcmp(operand1->getType(), "real") == 0 && strcmp(operand2->getType(), "integer") == 0) {
    char * newVal = integerToReal(operand2->getValue());
    operand2 = new ParsedValue(strdup(newVal), "real");
    tempname  = createTempRealAddress();
  } else if (strcmp(operand1->getType(), "integer") == 0 && strcmp(operand2->getType(), "real") == 0) {
    char * newVal = integerToReal(operand1->getValue());
    operand1 = new ParsedValue(strdup(newVal), "real");
    tempname  = createTempRealAddress();
  } else {
    tempname = createTempIntegerAddress();
  }

  

  if (strcmp(operand1->getType(), "real") == 0){
    outFile << "r";
  } else {
    outFile << "i";
  }

  

  outFile << op << " " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
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
  
  char * tempname = strdup(createTempBooleanAddress());

  if (strcmp(operand1->getType(), "real") == 0 && strcmp(operand2->getType(), "integer") == 0) {
    char * newVal = integerToReal(operand2->getValue());
    operand2 = new ParsedValue(strdup(newVal), "real");
  } else if (strcmp(operand1->getType(), "integer") == 0 && strcmp(operand2->getType(), "real") == 0) {
    char * newVal = integerToReal(operand1->getValue());
    operand1 = new ParsedValue(strdup(newVal), "real");
  }

  if(strcmp(op, "gt") == 0) {
    outFile << "high " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    return new ParsedValue(strdup(tempname), "boolean");
  } else if(strcmp(op, "lt") == 0) {
    outFile << "low " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    return new ParsedValue(strdup(tempname), "boolean");
  } else if(strcmp(op, "ltequal") == 0) {
    outFile << "high " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    char * tempname2 = strdup(createTempBooleanAddress());
    outFile << "not " << tempname << ", " << tempname2 << std::endl;
    return new ParsedValue(strdup(tempname2), "boolean");
  } else if(strcmp(op, "gtequal") == 0) {
    outFile << "low " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    char * tempname2 = strdup(createTempBooleanAddress());
    outFile << "not " << tempname << ", " << tempname2 << std::endl;
    return new ParsedValue(strdup(tempname2), "boolean");
  } else if(strcmp(op, "equal") == 0) {
    outFile << "equal " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    return new ParsedValue(strdup(tempname), "boolean");
  } else if(strcmp(op, "notequal") == 0) {
    outFile << "equal " << operand1->getValue() << ", " << operand2->getValue() << ", " << tempname << std::endl;
    char * tempname2 = strdup(createTempBooleanAddress());
    outFile << "not " << tempname << ", " << tempname2 << std::endl;
    return new ParsedValue(strdup(tempname2), "boolean");
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
  
}

ParsedValue * boolean_not(char * op, ParsedValue * operand1) {
  //IMPLEMENT NOT INSTRUCTION
}
