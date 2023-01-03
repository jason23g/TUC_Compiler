%{
#include <stdio.h>
#include <string.h>
#include "cgen.h"	
#include "myanalyzer.tab.h"


int line_num = 1;

%}


ID      [a-zA-Z][0-9a-zA-Z_]*
DIGIT   [0-9]
CONST_INT [0]|([1-9]{DIGIT}*)
DECIMAL ("."{CONST_INT})|({CONST_INT}("."{CONST_INT}?)?)
CONST_FLOAT {DECIMAL}([eE][+-]?{CONST_INT})?
CONST_STRING \"[^"]*\"


%x comment

%%
	/* Rules */
int 			{ return KW_INT; }
real			{ return KW_REAL; }
string 			{ return KW_STRING; }
bool 			{ return KW_BOOL; }
true 			{ return KW_TRUE; }
false 			{ return KW_FALSE; }
var 			{ return KW_VAR; }
const 			{ return KW_CONST; }
if  			{ return KW_IF; }
else 			{ return KW_ELSE; }
for 			{ return KW_FOR; }
while 			{ return KW_WHILE; }
break 			{ return KW_BREAK; }
continue 		{ return KW_CONTINUE; }
func 			{ return KW_FUNC; }
nil 			{ return KW_NIL; }
and 			{ return KW_AND; }
or 				{ return KW_OR; }
not 			{ return KW_NOT; }
return 			{ return KW_RETURN; }
begin 			{ return KW_BEGIN; }

{ID}        	{ yylval.crepr = strdup(yytext); return TK_IDENT; }
{CONST_INT}    	{ yylval.crepr = strdup(yytext); return TK_CONST_INT; }
{CONST_FLOAT}   { yylval.crepr = strdup(yytext); return TK_CONST_FLOAT; }
{CONST_STRING}	{ yylval.crepr = strdup(yytext); return TK_CONST_STRING; }

"+"				{ return TK_OP_PLUS; }
"-"				{ return TK_OP_MINUS; }
"*"				{ return TK_OP_MULT; }
"/"				{ return TK_OP_DIV; }
"%"				{ return TK_OP_MOD; }
"**"			{ return TK_OP_POWER; }
"="				{ return TK_OP_ASSIGN; }
"=="			{ return TK_OP_EQUAL; }
"!="			{ return TK_OP_INEQUAL; }
"<"				{ return TK_OP_LESS; }
"<="			{ return TK_OP_EQUAL_OR_LESS; }
">"				{ return TK_OP_GRT; }
">="			{ return TK_OP_EQUAL_OR_GRT; }


";"				{ return TK_SEMICOLON; }
"("				{ return TK_LEFT_PARANT; }
")"				{ return TK_RIGHT_PARANT; }
","				{ return TK_COMMA; }
"["				{ return TK_LEFT_BRACKET; }
"]"				{ return TK_RIGHT_BRACKET; }
"{"				{ return TK_LEFT_CURLY_BRACKET; }
"}"				{ return TK_RIGHT_CURLY_BRACKET; }



"//"[^\n]*  		/* eat line comments */

"/*"                    { BEGIN(comment);}
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        { BEGIN(INITIAL); }

[ \r\t]			/* skip whitespace */
\n 					 ++line_num;

<<EOF>> 	return EOF;

.             { yyerror("lexical error: unrecognized literal '%s'\n", yytext); }
%%
