#include "symbolTable.h"
extern SymbolTable symTable;

bool isReal(char value[]){
	if(symTable.lookupSymbol(value)){
		return symTable.typeOf(value) == "real";
	} else {
		for(int i = 0; value[i] != '\0'; i++) {
			if(value[i] == '.'){
				return true;
			}
		}
	}
	return false;
}