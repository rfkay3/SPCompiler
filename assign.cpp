#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;
extern char * createTempIntegerAddress();
extern char * createTempRealAddress();
extern bool isReal(char value[]);

/**
 * Returns a string representing a temporary address to a stored
 * integer.
 * @param source - a char[] representing an initializing value or variable 
 * @return - a string representing a temporary address
 */
char * storeIntegerTemp(char source[]){
	char * tempAddr = createTempIntegerAddress();
	outFile << "store " << source << ", " << tempAddr << std::endl;
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
	outFile << "store " << source << ", " << tempAddr << std::endl;
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
	outFile << "rtoi " << firstTemp << ", " << secondTemp << std::endl;
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
	outFile << "itor " << firstTemp << ", " << secondTemp << std::endl;
	return secondTemp;
}

void assign (char target[], char source[])
{
	char * sourceAddr = source;
	if (symTable.typeOf(target) == "real") {
		if(symTable.lookupSymbol(source)) {
			if(symTable.typeOf(source) == "integer"){
				sourceAddr = integerToReal(source);	
			}
		} else {
			if(!isReal(source)) {
				sourceAddr = integerToReal(source);
			}	
		}
	} else if (symTable.typeOf(target) == "integer") {
        if(symTable.lookupSymbol(source)) {
                if(symTable.typeOf(source) == "real"){
                        sourceAddr = realToInteger(source);
                }
        } else {
                if(isReal(source)) {
                        sourceAddr = realToInteger(source);
                }
        }
    }
    outFile << "store " << sourceAddr << ", " << target << std::endl;
	
}
