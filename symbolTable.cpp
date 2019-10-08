#include "symbolTable.h"

ScopeNode::ScopeNode(){
	next = NULL;
}

bool ScopeNode::lookup(const char* symbol){
	std::string sym_str(symbol);
	return scopeTable.count(sym_str) > 0;
}

void ScopeNode::insert(const char* symbol, const char* type){
	std::string sym_str(symbol);
	std::string type_str(type);
	std::cout << "inserting " << sym_str << "into scope" << std::endl;
	scopeTable.insert({symbol, type});
}


SymbolTable::SymbolTable(){
	head=NULL;
}

bool SymbolTable::lookupSymbol(const char* symbol){
	std::cout << "looking up " << symbol << std::endl;
	bool found = false;
	ScopeNode* curr = head;

	// searches up the scope stack for the symbol
	while(!found && curr != NULL){
		found = curr->lookup(symbol);
		curr = curr->next;
	}

	return found;
}

void SymbolTable::insertSymbol(const char* symbol, const char* type){
	head->insert(symbol, type);
}

void SymbolTable::enterScope(){
	ScopeNode* newScope = new ScopeNode();

	newScope->next = head;

	head = newScope;

}

void SymbolTable::exitScope(){
	//set head to next node
	head = head->next;

}
