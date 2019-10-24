#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;

/**
 * Returns a temporary address to an integer. Increments
 * a static integer to make sure no same address is returned 
 * to two calls of this method.
 * @return - A string representing the generated temp address
 */
std::string createTempIntegerAddress(){
	static int tempIntCount = 1;
	static char tempIntName [30];
	sprintf(tempIntName, "tempi%d", tempIntCount);
	tempIntCount++;
	return std::string(tempIntName);
}

/**
 * Returns a temporary address to a real number. Increments
 * a static integer to make sure no same address is returned 
 * to two calls of this method.
 * @return - A string representing the generated temp address
 */
std::string createTempRealAddress(){
	static int tempRealCount = 1;
	static char tempRealName [30];
	sprintf(tempRealName, "tempr%d", tempRealCount);
	tempRealCount++;
	return std::string(tempRealName);
}

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
void realToInteger(char target[], char source[]){
	std::string firstTemp = storeRealTemp(source);
	std::string secondTemp = createTempIntegerAddress();
	outFile << "rtoi " << firstTemp << ", " << secondTemp << std::endl;
	outFile << "store " << secondTemp << ", " << target << std::endl;
}


/**
 * Creates two temporary addresses, one to a an integer and one to a
 * real number, performs coercion on temporary addresses, and stores the 
 * result in the target variable.
 * @param target - A char[] representing the assignment target
 * @param source - A char[] representinf the source for assignment.
 */
void integerToReal(char target[], char source[]){
	std::string firstTemp = storeIntegerTemp(source);
	std::string secondTemp = createTempRealAddress();
	outFile << "itor " << firstTemp << ", " << secondTemp << std::endl;
	outFile << "store " << secondTemp << ", " << target << std::endl;
}

void assign (char target[], char source[])
{
    	outFile << "store " << source << ", " << target << std::endl;
}
