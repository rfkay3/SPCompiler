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

/**
 * Returns a temporary address to a block. Increments
 * a static integer to make sure no same address is returned 
 * to two calls of this method.
 * @return - A char * representing the generated temp address
 */
const char * createTempBlockAddress(){
        static int tempBlockCount = 1;
        static char tempBlockName [30];
        sprintf(tempBlockName, "&temp%d", tempBlockCount);
        decl_id(tempBlockName, "integer");
        tempBlockCount++;
        return tempBlockName;
}
