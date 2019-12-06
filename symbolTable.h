#include <unordered_map>
#include <string>
#include <iostream>
#include <vector>

class ScopeNode{
public:
	ScopeNode(std::string name);
	bool lookup(const char symbol[]);
	std::string getType(const char symbol[]);
	void insert(const char symbol[], const char type[]);
	std::string getRoutineType(const char routine[]);
	void insertRoutine(const char routine[], const char type[]);
	bool lookupRoutine(const char name[]);
	std::string getScopeName();
	std::unordered_map<std::string, std::string> scopeTable;
	std::unordered_map<std::string, std::string> routines;
	std::string scopeRoutineName;
	ScopeNode* next;
};

class SymbolTable{
public:
	SymbolTable();
	bool lookupSymbol(const char symbol[]);
	std::string typeOf(const char symbol[]);
	void insertSymbol(const char symbol[], const char type[]);
	void insertProcedure(const char name[]);
	void insertFunction(const char name[], const char type[]);
	bool lookupFunction(const char name[]);
	bool lookupSubroutine(const char name[]);
	char * scopeName();
	void enterScope(std::string newName);
	void exitScope();

	ScopeNode* head;
};

