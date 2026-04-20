%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokens.h"
}%
%token DIGIT
%%

line  : expr '\n' {printf("%d\n", $1);}
      ;


%%

yylex();