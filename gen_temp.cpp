#include <string.h>
#include <string>
#include "parsedValue.h"

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

const char * createTempCharacterAddress(){
	static int tempCharCount = 1;
	static char tempCharName [30];
	sprintf(tempCharName, "&tempc%d", tempCharCount);
	decl_id(tempCharName, "character");
	tempCharCount++;
	return tempCharName;
}

const char * createTempLabel(){
	static int tempLabelCount = 1;
	static char tempLabelName [30];
	sprintf(tempLabelName, ":&temp%d", tempLabelCount);
	tempLabelCount++;
	return tempLabelName;
}

const char * createTempProcedureLabel(ParsedValue * mktemp){
        static int tempProcedureCount = 1;
        static char tempProcedureName [30];
        sprintf(tempProcedureName, ":#%s", mktemp->getValue());
        tempProcedureCount++;
        return tempProcedureName;
}

const char * createTempFunctionLabel(ParsedValue * mktemp){
        static int tempFunctionCount = 1;
        static char tempFunctionName [30];
        sprintf(tempFunctionName, ":#%s", mktemp->getValue());
        tempFunctionCount++;
        return tempFunctionName;
}
