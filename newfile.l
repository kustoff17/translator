%{
  #include <stdio.h>
  #include <string.h>
  #include<stdlib.h>
%}
%%
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
"+"  { return PLUS; }
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
"||" {return OR;}
"<<" { return SHL; }
">>" { return SHR; }
"->" { return ARROW; }
[0-9]+ {strcpy(yylval.var, yytext); return INT_NUMBER;}
[a-zA-Z]+ {strcpy(yylval.var, yytext); return LITERAL;}
%%
int yywrap()
{
return 1;
}