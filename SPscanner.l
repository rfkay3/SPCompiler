%{
#include <iostream>
#include <stdlib.h>
#include "parsedValue.h"
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
lbrace  	[{]
rbrace	    [}]
lbracket    [\]]
rbracket    [\[]
fslash		[/]
comma           [,]
period		[\.]
assignop        [:][=]
plusop		[+]
minusop  	[-]
multop		[\*]
divop		[/]
modop		[%]
gt          [>]
lt          [<]
gtequal     ([>][=])
ltequal     ([<][=])
equal       [=]
notequal    ([<][>])
bool_and    ([Aa][Nn][Dd])
bool_or     ([Oo][Rr])
bool_not    ([Nn][Oo][Tt])
comment  	({fslash}{fslash}.*)
boolean     (true|false)
intliteral      (0|([1-9]{digit}*))
realliteral	({intliteral}{period}(0|{digit}*[1-9]))
charliteral	('.')
stringliteral	(\"(\\.|[^"\\])*\")
id              ({letter}|{underscore})({letter}|{digit}|{underscore})*
functionliteral ([a-zA-Z]+2[:])
procedureliteral ([a-zA-Z]+[;])
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
[Ii][Ff]                                        {return IF;}
[Tt][Hh][Ee][Nn]                                {return THEN;}
[Ee][Ll][Ss][Ee]                                {return ELSE;}
[Ww][Hh][Ii][Ll][Ee]                            {return WHILE;}
[Dd][Oo]                                        {return DO;}
[Rr][Ee][Pp][Ee][Aa][Tt]                        {return REPEAT;}
[Uu][Nn][Tt][Ii][Ll]                            {return UNTIL;}
[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]		{return PROCEDURE;}
[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]		{return FUNCTION;}
{comma}                                         {return COMMA;}
{period}					{return PERIOD;}
{semicolon}                                     {return SEMICOLON;}
{colon}						{return COLON;}
{lparen}                                        {return LPAREN;}
{rparen}                                        {return RPAREN;}
{lbracket}                                      {return LBRACKET;}
{rbracket}                                      {return RBRACKET;}
{assignop}                                      {return ASSIGNOP;}
{plusop}                                        {return PLUSOP;}
{minusop}                                       {return MINUSOP;}
{multop}					{return MULTOP;}
{divop}						{return DIVOP;}
{modop}						{return MODOP;}
{gt}                        {return GT_OP;}
{lt}                        {return LT_OP;}
{gtequal}                   {return GTEQUAL_OP;}
{ltequal}                   {return LTEQUAL_OP;}
{equal}                     {return EQUALOP;}
{notequal}                  {return NOTEQUALOP;}
{bool_and}                  {return ANDOP;}
{bool_or}                   {return OR_OP;}
{bool_not}                  {return NOTOP;}
{comment}                                       {/* do nothing */}
{boolean}                                       {yylval.sval = strdup(yytext); return BOOL;}
{intliteral}                                    {yylval.sval = strdup(yytext); return INTLITERAL;}
{realliteral}					{yylval.sval = strdup(yytext); return REALLITERAL;}
{charliteral}					{yylval.sval = strdup(yytext); return CHARLITERAL;}
{stringliteral}					{yylval.sval = strdup(yytext); return STRINGLITERAL;}
{procedureliteral}				{yylval.sval = strdup(yytext); return PROCEDURELITERAL;}
{functionliteral}				{yylval.sval = strdup(yytext); return FUNCTIONLITERAL;}
{id}                                            {yylval.sval = strdup(yytext); return ID;}

{lbrace}					{BEGIN(MULTILINE);}
<MULTILINE>{rbrace}				{BEGIN(INITIAL);}
<MULTILINE>(.|\n)				;
<MULTILINE><<EOF>>				{return *yytext;}
[^,]		{std::cout << "SYNTAX ERROR: " << yytext << " IS ILLEGAL" << std::endl;}
%%

