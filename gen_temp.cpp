#include <string>

extern void decl_id(char id[], const char type[]);

const char * createTempIntegerAddress(){
	static int tempIntCount = 1;
	static char tempIntName [30];
	sprintf(tempIntName, "&tempi%d", tempIntCount);
	decl_id(tempIntName, "integer");
	tempIntCount++;
	return tempIntName;
}

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

const char * createTempLabel(){
	static int tempLabelCount = 1;
	static char tempLabelName [30];
	sprintf(tempLabelName, ":&temp%d", tempLabelCount);
	tempLabelCount++;
	return tempLabelName;
}
