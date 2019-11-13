%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include "symbolTable.h"

extern "C" int yylex();
extern "C" int yyparse();
extern FILE * yyin;

int line_no = 1;
std::ofstream outFile;
SymbolTable symTable;

bool isReal(char value[]);
char * createTempIntegerAddress();
char * createTempRealAddress();
void assign (char [], char []);
void decl_id ( char [], const char [] );
void finish();
char * gen_infix(char [], char [], char []);
void read_id (char []);
void write_expr(char []);
void verify_sym_decl(char []);
void error(const char []);
void yyerror(const char []);
void printSymbolTable();

%}
%union{
       int ival;
       char * sval;
       float fval;
       }

%token PROGRAM VAR START END READ WRITE ASSIGNOP INTEGER REAL CHARACTER STRING BOOLEAN BOOL INTLITERAL 
%token REALLITERAL CHARLITERAL STRINGLITERAL LPAREN RPAREN COMMA PERIOD SEMICOLON COLON 
%token PLUSOP MINUSOP MULTOP DIVOP MODOP COMMENT ID GT_OP LT_OP GTEQUAL_OP LTEQUAL_OP EQUALOP NOTEQUALOP
%token IF THEN ELSE
%token ANDOP OR_OP NOTOP

%left MULTOP DIVOP MODOP PLUSOP MINUSOP

%type <sval>ident
%type <sval>expression
%type <sval>expr
%type <sval>term
%type <sval>add_op
%type <sval>mult_op

%start system_goal
%%


program	    :	 PROGRAM {line_no++; symTable.enterScope();} variables START {line_no++;} statement_list END PERIOD {line_no++;} 
		| COLON {
				// Use this section as a sendbox for testing any external functions
				// To sun this section use use the following commands:
				// $ echo : >> test.pas
				// $ ./pascal test.pas

				symTable.enterScope();
				std::string sym("symbol1");
				std::string type("type");
				symTable.insertSymbol(sym.c_str(), type.c_str());
				if(symTable.lookupSymbol(sym.c_str())){
					std::cout << "FOUND '" << sym << "'!" << std::endl;
				}else{
					std::cout << "Did not find '" << sym << "'" << std::endl;
				}

				std::cout << std::endl << std::endl;
				
				std::string notsym("notsym");

				if(symTable.lookupSymbol(notsym.c_str())){
				        std::cout << "FOUND '" << notsym << "'!" << std::endl;
				}else{
				        std::cout << "Did not find '" << notsym << "'" << std::endl;
				}

				std::cout << std::endl << "Entering sub scope" << std::endl << std::endl;
				           
				symTable.enterScope();

				std::string sym2("symbol2");

				symTable.insertSymbol(sym2.c_str(), type.c_str());

				if(symTable.lookupSymbol(sym2.c_str())){
					std::cout << "FOUND '" << sym2 << "'!" << std::endl;
				}else{
				        std::cout << "Did not find '" << sym2 << "'" << std::endl;
				}

				if(symTable.lookupSymbol(sym.c_str())){
				        std::cout << "FOUND '" << sym << "'!" << std::endl;
				}else{
					std::cout << "Did not find '" << sym << "'" << std::endl;
				}

				std::cout << std::endl << "Exiting sub scope" << std::endl << std::endl;
				symTable.exitScope();

				if(symTable.lookupSymbol(sym2.c_str())){
					std::cout << "FOUND '" << sym2 << "'!" << std::endl;
				}else{
					std::cout << "Did not find '" << sym2 << "'" << std::endl;
				}

				if(symTable.lookupSymbol(sym.c_str())){
					std::cout << "FOUND '" << sym << "'!" << std::endl;
				}else{
					std::cout << "Did not find '" << sym << "'" << std::endl;
				}				
			} 
		;
variables   :	SEMICOLON {line_no++;}
		 | VAR {line_no++;} d_list
		;
d_list      :   d_list declaration 
		| declaration
		;
declaration :	INTEGER int_var_list SEMICOLON {line_no++;} 
		| REAL real_var_list SEMICOLON {line_no++;}
		| CHARACTER char_var_list SEMICOLON {line_no++;}
		| STRING string_var_list SEMICOLON {line_no++;}
		| BOOLEAN bool_var_list SEMICOLON {line_no++;}
		;
bool_var_list:   ident  { decl_id($1, "boolean"); symTable.insertSymbol($1, "boolean");}
		| ident {decl_id($1, "boolean"); symTable.insertSymbol($1, "boolean");} ASSIGNOP BOOL {assign($1, yylval.sval);}             
		| bool_var_list COMMA ident { decl_id($3, "boolean"); symTable.insertSymbol($3, "boolean");}
		| bool_var_list COMMA ident { decl_id($3, "boolean"); symTable.insertSymbol($3, "boolean");} ASSIGNOP BOOL {assign($3, yylval.sval);}
		;
int_var_list:   ident  { decl_id($1, "integer"); symTable.insertSymbol($1, "integer");}
		| ident {decl_id($1, "integer"); symTable.insertSymbol($1, "integer");} ASSIGNOP INTLITERAL {assign($1, yylval.sval);}             
		| int_var_list COMMA ident { decl_id($3, "integer"); symTable.insertSymbol($3, "integer");}
		| int_var_list COMMA ident { decl_id($3, "integer"); symTable.insertSymbol($3, "integer");} ASSIGNOP INTLITERAL {assign($3, yylval.sval);}
		;
real_var_list:	ident {decl_id($1, "real"); symTable.insertSymbol($1, "real");}
		| ident {decl_id($1, "real"); symTable.insertSymbol($1, "real");} ASSIGNOP REALLITERAL {assign($1, yylval.sval);}
		| real_var_list COMMA ident {decl_id($3, "real"); symTable.insertSymbol($3, "real");}
		| real_var_list COMMA ident {decl_id($3, "real"); symTable.insertSymbol($3, "real");} ASSIGNOP REALLITERAL {assign($3, yylval.sval);}
		;
char_var_list:	ident {decl_id($1, "character"); symTable.insertSymbol($1, "character");}
		| ident {decl_id($1, "character"); symTable.insertSymbol($1, "character");} ASSIGNOP CHARLITERAL {assign($1, yylval.sval);}
		| char_var_list COMMA ident {decl_id($3, "character"); symTable.insertSymbol($3, "character");}
		| char_var_list COMMA ident {decl_id($3, "character"); symTable.insertSymbol($3, "character");} ASSIGNOP CHARLITERAL {assign($3, yylval.sval);}
		;
string_var_list: ident {decl_id($1, "string"); symTable.insertSymbol($1, "string");}
		| ident {decl_id($1, "string"); symTable.insertSymbol($1, "string");} ASSIGNOP STRINGLITERAL {assign($1, yylval.sval);}
		| string_var_list COMMA ident {decl_id($3, "string"); symTable.insertSymbol($3, "string");}
		| string_var_list COMMA ident {decl_id($3, "string"); symTable.insertSymbol($3, "string");} ASSIGNOP STRINGLITERAL {assign($3, yylval.sval);}
		;
statement_list  :   statement
                 | statement_list statement
		;
statement  :	ident ASSIGNOP expression {verify_sym_decl($1); assign($1,$3);} SEMICOLON {line_no++;}
		;
statement  :	READ lparen id_list rparen SEMICOLON {line_no++;}
		;
statement  :	WRITE lparen expr_list rparen SEMICOLON {line_no++;}
		;
statement	:	IF statement_list THEN {line_no++;} BLOCK {block_no++}
		| IF statement_list THEN {line_no++;} ELSE {line_no++;}
		;
statement  :    SEMICOLON {line_no++;}
		;
id_list    :	ident      {verify_sym_decl($1); read_id($1);}
		| id_list COMMA ident {verify_sym_decl($3); read_id($3);}
		;
expr_list  :	expression   {write_expr($1);}
                | expr_list COMMA expression {write_expr($3);}
		;
expression :	expr   {strcpy($$,$1);}
		| expression add_op expr {strcpy($$,gen_infix($1,$2,$3));}
        ;
expr       :    term {$$ = strdup($1);}
		| expr mult_op term {strcpy($$,gen_infix($1,$2,$3));}
		| {error("EXPRESSION EXPECTED, BUT FOUND");}
		;
term      :	lparen expression rparen   {$$ = strdup($2);}
		| ident      {verify_sym_decl($1); strcpy($$,$1);}
		| INTLITERAL {strcpy($$, yylval.sval);}  
		| REALLITERAL {strcpy($$, yylval.sval);} 
		| {error("NUMERIC VALUE EXPECTED, BUT FOUND");}
		;
lparen    :	LPAREN
		| {error("( EXPECTED , BUT FOUND");}
		;
rparen    :	RPAREN
		| {error(") EXPECTED , BUT FOUND");}
		;
add_op	  : PLUSOP    {strcpy($$, "add");}
		| MINUSOP {strcpy($$, "sub");}
		;
mult_op   : MULTOP  {strcpy($$, "mult");}
		| DIVOP   {strcpy($$, "div");}
		| MODOP   {strcpy($$, "mod");}
		;
ident     :	ID {strcpy($$, yylval.sval);}
		| {error("IDENTIFIER EXPECTED, BUT FOUND");}
		;
system_goal :	program  { finish(); }
		;
%%
int main( int argc, char **argv )
{
	char * loc;
	if( argc != 2 )
		std::cout << "Usage: pascal inputfile\n";
	else
	{
		std::string srcFilePath = argv[1]; // assume you are not mucking with pointers
		yyin = fopen( *++argv, "r" );
		if( yyin == NULL )
		{
			std::cout << "spascal: Couldn't open " << *argv << std::endl;
			exit( 1 );
		}
		
		std::string fileName = srcFilePath.substr(0, srcFilePath.rfind('.'));
		std::string asmFileName = fileName + ".asm";

		outFile.open(asmFileName);
		yyparse();
		fclose( yyin );
		outFile.close();
	}
}

void printSymbolTable(){
	ScopeNode* curr = symTable.head;
	std::cout << "printing table" << std::endl;
	while(curr!=NULL){
		for(auto const& pair : curr->scopeTable){
			std::cout << "{" << pair.first << ", " << pair.second << "}" << std::endl;
		}

		curr = curr->next;
	}
}

void verify_sym_decl(char symbol[]){
	if(!symTable.lookupSymbol(symbol)){
		std::stringstream ss;
		ss << "Symbol " << symbol << " not declared in this scope";
		std::string msg = ss.str();
		error(msg.c_str());
	}
	//Don't need to do anything if the symbol is found
}

void error( const char msg[] )
{
	std::cout << "ERROR : LINE " << line_no << " : " << msg << std::endl;
	exit( -1 );
}

void yyerror(const char s[]) {
  std::cout << "Parse error during compilation at line " << std::to_string(line_no) <<". Error Message: " << s << std::endl;
  // might as well halt now:
  exit(-1);
} 
