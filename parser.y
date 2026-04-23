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
  int ival;
  char* sval;
}

typedef enum
{
  NODE_NUMBER,
  NODE_ID,
  NODE_ASSIGN,
  NODE_ADD,
  NODE_SUB,
  NODE_MUL,
  NODE_DIV,
  NODE_FLOAT,
  NODE_INT,
  NODE_CHAR,
  NODE_STRING
} NodeType;

typedef struct AST
{
   NodeType type;
   char* val;
   struct AST* left;
   struct AST* right;
} AST;

AST* make_node(AST* left, AST* right, char* val, NodeType type)
{
  AST node = (AST*)malloc(sizeof(AST));
  node->left = left;
  node->right = right;
  node->val = val;
  node->type = type;
  return node;
}

%token <var> ID INT_NUMBER FLOAT_NUMBER CHAR_LITERAL STRING_LITERAL
%token  LLS RLS LBRACE RBRACE SEMICOLON EQ INT FLOAT VOID LONG BOOL CHAR DOUBLE IF ELSE WHILE
%%
program:
     function_def
     ;
function_def:
    type_spec ID LLS RLS body_func return statement
    {}
     ;
body_func:
      LBRACE statement_list RBRACE
      ;
return_statement:
    RETURN expression SEMICOLON
    ;

statement_list:
     /*ПУСТО*/
     | statement_list statement
     ;
statement:
     declaration
    | assigment
    | expression SEMICOLON
    | compound_expression SEMICOLON
    ;

cycle_for:
    FOR LLS for_init SEMICOLON expression SEMICOLON expression RLS LBRACE statement_list RBRACE
    ;
for_init:
    assigment
    | declaration
    |
    ;

math_operators:
    ID PLUS ID SEMICOLON
    | ID MINUS ID SEMICOLON
    | ID DELIT ID SEMICOLON
    | ID STAR ID SEMICOLON
    | ID SHL ID SEMICOLON
    | ID SHR ID SEMICOLON
    ;

try_catch:
    TRY LBRACE statement_list RBRACE CATCH LBRACE statement_list RBRACE
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
    | ID NOT_EQ ID SEMICOLON
    | ID LT_EQ ID SEMICOLON
    | ID GT_EQ ID SEMICOLON
    ;
else_cond:
    ELSE LBRACE statement_list RBRACE
    ;
else_if_cond:
    ELSE IF LLS expression RLS RBRACE statement_list RBRACE
    | ELSE IF LLS is_equal RLS RBRACE statement_list RBRACE
    ;

while_cycle:
     WHILE LLS expression RLS RBRACE statement_list RBRACE
     | WHILE LLS is_equal RLS RBRACE statement_list RBRACE
     | WHILE LLS /*ПУСТО*/ RLS RBRACE statement_list RBRACE
     ;


switch_case:
     SWITCH LLS ID RLS LBRACE case_list opt_default RBRACE
        {$$ = make_node($3,make_node($6,$7,NULL,NODE_CASE_BLOCK),NULL, NODE_SWITCH);}

     ;
opt_default:
    /*пустооо*/
    | default
    ;

case_list:
    case_list case
        {$$ = make_node($1,$2,NULL,NODE_CASE_LIST);}
    | case
        {$$ = $1;}
    ;
case:
    CASE expression COLON statement_list
        {$$ = make_node($2,$4,NULL,NODE_CASE);}
    ;
default:
    DEFAULT COLON statement_list
        {$$ = make_node(NULL,$3,NULL,NODE_DEFAULT);}
    ;

comp_assign_operators:
    INC
        {$$ = NODE_INC_ASSIGN;}
    | DEC
        {$$ = NODE_DEC_ASSIGN;}
    | PLUS_EQ
        {$$ = NODE_PLUS_EQ_ASSIGN;}
    | MINUS_EQ
        {$$ = NODE_MINUS_EQ_ASSIGN;}
    | MUL_EQ
        {$$ = NODE_MUL_EQ_ASSIGN;}
    | DIV_EQ
        {$$ = NODE_DIV_EQ_ASSIGN;}
    | MOD_EQ
        {$$ = NODE_MOD_EQ_ASSIGN;}
    ;

compound_expression:
    ID comp_assign_operators ID
        {$$ = make_node($1,$3,NULL,$2);}
    ;

comparison_expression:
    ID EQ_EQ ID
        {$$ = make_node($1,$3,$2,NODE_COMPARE_EQ_EQ);}
    | ID NOT_EQ ID
        {$$ = make_node($1,$3,$2,NODE_COMPARE_NOT_EQ);}
    | ID LT_EQ ID
        {$$ = make_node($1,$3,$2,NODE_COMPARE_LT_EQ);}
    | ID GT_EQ ID
        {$$ = make_node($1,$3,$2,NODE_COMPARE_GT_EQ);}
    ;
expression:
      FLOAT_NUMBER
            { $$ = make_node(NULL, NULL, $1, NODE_FLOAT); }
      | INT_NUMBER
            { $$ = make_node(NULL, NULL, $1, NODE_INT); }
      | CHAR_NUMBER
            { $$ = make_node(NULL, NULL, $1, NODE_CHAR); }
      | STRING_NUMBER
            { $$ = make_node(NULL, NULL, $1, NODE_STRING); }
      | ID
            { $$ = make_node(NULL, NULL, $1, NODE_ID); }
      ;


type_spec:
     INT
        {$$ = make_node(NULL, NULL, NULL, NODE_TYPE_INT);}
     | FLOAT
        {$$ = make_node(NULL, NULL, NULL, NODE_TYPE_FLOAT);}
     | VOID
        {$$ = make_node(NULL, NULL, NULL, NODE_TYPE_VOID);}
     | LONG
        {$$ = make_node(NULL, NULL, NULL, NODE_TYPE_LONG);}
     | SHORT
        {$$ = make_node(NULL, NULL, NULL, NODE_TYPE_SHORT);}
     | DOUBLE
        {$$ = make_node(NULL, NULL, NULL, NODE_TYPE_DOUBLE);}
     | CHAR
        {$$ = make_node(NULL, NULL, NULL, NODE_TYPE_CHAR);}
     ;

%%

void yyerror(const char* s)
{
   fprintf(stderr,"Syntax error: %s\n",yyleno,s);
}