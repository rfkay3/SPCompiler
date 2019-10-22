#include <iostream>
#include <fstream>
#include "symbolTable.h"

extern std::ofstream outFile;
extern SymbolTable symTable;

void assign (char target[], char source[])
{
	std::string repSource(source);
	if(!symTable.lookupSymbol(source)) {
		if(symTable.typeOf(target) == "real" && repSource.find(".") == std::string::npos){
			std::string tempVar = "temp";
			outFile << "itor " << source << ", " << target << std::endl;
			return;
		}
		if(symTable.typeOf(target) == "integer" && repSource.find(".") != std::string::npos){
                        std::string tempVar = "temp";
                        outFile << "rtoi " << source << ", " << target << std::endl;
                        return;
                }
	} else {
		if(symTable.typeOf(target) != symTable.typeOf(source)){
			if(symTable.typeOf(target) == "real"){
				outFile << "itor " << source << ", " << target << std::endl;
			}
			if(symTable.typeOf(target) == "integer"){
                                outFile << "rtoi " << source << ", " << target << std::endl;
                        }
		}
	}
    	outFile << "store " << source << ", " << target << std::endl;
}
