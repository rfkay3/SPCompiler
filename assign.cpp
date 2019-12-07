#include <iostream>
#include <fstream>
#include <sstream>
#include <string.h>
#include "symbolTable.h"
#include "parsedValue.h"

extern std::stringstream * curr_buffer;
extern SymbolTable symTable;
extern char * createTempIntegerAddress();
extern char * createTempRealAddress();
extern bool isReal(char value[]);
extern void yyerror(const char s[]);

/**
 * Returns a string representing a temporary address to a stored
 * integer.
 * @param source - a char[] representing an initializing value or variable 
 * @return - a string representing a temporary address
 */
char * storeIntegerTemp(char source[]){
	char * tempAddr = createTempIntegerAddress();
	*curr_buffer << "store " << source << ", " << tempAddr << std::endl;
	return tempAddr;
}

/**
 * Returns a string representing a temporary address to a stored
 * real number.
 * @param source - a char[] representing an initializing value or variable 
 * @return - a string representing a temporary address
 */
char * storeRealTemp(char source[]){
	char * tempAddr = createTempRealAddress();
	*curr_buffer << "store " << source << ", " << tempAddr << std::endl;
	return tempAddr;
}


/**
 * Creates two temporary addresses, one to a real number and one to an
 * integer, performs coercion on temporary addresses, and stores the 
 * result in the target variable.
 * @param target - A char[] representing the assignment target
 * @param source - A char[] representinf the source for assignment.
 */
char * realToInteger(char source[]){
	char * firstTemp = storeRealTemp(source);
	char * secondTemp = createTempIntegerAddress();
	*curr_buffer << "rtoi " << firstTemp << ", " << secondTemp << std::endl;
	return secondTemp;
}


/**
 * Creates two temporary addresses, one to a an integer and one to a
 * real number, performs coercion on temporary addresses, and stores the 
 * result in the target variable.
 * @param target - A char[] representing the assignment target
 * @param source - A char[] representinf the source for assignment.
 */
char * integerToReal(char source[]){
	char * firstTemp = storeIntegerTemp(source);
	char * secondTemp = createTempRealAddress();
	*curr_buffer << "itor " << firstTemp << ", " << secondTemp << std::endl;
	return secondTemp;
}

void assign (char target[], ParsedValue * source)
{
	/*throws std::logic_error basic_string::_M_construct null not valid
	if(strcmp(symTable.scopeName(), "program") != 0){
		std::string newTarget = symTable.scopeName();
		newTarget.append(".");
		newTarget.append(target);
		const char * s = newTarget.c_str();
		std::cout << strdup(s) << std::endl;

	}
	*/

	// Derive types of source and target.
	const char * target_type = symTable.typeOf(target).c_str();
	const char * source_type = source->getType();

	// Types of source and target match, perform normal assignment.
	if( strcmp(target_type, source_type) == 0) {
    	*curr_buffer << "store " << source->getValue() /*Addr*/ << ", " << target << std::endl;
	} else {

		// Types of source and target are not the same and are of real or integer, perform type coercion.
		if (strcmp(target_type, "real") == 0 && strcmp(source_type, "integer") == 0) {
			char * convertAddr = integerToReal(source->getValue());
			*curr_buffer << "store " << convertAddr << ", " << target << std::endl;

		// Types of source and target are not the same and are of real or integer, perform type coercion.
		} else if (strcmp(target_type, "integer") == 0 && strcmp(source_type, "real") == 0) {
			char * convertAddr = realToInteger(source->getValue());
			*curr_buffer << "store " << convertAddr << ", " << target << std::endl;

		// Types of source and target are not the same, and are invalid for type coercion.
		} else if (strcmp(target_type, "boolean") == 0 && strcmp(source_type, "integer") == 0) {
		       *curr_buffer << "store " << source->getValue() /*Addr*/ << ", " << target << std::endl;
		} else {
			char buff[128];
			sprintf(buff, "Cannot store %s in %s.", source->getType(), symTable.typeOf(target).c_str());
			yyerror(buff); 
		}
	}
	
}
