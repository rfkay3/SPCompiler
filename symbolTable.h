#include <unordered_map>
#include <string>
#include <iostream>

class ScopeNode{
public:
	ScopeNode();
	bool lookup(const char symbol[]);
	bool isType(const char symbol[], const std::string& type);
	void insert(const char symbol[], const char type[]);

	std::unordered_map<std::string, std::string> scopeTable;
	ScopeNode* next;
};

class SymbolTable{
public:
	SymbolTable();
	bool lookupSymbol(const char symbol[]);
	bool lookupType(const char symbol[], const std::string& type);
	void insertSymbol(const char symbol[], const char type[]);
	void enterScope();
	void exitScope();

	ScopeNode* head;
};

