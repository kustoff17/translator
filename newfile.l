%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>
  #include "tokens.h"
%}
%x COMMENT
%option yylineno
%%
"/*" {BEGIN(COMMENT);}
<COMMENT>"*/" {BEGIN(INITIAL);}
<COMMENT>\n {}
<COMMENT>. {}
<COMMENT><<EOF>> {
    fprintf(stderr, "ERROR at line %d: unterminated comment\n", yylineno);
    return 0;
}
"//"[^\n]* { }
"class" {return CLASS;}
"protected" {return PROTECT;}
"public" {return PUBLIC;}
"int" {return INT;}
"for" {return FOR;}
"while" {return WHILE;}
"try" {return TRY;}
"catch" {return CATCH;}
"float" {return FLOAT;}
"void" {return VOID;}
"if" {return IF;}
"else" {return ELSE;}
"this" {return THIS;}
"nullptr" {return NULLPTR;}
"const" {return CONST;}
"new" {return NEW;}
"&&" {return AND;}
"&" {return AMP;}
"||" {return OR;}
"<<" { return SHL;}
">>" { return SHR;}
"->" { return ARROW;}
"#"[ \t]*"include" { return INCLUDE; }
"%"  { return MOD; }
"!"  { return NOT; }
"++" { return INC; }
"--" { return DEC; }
"+=" { return PLUS_EQ; }
"-=" { return MINUS_EQ; }
"*=" { return MUL_EQ; }
"/=" { return DIV_EQ; }
"%=" { return MOD_EQ; }
"::" { return SCOPE; }
";"  { return SEMICOLON; }
","  { return COMMA; }
"."  { return DOT; }
"operator" {return OPER;}
"==" { return EQ_EQ; }
"!=" { return NOT_EQ; }
"<=" { return LT_EQ; }
">=" { return GT_EQ; }
"=" {return EQ;}
"+" { return PLUS; }
"-" {return MINUS;}
"/" {return DELIT;}
"delete" {return DEL;}
"*" {return POINTER;}
"noexcept" {return NOEX;}
"(" {return LLS;}
")" {return RLS;}
"[" {return LS;}
"]" {return RS;}
"{" { return LBRACE; }
"}" { return RBRACE; }
"return" {return RET;}
"~" {return TILDA;}
"<" {return LOSS;}
">" {return BIG;}
":" { return COLON; }
"?" { return QUESTION; }
"#" {return SHARP;}
"true" { return TRUE_; }
"false" { return FALSE_; }
"bool" { return BOOL; }
"char"  { return CHAR; }
"double" { return DOUBLE; }
"long"  { return LONG; }
"short" { return SHORT; }
[0-9]+\.[0-9]+ {strcpy(yylval.var,yytext); return FLOAT_NUMBER;}
[0-9]+ {strcpy(yylval.var, yytext); return INT_NUMBER;}
\"([^\\\"\n]|\\.)*\" { strcpy(yylval.var, yytext); return STRING_LITERAL; }
\'([^\\\'\n]|\\.)\' { strcpy(yylval.var, yytext); return CHAR_LITERAL; }
[a-zA-Z_][a-zA-Z0-9_]* {strcpy(yylval.var, yytext); return ID;}
[ \t\r\n]+ {}
. {
    fprintf(stderr, "ERROR at line %d: unknown symbol '%s'\n", yylineno, yytext);
}
%%
int yywrap()
{
return 1;
}