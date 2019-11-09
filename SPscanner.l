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
lbracket	[{]
rbracket	[}]
fslash		[/]
comma           [,]
period		[\.]
assignop        [:][=]
plusop		[+]
minusop  	[-]
multop		[\*]
divop		[\\]
modop		[%]
comment  	({fslash}{fslash}.*)
boolean     ([Tt][Rr][Uu][Ee]|[Ff][Aa][Ll][Ss][Ee])
intliteral      (0|([1-9]{digit}*))
realliteral	({intliteral}{period}(0|{digit}*[1-9]))
charliteral	('.')
stringliteral	(\"(\\.|[^"\\])*\")
id              ({letter}|{underscore})({letter}|{digit}|{underscore})*
%x		MULTILINE
%%

[ \t]+                                          {/* do nothing */}
[\n]                                            {/* new line */}
[Pp][Rr][Oo][Gg][Rr][Aa][Mm]			{return PROGRAM;}
[Vv][Aa][Rr]					{return VAR;}
[Ii][Nn][Tt][Ee][Gg][Ee][Rr]			{return INTEGER;}
[Rr][Ee][Aa][Ll]                                {return REAL;}
[Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]		{return CHARACTER;}
[Ss][Tt][Rr][Ii][Nn][Gg]			{return STRING;}
[Bb][Ee][Gg][Ii][Nn]                            {return START;}
[Ee][Nn][Dd]                                    {return END;}
[Rr][Ee][Aa][Dd]                                {return READ;}
[Ww][Rr][Ii][Tt][Ee]                            {return WRITE;}
[Bb][Oo][Oo][Ll][Ee][Aa][Nn]                    {return BOOLEAN;}
{comma}                                         {return COMMA;}
{period}					{return PERIOD;}
{semicolon}                                     {return SEMICOLON;}
{colon}						{return COLON;}
{lparen}                                        {return LPAREN;}
{rparen}                                        {return RPAREN;}
{assignop}                                      {return ASSIGNOP;}
{plusop}                                        {return PLUSOP;}
{minusop}                                       {return MINUSOP;}
{multop}					{return MULTOP;}
{divop}						{return DIVOP;}
{modop}						{return MODOP;}
{comment}                                       {/* do nothing */}
{boolean}                                       {yylval.sval = strdup(yytext); return BOOL;}
{intliteral}                                    {yylval.sval = strdup(yytext); return INTLITERAL;}
{realliteral}					{yylval.sval = strdup(yytext); return REALLITERAL;}
{charliteral}					{yylval.sval = strdup(yytext); return CHARLITERAL;}
{stringliteral}					{yylval.sval = strdup(yytext); return STRINGLITERAL;}
{id}                                            {yylval.sval = strdup(yytext); return ID;}
{if}                        {return IF;}        
{then}                      {return THEN;}
{else}                      {return ELSE;}

{lbracket}					{BEGIN(MULTILINE);}
<MULTILINE>{rbracket}				{BEGIN(INITIAL);}
<MULTILINE>(.|\n)				;
<MULTILINE><<EOF>>				{return *yytext;}
[^,]		{std::cout << "SYNTAX ERROR: " << yytext << " IS ILLEGAL" << std::endl;}
%%

