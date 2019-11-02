#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;
extern std::string createTempIntegerAddress();
extern std::string createTempRealAddress();


/**
 * Returns a string representing a temporary address to a stored
 * integer.
 * @param source - a char[] representing an initializing value or variable 
 * @return - a string representing a temporary address
 */
std::string storeIntegerTemp(char source[]){
	std::string tempAddr = createTempIntegerAddress();
	outFile << "store " << source << ", " << tempAddr << std::endl;
	return tempAddr;
}

/**
 * Returns a string representing a temporary address to a stored
 * real number.
 * @param source - a char[] representing an initializing value or variable 
 * @return - a string representing a temporary address
 */
std::string storeRealTemp(char source[]){
	std::string tempAddr = createTempRealAddress();
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
std::string realToInteger(char target[], char source[]){
	std::string firstTemp = storeRealTemp(source);
	std::string secondTemp = createTempIntegerAddress();
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
std::string integerToReal(char target[], char source[]){
	std::string firstTemp = storeIntegerTemp(source);
	std::string secondTemp = createTempRealAddress();
	outFile << "itor " << firstTemp << ", " << secondTemp << std::endl;
	return secondTemp;
}

bool isReal(char value[]){
	for(int i = 0; value[i] != '\0'; i++) {
		if(value[i] == '.'){
			return true;
		}
	}
	return false;
}

void assign (char target[], char source[])
{
	std::string sourceAddr(source);
	if (symTable.typeOf(target) == "real") {
		if(symTable.lookupSymbol(source)) {
			if(symTable.typeOf(source) == "integer"){
				sourceAddr = integerToReal(target, source);	
			}
		} else {
			if(!isReal(source)) {
				sourceAddr = integerToReal(target, source);
			}	
		}
	} else if (symTable.typeOf(target) == "integer") {
                if(symTable.lookupSymbol(source)) {
                        if(symTable.typeOf(source) == "real"){
                                sourceAddr = realToInteger(target, source);
                        }
                } else {
                        if(isReal(source)) {
                                sourceAddr = realToInteger(target, source);
                        }
                }
        }
    	outFile << "store " << sourceAddr << ", " << target << std::endl;
}
