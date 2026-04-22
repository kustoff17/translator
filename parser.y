%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokens.h"
%}
yylex();
extern int yyleno;
void yyerror(const char *s);
%union
{
  int var;
  char var[256];
}

%token <var> ID INT_NUMBER FLOAT_NUMBER CHAR_LITERAL STRING_LITERAL
%token  LLS RLS LBRACE RBRACE SEMICOLON EQ INT FLOAT VOID LONG BOOL CHAR DOUBLE IF ELSE
%%
program:
     function_def
     ;
function_def:
    type_spec ID LLS RLS body_func
     ;
body_func:
      LBRACE statement_list RBRACE
      ;
statement_list:
     /*ПУСТО*/
     | statement_list statement
     ;
statement:
     declaration
    | assigment
    | expression SEMICOLON
    ;

cycle_for:
    FOR LLS for_init SEMICOLON expression SEMICOLON expression RLS LBRACE statement_list RBRACE
    ;
for_init:
    assigment
    | declaration
    |
    ;


assigment:
     ID EQ expression SEMICOLON
     ;

declaration:
     type_spec ID EQ expression SEMICOLON
     | type_spec ID SEMICOLON
     ;

declaration_list:
    /*empty*/
    | declaration_list declaration
    ;

struct_:
    LBRACE declaration_list RBRACE
    ;
if_cond:
    IF LLS expression RLS LBRACE statement_list RBRACE
    | IF LLS is_equal RLS LBRACE statement_list RBRACE
    ;
is_equal:
    ID EQ_EQ ID SEMICOLON
    ;
else_cond:
    ELSE LBRACE statement_list RBRACE
    ;
else_if_cond:
        ELSE IF LLS expression RLS RBRACE statement_list RBRACE
        | ELSE IF LLS is_equal RLS RBRACE statement_list RBRACE
        ;

expression:
     FLOAT_NUMBER
     | INT_NUMBER
     | CHAR_NUMBER
     | STRING_NUMBER
     | ID
     ;

type_spec:
     INT
     | FLOAT
     | VOID
     | LONG
     | SHORT
     | DOUBLE
     | CHAR
     ;



%%

void yyerror(const char* s)
{
   fprintf(stderr,"Syntax error: %s\n",yyleno,s);
}