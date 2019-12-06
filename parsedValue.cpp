#include <string.h>
#include <iostream>
#include "parsedValue.h"

ParsedValue::ParsedValue(const char * unboundValue, const char * unboundType){
    value = unboundValue;
    type = unboundType;
}

char * ParsedValue::getValue(){
    return strdup(value);
}

char * ParsedValue::getType(){
    return strdup(type);
}
