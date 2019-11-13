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
#include "parsedValue.h"

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
ParsedValue* gen_infix(ParsedValue* o1, char op[], ParsedValue* o2);
ParsedValue * relation_infix(ParsedValue * operand1, char * op, ParsedValue * operand2);
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
	ParsedValue * rawval;
}

%token PROGRAM VAR START END READ WRITE ASSIGNOP INTEGER REAL CHARACTER STRING BOOLEAN BOOL INTLITERAL 
%token REALLITERAL CHARLITERAL STRINGLITERAL LPAREN RPAREN COMMA PERIOD SEMICOLON COLON 
%token PLUSOP MINUSOP MULTOP DIVOP MODOP COMMENT ID GT_OP LT_OP GTEQUAL_OP LTEQUAL_OP EQUALOP NOTEQUALOP
%token ANDOP OR_OP NOTOP IF THEN ELSE

%left MULTOP DIVOP MODOP PLUSOP MINUSOP

%type <sval>ident 
%type <sval>and or not add_op mult_op relation

%type <rawval>expression expr term
%type <rawval>math_expr rel_expr boolean_and boolean_not
%type <rawval>literal
%type <rawval>if_then else_match

%start system_goal
%%


program	    :	 PROGRAM {line_no++; symTable.enterScope();} variables START {line_no++;} statement_list END PERIOD {line_no++;} 
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

statement  :	matched_statement
		|	unmatched_statement
		;

unmatched_statement :	if_then statement {/*Write a label to the assembly*/}
		|	else_match unmatched_statement {/*Write a label to the assembly*/}
		;

matched_statement  :	if_match
		|	ident ASSIGNOP expression {verify_sym_decl($1); assign($1,$3->getValue());} SEMICOLON {line_no++;}
		|	READ lparen id_list rparen SEMICOLON {line_no++;}
		|	WRITE lparen expr_list rparen SEMICOLON {line_no++;}
		|	SEMICOLON {line_no++;}
		;

id_list    :	ident      {verify_sym_decl($1); read_id($1);}
		| id_list COMMA ident {verify_sym_decl($3); read_id($3);}
		;
expr_list  :	expression   {write_expr($1->getValue());}
                | expr_list COMMA expression {write_expr($3->getValue());}
		;

if_then    : IF expression THEN {/*$$ is a conditional jump ParsedValue object on (false and the expression)*/}
		;

if_match   : else_match matched_statement {/*write label*/}
		;

else_match : if_then matched_statement ELSE {/*else_match = unconditional jump, then write label $1*/}
		;

expression :	boolean_and {$$ = $1;}
		| expression or boolean_and {/* Might want to separate from math */$$ = gen_infix($1, $2, $3);}
		;

boolean_and :	boolean_not {$$ = $1;}
		| boolean_and and boolean_not {$$ = gen_infix($1, $2, $3);}
		;

boolean_not :	rel_expr {$$ = $1;}
		| not rel_expr {/* need to negate DONT USE BOOLEAN INFIX, USE SEPARATE*/ $$ = $2;}
		;

rel_expr :		math_expr {$$ = $1;}
		| math_expr relation math_expr {$$ = relation_infix($1, $2, $3);}
		;

math_expr  :	expr   {$$ = $1;}
		| math_expr add_op expr {$$ = gen_infix($1,$2,$3);}
        ;
expr       :    term {$$ = $1;}
		| expr mult_op term {$$ = gen_infix($1,$2,$3);}
		| {error("EXPRESSION EXPECTED, BUT FOUND");}
		;
term      :	lparen expression rparen   {$$ = $2;}
		| ident      {verify_sym_decl($1); $$ = new ParsedValue($1, symTable.typeOf($1).c_str());}
		| literal	{$$ = $1;}
		;

literal   : INTLITERAL {$$ = new ParsedValue(yylval.sval, "integer");}  
		| REALLITERAL {$$ = new ParsedValue(yylval.sval, "real");} 
		| STRINGLITERAL {$$ = new ParsedValue(yylval.sval, "string");}
		| CHARLITERAL {$$ = new ParsedValue(yylval.sval, "char");}
		| BOOL {$$ = new ParsedValue(yylval.sval, "boolean");}
		| {error("NUMERIC VALUE EXPECTED, BUT FOUND");}
		;

lparen    :	LPAREN
		| {error("( EXPECTED , BUT FOUND");}
		;
rparen    :	RPAREN
		| {error(") EXPECTED , BUT FOUND");}
		;

or		  : OR_OP {$$ = strdup("or");}
		;

and		  : ANDOP {strcpy($$, "and");}
		;

not		  : NOTOP {strcpy($$, "not");}
		;

relation  :	GT_OP {$$ = strdup("gt");}
		| LT_OP	{$$ = strdup("lt");}
		| GTEQUAL_OP {$$ = strdup("gtequal");}
		| LTEQUAL_OP {$$ = strdup("ltequal");}
		| EQUALOP	{$$ = strdup("equal");}
		| NOTEQUALOP	{$$ = strdup("notequal");}
		;

add_op	  : PLUSOP    {$$ = strdup("add");}
		| MINUSOP {$$ = strdup("sub");}
		;
mult_op   : MULTOP  {$$ = strdup("mult");}
		| DIVOP   {$$ = strdup("div");}
		| MODOP   {$$ = strdup("mod");}
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
