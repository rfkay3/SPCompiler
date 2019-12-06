#include <string.h>
#include "symbolTable.h"

extern void yyerror(const char []);

ScopeNode::ScopeNode(std::string name){
	scopeRoutineName = name;
	next = NULL;
}

bool ScopeNode::lookup(const char symbol[]){
	std::string sym_str(symbol);
	return scopeTable.count(sym_str) > 0;
}

std::string ScopeNode::getType(const char symbol[]){
	std::string sym_str(symbol);
	return scopeTable.at(sym_str);
}

void ScopeNode::insert(const char symbol[], const char type[]){
	std::string sym_str(symbol);
	std::string type_str(type);
	scopeTable.insert({symbol, type});
}

std::string ScopeNode::getRoutineType(const char routine[]){
	std::string name_str(routine);
	return routines.at(name_str);
}

void ScopeNode::insertRoutine(const char routine[], const char type[]){
	std::string routine_str(routine);
	std::string type_str(type);
	routines.insert({routine, type});
}

bool ScopeNode::lookupRoutine(const char name[]){
	std::string routine_name(name);
	return routines.find(name) != routines.end();
}

std::string ScopeNode::getScopeName(){
	return scopeRoutineName;
}


SymbolTable::SymbolTable(){
	head=NULL;
}

bool SymbolTable::lookupSymbol(const char symbol[]){
	bool found = false;
	ScopeNode* curr = head;

	// searches up the scope stack for the symbol
	while(!found && curr != NULL){
		found = curr->lookup(symbol);
		curr = curr->next;
	}

	return found;
}

bool SymbolTable::lookupFunction(const char name[]){
	bool found = false;
	found = head->lookupRoutine(name);
	if(found) {
		if(strcmp(head->getRoutineType(name).c_str(), "procedure") == 0){
			yyerror("Illegal call to procedure for return type");
		}
	}
	return found;
}

bool SymbolTable::lookupSubroutine(const char name[]){
	bool found = false;
        found = head->lookupRoutine(name);
        return found;
}


std::string SymbolTable::typeOf(const char symbol[]){
	ScopeNode* curr = head;

	// Uses search method from lookupSymbol
	while(curr != NULL){
		if(curr->lookup(symbol)){
			return curr->getType(symbol);
		}
		curr = curr->next;
	}
	return NULL;
}

void SymbolTable::insertSymbol(const char symbol[], const char type[]){
	head->insert(symbol, type);
}

void SymbolTable::insertProcedure(const char name[]){
	head->insertRoutine(name, "procedure");
}

void SymbolTable::insertFunction(const char name[], const char type[]){
	head->insertRoutine(name, type);
}

char * SymbolTable::scopeName() {
	return strdup(head->getScopeName().c_str());
}

void SymbolTable::enterScope(std::string newName){
	ScopeNode* newScope = new ScopeNode(newName);
	newScope->next = head;
	head = newScope;
}

void SymbolTable::exitScope(){
	ScopeNode* old = head;
	head = head->next;

	delete old;
}
