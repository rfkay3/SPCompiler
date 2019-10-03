%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <iostream>
#include <fstream>

extern "C" int yylex();
extern "C" int yyparse();
extern FILE * yyin;

int line_no = 1;
std::ofstream outFile;

void assign (char *, char *);
void finish();
char *gen_infix(char * operandl,char *  op,char *  operand2);
void read_id (char * id_name);
void write_expr(char * id_name);
void error(const char *);
void yyerror(const char *);
%}
%union{
       int ival;
       char * sval;
       }
%token PROGRAM VAR START END READ WRITE ASSIGNOP INTEGER
%token LPAREN RPAREN COMMA PERIOD SEMICOLON COLON PLUSOP MINUSOP
%token <ival> INTLITERAL
%token <sval> ID

%left PLUSOP MINUSOP

%type <sval>ident
%type <sval>expression
%type <sval>expr
%type <sval>term
%type <sval>add_op

%start system_goal
%%


program	    :	 PROGRAM {line_no++;} variables START {line_no++;} statement_list END PERIOD {line_no++;} 
		;
variables   :	SEMICOLON {line_no++;}
		 | VAR id_list COLON INTEGER {line_no++;}
		;
statement_list  :   statement
                 | statement statement_list
		;
statement  :	ident ASSIGNOP expression {assign($1,$3);} SEMICOLON {line_no++;}
		;
statement  :	READ lparen id_list rparen SEMICOLON {line_no++;}
		;
statement  :	WRITE lparen expr_list rparen SEMICOLON {line_no++;}
		;
id_list    :	ident      {read_id($1);}
  		| id_list COMMA ident {read_id($3);}
		;
expr_list  :	expression   {write_expr($1);}
                | expr_list COMMA expression {write_expr($3);}
		;
expression :	expr   {strcpy($$,$1);}
                ;
expr       :    term {strcpy($$,$1);}
		| expr add_op term {strcpy($$,gen_infix($1,$2,$3));}
		| {error("EXPRESSION EXPECTED, BUT FOUND");}
		;
term      :	lparen expression rparen   {strcpy($$,$2);}
		;
term      :	ident      {strcpy($$,$1);}
		;
term      :	INTLITERAL     
		| {error("NUMERIC VALUE EXPECTED, BUT FOUND");}
		;
lparen    :	LPAREN
		| {error("( EXPECTED , BUT FOUND");}
		;
rparen    :	RPAREN
		| {error(") EXPECTED , BUT FOUND");}
		;
add_op    :	PLUSOP {strcpy ($$,"Add");}
		;
add_op    :	MINUSOP {strcpy ($$,"Sub");}
		;
ident     :	ID
		| {error("IDENTIFIER EXPECTED, BUT FOUND");}
		;
system_goal :	program  {finish() ;}
		;
%%
int main( int argc, char **argv )
{
	char * loc;
	if( argc != 2 )
		std::cout << "Usage: spascal inputfile\n";
	else
	{
		yyin = fopen( *++argv, "r" );
		if( yyin == NULL )
		{
			std::cout << "spascal: Couldn't open " << *argv << std::endl;
			exit( 1 );
		}

		loc = strrchr(*argv, '.');
		*loc = '\0';
		strcat(*argv, ".asm\0");
		outFile.open(*argv);
		yyparse();
		fclose( yyin );
		outFile.close();
	}
}

void error( const char * msg )
{
	std::cout << "LINE " << line_no << " : " << msg << std::endl;
	exit( -1 );
}

void yyerror(const char *s) {
  std::cout << "EEK, parse error!  Message: " << s << std::endl;
  // might as well halt now:
  exit(-1);
} 
