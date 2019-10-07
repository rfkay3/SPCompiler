// implement a linked list of hash tables
#include <unordered_map>

class SymbolTable{
public:
lookupSymbol(char* symbol);
insertSymbol(char* symbol, char* type);

private:
std:unordered_map<std::string, std::string> table;
}

