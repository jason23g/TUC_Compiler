%{
#include <stdio.h>
#include <string.h>	
#include "cgen.h"

extern int yylex(void);
extern int line_num;
%}

%union
{
	char* crepr;

}

%token <crepr> TK_IDENT
%token <crepr> TK_CONST_INT
%token <crepr> TK_CONST_FLOAT
%token <crepr> TK_CONST_STRING	

%token TK_OP_PLUS
%token TK_OP_MINUS
%token TK_OP_MULT
%token TK_OP_DIV
%token TK_OP_MOD
%token TK_OP_POWER	
%token TK_OP_ASSIGN
%token TK_OP_EQUAL
%token TK_OP_INEQUAL
%token TK_OP_GRT
%token TK_OP_LESS
%token TK_OP_EQUAL_OR_GRT
%token TK_OP_EQUAL_OR_LESS
%token KW_INT
%token KW_REAL
%token KW_STRING
%token KW_BOOL
%token KW_TRUE
%token KW_FALSE
%token KW_VAR
%token KW_CONST
%token KW_IF
%token KW_ELSE
%token KW_FOR
%token KW_WHILE
%token KW_BREAK
%token KW_CONTINUE
%token KW_FUNC
%token KW_NIL
%token KW_AND
%token KW_OR
%token KW_NOT
%token KW_RETURN
%token KW_BEGIN
%token TK_SEMICOLON
%token TK_LEFT_PARANT
%token TK_RIGHT_PARANT
%token TK_COMMA
%token TK_LEFT_BRACKET
%token TK_RIGHT_BRACKET
%token TK_LEFT_CURLY_BRACKET
%token TK_RIGHT_CURLY_BRACKET

%start program

%type <crepr> function_list function function_begin function_body function_agruments_list function_multiple_agrument 
%type <crepr> function_single_agrument function_parameters_list function_type decl_list decl   

%type <crepr> data_type data const_declaration var_declaration 
%type <crepr> assign_value_var_declaration assign_single_value_var_declaration assign_multiple_value_var_declaration
%type <crepr> assign_value_const_declaration assign_single_value_const_declaration assign_multiple_value_const_declaration 
%type <crepr> bool_value  var_array_value
%type <crepr> statements_list simple_statements_list statement complex_statement simple_statement assign_stmt break_stmt 
%type <crepr> continue_stmt return_stmt if_stmt while_stmt for_stmt function_call_stmt
%type <crepr> expr  expr_data


%left KW_AND KW_OR
%left TK_OP_LESS TK_OP_GRT TK_OP_EQUAL_OR_LESS TK_OP_EQUAL_OR_GRT TK_OP_INEQUAL TK_OP_EQUAL
%left TK_OP_MINUS TK_OP_PLUS 
%left TK_OP_MULT TK_OP_DIV TK_OP_MOD
%right TK_OP_POWER
%left UMINUS
%right KW_NOT
%nonassoc TK_LEFT_PARANT TK_RIGHT_PARANT


%precedence KW_IF
%precedence KW_ELSE


%%

program: decl_list function_list function_begin{

 /* We have a successful parse! 
    Check for any errors and generate output. 
  */
  
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue);
    puts("#include <math.h> "); 
    printf("/* program */ \n\n");
    printf("%s\n\n", $1);
    printf("\n%s\n %s\n", $2,$3);
  }
  
}
| decl_list  function_begin {

 /* We have a successful parse! 
    Check for any errors and generate output. 
  */
  
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue); 
    puts("#include <math.h> ");
    printf("/* program */ \n\n");
    printf("%s\n\n", $1);
    printf("\n%s\n", $2);
  }
  
}
| function_list  function_begin {

 /* We have a successful parse! 
    Check for any errors and generate output. 
  */
  
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue);
    puts("#include <math.h> "); 
    printf("/* program */ \n\n");
    printf("%s\n\n", $1);
    printf("\n%s\n \n", $2);
  }
  
}
|function_begin {

 /* We have a successful parse! 
    Check for any errors and generate output. 
  */
  
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue);
    puts("#include <math.h> "); 
    printf("/* program */ \n\n");
    printf("%s\n\n", $1);
  }
  
}
;


function_list:
 function_list function { $$ = template("%s\n%s\n", $1, $2); }  
| function  {  $$ = template("%s \n", $1);  }
;

function_begin:
 KW_FUNC KW_BEGIN TK_LEFT_PARANT TK_RIGHT_PARANT TK_LEFT_CURLY_BRACKET function_body TK_RIGHT_CURLY_BRACKET TK_SEMICOLON{$$ = template("int main () {\n%s\n}", $6); }
;

function:
KW_FUNC TK_IDENT TK_LEFT_PARANT function_agruments_list TK_RIGHT_PARANT function_type TK_LEFT_CURLY_BRACKET function_body TK_RIGHT_CURLY_BRACKET TK_SEMICOLON  { $$ = template("%s %s (%s)  {\n %s \n}",$6, $2, $4,$8); }
| KW_FUNC TK_IDENT TK_LEFT_PARANT TK_RIGHT_PARANT function_type TK_LEFT_CURLY_BRACKET function_body TK_RIGHT_CURLY_BRACKET TK_SEMICOLON  { $$ = template("%s %s ()  {\n %s \n}",$5, $2,$7); }
;


function_agruments_list:
 function_agruments_list function_multiple_agrument { $$ = template("%s %s", $1, $2); }
| function_single_agrument {  $$ = template("%s", $1);  }

function_single_agrument:
 TK_IDENT data_type  { $$ = template("%s %s", $2,$1); }
| TK_IDENT TK_LEFT_BRACKET TK_RIGHT_BRACKET data_type  { $$ = template("%s *%s", $4,$1); }
;

function_multiple_agrument:
 TK_COMMA TK_IDENT data_type { $$ = template(", %s %s", $3,$2); }
| TK_COMMA TK_IDENT TK_LEFT_BRACKET TK_RIGHT_BRACKET data_type  { $$ = template(",%s *%s", $5,$2); }
;


function_body: 
decl_list  statements_list { $$ = template("%s %s \n ",$1,$2); }
| statements_list { $$ = template("%s \n ",$1); }
;

function_type:
 %empty { $$ = "void"; }
| KW_INT { $$ = "int"; }
| KW_REAL { $$ = "double"; }
| KW_STRING { $$ = "char*"; }
| KW_BOOL { $$ = "int"; }
| TK_LEFT_BRACKET TK_RIGHT_BRACKET data_type { $$ = template("%s*", $3); }


statements_list:
 statements_list statement  { $$ = template("%s\n%s", $1, $2); }
| statement  {  $$ = template("%s\n", $1);  }
;

statement:
 simple_statement
| complex_statement TK_SEMICOLON { $$ = template("%s\n", $1); }
;

simple_statements_list:
 simple_statements_list simple_statement  { $$ = template("%s\n\t%s", $1, $2); }
| simple_statement  {  $$ = template("\n\t%s \n", $1);  }
;

complex_statement:
 TK_LEFT_CURLY_BRACKET simple_statements_list TK_RIGHT_CURLY_BRACKET { $$ = template("{\n%s\n} \n", $2); }
;


simple_statement:
 assign_stmt TK_SEMICOLON { $$ = template("%s;\n", $1); }
| break_stmt { $$ = $1; }
| continue_stmt { $$ = $1; }
| return_stmt { $$ = $1; }
| if_stmt { $$ = $1; }
| while_stmt { $$ = $1; }
| for_stmt { $$ = $1; }
| function_call_stmt TK_SEMICOLON { $$ = template("%s;\n", $1); }
;

assign_stmt:
 TK_IDENT TK_OP_ASSIGN expr  { $$ = template("%s = %s", $1,$3); }
| var_array_value TK_OP_ASSIGN expr  { $$ = template("%s = %s", $1,$3); }
;

break_stmt:
 KW_BREAK TK_SEMICOLON { $$ = " break; \n"; }
;

continue_stmt:
 KW_CONTINUE TK_SEMICOLON { $$ = " continue; \n"; }
;

return_stmt:
 KW_RETURN expr TK_SEMICOLON { $$ = template("return %s; \n", $2); }
| KW_RETURN TK_SEMICOLON { $$ = " return; \n"; }
;

if_stmt:
 KW_IF TK_LEFT_PARANT expr TK_RIGHT_PARANT statement { $$ = template("if (%s)  \n\t %s  \n\n",$3,$5); }
| KW_IF TK_LEFT_PARANT expr TK_RIGHT_PARANT statement KW_ELSE statement { $$ = template("if (%s)  \n\t %s  \n \n else %s  \n\n ",$3,$5,$7); }
;

while_stmt:
 KW_WHILE TK_LEFT_PARANT expr TK_RIGHT_PARANT statement { $$ = template("while(%s) %s  \n",$3,$5); }
;

for_stmt:
 KW_FOR TK_LEFT_PARANT assign_stmt TK_SEMICOLON expr TK_SEMICOLON assign_stmt TK_RIGHT_PARANT statement { $$ = template("for (%s ; %s ; %s) %s  \n",$3,$5,$7,$9); }
| KW_FOR TK_LEFT_PARANT assign_stmt TK_SEMICOLON assign_stmt TK_RIGHT_PARANT statement { $$ = template("for (%s ; %s) %s  \n",$3,$5,$7); }
;


function_call_stmt:
 TK_IDENT TK_LEFT_PARANT function_parameters_list TK_RIGHT_PARANT { $$ = template("%s(%s)", $1, $3); }
;

function_parameters_list:
 function_parameters_list TK_COMMA expr  { $$ = template("%s,%s", $1, $3); }
| expr  {  $$ = template("%s", $1);  }
| TK_CONST_STRING  { $$ = template("%s ",$1); }
| %empty { $$ = ""; }
;


expr_data:
 TK_IDENT { $$ = template("%s",$1); }
| TK_CONST_INT  { $$ = template("%s",$1); }
| TK_CONST_FLOAT  { $$ = template("%s",$1); }
| function_call_stmt { $$ = template("%s",$1); }
| TK_IDENT TK_LEFT_BRACKET expr TK_RIGHT_BRACKET  { $$ = template("%s [%s]",$1,$3); }
| bool_value { $$ = template("%s ",$1); } 
;


expr:
 expr_data
| TK_OP_MINUS expr  %prec UMINUS { $$ = template("-%s",$2); }
| expr TK_OP_POWER expr   { $$ = template("pow(%s,%s)", $1,$3); }
| expr TK_OP_MULT expr  { $$ = template("%s * %s", $1,$3); }
| expr TK_OP_DIV expr  { $$ = template("%s / %s", $1,$3); }
| expr TK_OP_MOD  expr  { $$ = template("%s %% %s", $1,$3); } 
| expr TK_OP_PLUS expr { $$ = template("%s + %s", $1,$3); }
| expr TK_OP_MINUS expr { $$ = template("%s - %s", $1,$3); } 
| expr TK_OP_EQUAL expr { $$ = template("%s == %s", $1,$3); }
| expr TK_OP_INEQUAL expr { $$ = template("%s != %s", $1,$3); }
| expr TK_OP_LESS expr { $$ = template("%s < %s", $1,$3); }
| expr TK_OP_EQUAL_OR_LESS expr { $$ = template("%s <= %s", $1,$3); }
| expr TK_OP_GRT expr { $$ = template("%s > %s", $1,$3); }
| expr TK_OP_EQUAL_OR_GRT expr { $$ = template("%s >=  %s", $1,$3); }
| expr KW_AND expr { $$ = template("%s && %s", $1,$3); }
| expr KW_OR expr { $$ = template("%s || %s", $1,$3); }
| KW_NOT expr { $$ = template("! %s", $2); }
| TK_LEFT_PARANT expr TK_RIGHT_PARANT { $$ = template("(%s)", $2); }
;



decl_list:
decl_list decl  { $$ = template("%s\n%s", $1, $2); }
| decl  {  $$ = template("%s\n", $1);  }
;


decl: 
var_declaration  { $$ = template("%s",$1); }
| const_declaration { $$ = template("%s",$1); }
;


var_array_value:
TK_IDENT TK_LEFT_BRACKET expr TK_RIGHT_BRACKET  { $$ = template("%s [%s]",$1,$3); }
| TK_IDENT TK_LEFT_BRACKET TK_RIGHT_BRACKET  { $$ = template("*%s", $1); }
;

var_declaration:
 KW_VAR assign_value_var_declaration TK_SEMICOLON { $$ = template("%s;",$2); }
;

assign_value_var_declaration:
 assign_single_value_var_declaration  assign_multiple_value_var_declaration data_type { {$$ = template("%s %s %s",$3,$1,$2);} } 
| assign_single_value_var_declaration data_type { $$ = template("%s %s",$2,$1);}
;


assign_multiple_value_var_declaration:
 assign_multiple_value_var_declaration TK_COMMA TK_IDENT TK_OP_ASSIGN data  { $$ = template("%s, %s = %s",$1,$3,$5);}
| assign_multiple_value_var_declaration TK_COMMA TK_IDENT   { $$ = template("%s, %s ",$1,$3);}
| assign_multiple_value_var_declaration TK_COMMA var_array_value TK_OP_ASSIGN expr {{$$ = template("%s, %s = %s",$1,$3,$5);}} 
| assign_multiple_value_var_declaration TK_COMMA var_array_value   { $$ = template("%s, %s ",$1,$3);}
| TK_COMMA TK_IDENT TK_OP_ASSIGN data  { $$ = template(", %s = %s",$2,$4);}
| TK_COMMA TK_IDENT   { $$ = template(", %s ",$2);}
| TK_COMMA var_array_value TK_OP_ASSIGN expr {{$$ = template(", %s = %s",$2,$4);}} 
| TK_COMMA var_array_value   { $$ = template(", %s ",$2);}
;


assign_single_value_var_declaration:
TK_IDENT TK_OP_ASSIGN data { $$ = template("%s = %s",$1,$3);}
| TK_IDENT  { $$ = template("%s",$1);}
| var_array_value   {$$ = template("%s",$1);}
| var_array_value TK_OP_ASSIGN expr  {$$ = template(" %s = %s",$1,$3);}
;


const_declaration:
 KW_CONST assign_value_const_declaration TK_SEMICOLON { $$ = template("const %s;",$2); }
;

assign_value_const_declaration:
 assign_single_value_const_declaration  assign_multiple_value_const_declaration data_type { {$$ = template("%s %s %s",$3,$1,$2);} } 
| assign_single_value_const_declaration data_type { $$ = template("%s %s",$2,$1);}
;

assign_single_value_const_declaration:
 TK_IDENT TK_OP_ASSIGN data { $$ = template("%s = %s",$1,$3);}
;

assign_multiple_value_const_declaration:
 assign_multiple_value_const_declaration TK_COMMA TK_IDENT TK_OP_ASSIGN data  { $$ = template("%s, %s = %s",$1,$3,$5);}
| TK_COMMA TK_IDENT TK_OP_ASSIGN data  { $$ = template(", %s = %s",$2,$4);}



bool_value:
 KW_TRUE {$$ = "1";}
| KW_FALSE {$$ = "0";}
;

data:
 expr { $$ = template("%s ",$1); }
| TK_CONST_STRING  { $$ = template("%s ",$1); }
;

data_type:
KW_INT { $$ = "int"; }
| KW_REAL { $$ = "double"; }
| KW_STRING { $$ = "char*"; }
| KW_BOOL { $$ = "int"; }
;

%%
int main () {
  if ( yyparse() == 0 )
    printf("// Your program is syntactically correct!\n");
  else
  	printf("// Your program is not syntactically correct!\n");
}

