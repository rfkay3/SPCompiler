#include <string>

extern void decl_id(char id[], const char type[]);


/**
 * Returns a temporary address to an integer. Increments
 * a static integer to make sure no same address is returned 
 * to two calls of this method.
 * @return - A char * representing the generated temp address
 */
const char * createTempIntegerAddress(){
	static int tempIntCount = 1;
	static char tempIntName [30];
	sprintf(tempIntName, "&tempi%d", tempIntCount);
	decl_id(tempIntName, "integer");
	tempIntCount++;
	return tempIntName;
}

/**
 * Returns a temporary address to a real number. Increments
 * a static integer to make sure no same address is returned 
 * to two calls of this method.
 * @return - A char * representing the generated temp address
 */
const char * createTempRealAddress(){
	static int tempRealCount = 1;
	static char tempRealName [30];
	sprintf(tempRealName, "&tempr%d", tempRealCount);
	decl_id(tempRealName, "real");
	tempRealCount++;
	return tempRealName;
}

const char * createTempStringAddress(){
	static int tempStringCount = 1;
	static char tempStringName [30];
	sprintf(tempStringName, "&temps%d", tempStringCount);
	decl_id(tempStringName, "string");
	tempStringCount++;
	return tempStringName;
}

const char * createTempBooleanAddress(){
	static int tempBooleanCount = 1;
	static char tempBooleanName [30];
	sprintf(tempBooleanName, "&tempb%d", tempBooleanCount);
	decl_id(tempBooleanName, "boolean");
	tempBooleanCount++;
	return tempBooleanName;
}
