%{
#include <iostream>
#include <stdlib.h>
#include "pascal.tab.h"
extern "C" int yylex();
%}
letter  [a-zA-Z]
digit   [0-9]
semicolon	[;]
colon		[:]
underscore	[_]
lparen		[(]
rparen		[)]
comma           [,]
period		[\.]
assignop        [:][=]
plusop		[+]
minusop  	[-]
intliteral      (0|([1-9]{digit}*))
realliteral	({intliteral}{period}(0|{digit}*[1-9]))
id              ({letter}|{underscore})({letter}|{digit}|{underscore})*
%%

[ \t]+                                          {/* do nothing */}
[\n]                                            {/* new line*/}
[Pp][Rr][Oo][Gg][Rr][Aa][Mm]			{return PROGRAM;}
[Vv][Aa][Rr]					{return VAR;}
[Ii][Nn][Tt][Ee][Gg][Ee][Rr]			{return INTEGER;}
[Rr][Ee][Aa][Ll]                                {return REAL;}
[Bb][Ee][Gg][Ii][Nn]                            {return START;}
[Ee][Nn][Dd]                                    {return END;}
[Rr][Ee][Aa][Dd]                                {return READ;}
[Ww][Rr][Ii][Tt][Ee]                            {return WRITE;}
{comma}                                         {return COMMA;}
{period}					{return PERIOD;}
{semicolon}                                     {return SEMICOLON;}
{colon}						{return COLON;}
{lparen}                                        {return LPAREN;}
{rparen}                                        {return RPAREN;}
{assignop}                                      {return ASSIGNOP;}
{plusop}                                        {return PLUSOP;}
{minusop}                                       {return MINUSOP;}
{intliteral}                                    {yylval.sval = strdup(yytext); return INTLITERAL;}
{realliteral}					{yylval.sval = strdup(yytext); return REALLITERAL;}
{id}                                            {yylval.sval = strdup(yytext); return ID;}

[^,]		{std::cout << "SYNTAX ERROR: " << yytext << " IS ILLEGAL" << std::endl;}
%%

