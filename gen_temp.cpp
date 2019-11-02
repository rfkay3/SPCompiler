#include <string>

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
