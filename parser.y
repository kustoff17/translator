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
  char var[256];
}

%token <var> ID INT_NUMBER FLOAT_NUMBER CHAR_LITERAL STRING_LITERAL
%%
program:
     function_def
     ;
function_def:
    type_spec ID LLS RLS body_func
     ;
body_func:
      LBRACE block RBRACE
      ;
block:
     | block statement
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