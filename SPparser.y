%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <stack>
#include "symbolTable.h"
#include "parsedValue.h"

extern "C" int yylex();
extern "C" int yyparse();
extern FILE * yyin;

int line_no = 1;
std::ofstream outFile;
SymbolTable symTable;
char * var_type;
std::stack<std::stringstream*> writeBuffer;
std::deque<std::stringstream*> outFileBuffer;
std::stringstream * curr_buffer = new std::stringstream();

bool isReal(char value[]);
const char * createTempIntegerAddress();
const char * createTempRealAddress();
const char * createTempCharacterAddress();
const char * createTempStringAddress();
const char * createTempLabel();
void assign (char [], ParsedValue *);
void decl_id ( char [], const char [] );
void finish();
ParsedValue * gen_infix(ParsedValue* o1, char op[], ParsedValue* o2);
ParsedValue * relation_infix(ParsedValue * operand1, char * op, ParsedValue * operand2);
ParsedValue * boolean_infix(ParsedValue * operand1, char * op, ParsedValue * operand2);
ParsedValue * boolean_not(char * op, ParsedValue * operand1);
void read_id (char []);
void write_expr(char []);
void write_label(const char * label);
void verify_sym_decl(char []);
void error(const char []);
void yyerror(const char []);
void printSymbolTable();
void decl_function(const char name[]);
void verify_subroutine(const char name[]);
void verify_function(const char name[]);
char * call_func(const char name[]);
void enterRoutine();
void exitRoutine();
ParsedValue * conditionalJump(const char * jump_if, ParsedValue * cond, char * label);
ParsedValue * jump (char * label);
%}


%union{
	int ival;
	char * sval;
	ParsedValue * rawval;
}

%token PROGRAM VAR START END READ WRITE ASSIGNOP INTEGER REAL CHARACTER STRING BOOLEAN BOOL INTLITERAL 
%token REALLITERAL CHARLITERAL STRINGLITERAL LPAREN RPAREN LBRACKET RBRACKET COMMA PERIOD SEMICOLON COLON 
%token PLUSOP MINUSOP MULTOP DIVOP MODOP COMMENT ID GT_OP LT_OP GTEQUAL_OP LTEQUAL_OP EQUALOP NOTEQUALOP
%token ANDOP OR_OP NOTOP IF THEN ELSE WHILE DO REPEAT UNTIL PROCEDURE FUNCTION

%left MULTOP DIVOP MODOP PLUSOP MINUSOP

%type <sval>ident while repeat type procedure_decl
%type <sval>and or not add_op mult_op relation

%type <rawval>literal
%type <rawval>expression expr term
%type <rawval>math_expr rel_expr boolean_and boolean_not
%type <rawval>do_expr
%type <rawval>if_then else_match

%start system_goal
%%


program	    :	 PROGRAM {line_no++; symTable.enterScope("program");} variables START {line_no++;} statement_list END PERIOD {line_no++;} 
		;
variables   :	SEMICOLON {line_no++;}
		 | VAR {line_no++;} d_list
		;
d_list      :   d_list declaration 
		| declaration
		;

declaration :	type var_list SEMICOLON {line_no++;}
	    	| procedure_decl variables START statement_list procedure_end
		| function_decl variables START statement_list function_end
	    	;
procedure_decl:	PROCEDURE ident SEMICOLON {symTable.insertProcedure($2); symTable.enterScope($2); enterRoutine(); *curr_buffer << ":#" << $2 << std::endl; line_no++;}
	      ;

procedure_end:	END SEMICOLON {symTable.exitScope(); exitRoutine();}
	     ;

function_decl:	FUNCTION ident COLON type SEMICOLON {decl_function($2); enterRoutine(); *curr_buffer << ":#" << $2 << std::endl; *curr_buffer << "declare " << "&#" << $2 << ", " << strdup(var_type) << std::endl; line_no++;}
	     ;

function_end :	END SEMICOLON {*curr_buffer << "return " << "&#" << symTable.scopeName() << std::endl; symTable.exitScope(); exitRoutine();}
	     ;

type    :       INTEGER {var_type = strdup( "integer");}
                | REAL {var_type = strdup( "real");}
                | CHARACTER {var_type = strdup( "character");}
                | STRING {var_type = strdup( "string");}
                | BOOLEAN {var_type = strdup( "boolean");}
                ;

var_list    :	ident {decl_id($1, strdup(var_type)); symTable.insertSymbol($1, strdup(var_type));}
	    	| ident ASSIGNOP literal {decl_id($1, strdup(var_type)); symTable.insertSymbol($1, strdup(var_type)); assign($1, $3);}
		| var_list COMMA ident {decl_id($3, strdup(var_type)); symTable.insertSymbol($3, strdup(var_type));}
		| var_list COMMA ident ASSIGNOP literal {decl_id($3, strdup(var_type)); symTable.insertSymbol($3, strdup(var_type)); assign($3, $5);}
		;

statement_list  :   statement
                 | statement_list statement
		;

statement  :	matched_statement
		|	unmatched_statement
		;

unmatched_statement :	if_then statement {write_label($1->getValue());}
		|	else_match unmatched_statement {write_label($1->getValue());}
		;

matched_statement  :	if_match
		|	ident ASSIGNOP expression {verify_sym_decl($1); assign($1,$3);} SEMICOLON {line_no++;}
		|	READ lparen id_list rparen SEMICOLON {line_no++;}
		|	WRITE lparen expr_list rparen SEMICOLON {line_no++;}
		|	START statement_list END
		|	while_loop
		|	repeat_until
		|	ident LPAREN RPAREN {verify_subroutine($1);}
		|	SEMICOLON {line_no++;}
		;

while_loop :	while do_expr matched_statement {jump($1); write_label($2->getValue());}
		;

while	   :	WHILE {char * temp = strdup(createTempLabel()); write_label(temp); $$ = temp;}
		;

do_expr	   :	expression DO {$$ = conditionalJump("false", $1, strdup(createTempLabel())); line_no++;}
		;

repeat_until :	repeat matched_statement UNTIL expression {conditionalJump("true", $4, $1);}
		;

repeat	   :	REPEAT {char * temp = strdup(createTempLabel()); write_label(temp); $$ = temp;}

id_list    :	ident      {verify_sym_decl($1); read_id($1);}
		| id_list COMMA ident {verify_sym_decl($3); read_id($3);}
		;
expr_list  :	expression   {write_expr($1->getValue());}
                | expr_list COMMA expression {write_expr($3->getValue());}
		;

if_then    : 	IF expression THEN {$$ = conditionalJump("false", $2, strdup(createTempLabel()));}
		;

if_match   : 	else_match matched_statement {write_label($1->getValue());}
		;

else_match : 	if_then matched_statement ELSE {$$ = jump(strdup(createTempLabel())); write_label($1->getValue());}
		;

expression :	boolean_and {$$ = $1;}
		| expression or boolean_and {$$ = boolean_infix($1, $2, $3);}
		;

boolean_and :	boolean_not {$$ = $1;}
		| boolean_and and boolean_not {$$ = boolean_infix($1, $2, $3);}
		;

boolean_not :	rel_expr {$$ = $1;}
		| not rel_expr {$$ = boolean_not($1, $2);}
		;

rel_expr :	math_expr {$$ = $1;}
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
		| ident     {$$ = new ParsedValue($1, symTable.typeOf($1).c_str());}
		| ident LPAREN RPAREN {verify_function($1); $$ = new ParsedValue(call_func($1), symTable.typeOfRoutine($1).c_str());}
		| literal	{$$ = $1;}
		;

literal   : 	INTLITERAL {$$ = new ParsedValue(yylval.sval, "integer");}  
		| REALLITERAL {$$ = new ParsedValue(yylval.sval, "real");} 
		| STRINGLITERAL {$$ = new ParsedValue(yylval.sval, "string");}
		| CHARLITERAL {$$ = new ParsedValue(yylval.sval, "character");}
		| BOOL {$$ = new ParsedValue(yylval.sval, "integer");}
		| {error("LITERAL EXPECTED, BUT FOUND");}
		;


lparen	:	LPAREN
		| {error("( EXPECTED , BUT FOUND");}
		;
rparen	:	RPAREN
		| {error(") EXPECTED , BUT FOUND");}
		;

or	: 	OR_OP {$$ = strdup("or");}
		;

and	:	ANDOP {$$ = strdup("and");}
		;

not	:	NOTOP {$$ = strdup("not");}
		;

relation:	GT_OP {$$ = strdup("gt");}
		| LT_OP	{$$ = strdup("lt");}
		| GTEQUAL_OP {$$ = strdup("gtequal");}
		| LTEQUAL_OP {$$ = strdup("ltequal");}
		| EQUALOP	{$$ = strdup("equal");}
		| NOTEQUALOP	{$$ = strdup("notequal");}
		;

add_op	: 	PLUSOP    {$$ = strdup("add");}
		| MINUSOP {$$ = strdup("sub");}
		;
mult_op	: 	MULTOP  {$$ = strdup("mult");}
		| DIVOP   {$$ = strdup("div");}
		| MODOP   {$$ = strdup("mod");}
		;
ident	:	ID {$$ = strdup(yylval.sval);}
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

void decl_function(const char name[]){
	symTable.insertFunction(name, strdup(var_type)); 
	symTable.enterScope(name); 
	symTable.insertSymbol(name, strdup(var_type));
}

void verify_subroutine(const char name[]){
	if(!symTable.lookupSubroutine(name)){
		yyerror("Subroutine not declared in this scope");
	}
}

void verify_function(const char name[]){
	if(!symTable.lookupFunction(name)){
		yyerror("Subroutine not declared in this scope");
	}
}

void enterRoutine(){
	writeBuffer.push(curr_buffer);
	curr_buffer = new std::stringstream();
}

void exitRoutine(){
	outFileBuffer.push_front(curr_buffer);
	curr_buffer = writeBuffer.top();
	writeBuffer.pop();
}

char * call_func(const char name[]){
	std::string type = symTable.typeOfRoutine(name);
	if(type == "character"){
		char * tempLabel = strdup(createTempCharacterAddress());
		*curr_buffer << "call " << ":#" << name << std::endl;
		*curr_buffer << "store " << "&#" << name << ", " << tempLabel << std::endl;
		return tempLabel;
	} else if(type == "string"){
		char * tempLabel = strdup(createTempStringAddress());
		*curr_buffer << "call " << ":#" << name << std::endl;
                *curr_buffer << "store " << "&#" << name << ", " << tempLabel << std::endl;
		return tempLabel;
	} else if(type == "boolean"){
		char * tempLabel = strdup(createTempIntegerAddress());
		*curr_buffer << "call " << ":#" << name << std::endl;
                *curr_buffer << "store " << "&#" << name << ", " << tempLabel << std::endl;
		return tempLabel;
	} else if(type == "integer"){
		char * tempLabel = strdup(createTempIntegerAddress());
		*curr_buffer << "call " << ":#" << name << std::endl;
                *curr_buffer << "store " << "&#" << name << ", " << tempLabel << std::endl;
		return tempLabel;
	} else if(type == "real"){
		char * tempLabel = strdup(createTempRealAddress());
		*curr_buffer << "call " << ":#" << name << std::endl;
                *curr_buffer << "store " << "&#" << name << ", " << tempLabel << std::endl;
		return tempLabel;
	} else {	
		yyerror("Unrecognized function return type.");
	}

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
