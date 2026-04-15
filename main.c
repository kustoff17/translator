#include "stdio.h"
#include "tokens.h"
extern int yylex(void);
extern char *yytext;

YYSTYPE yylval;

int main()
{
    int token;
    while ((token = yylex())!=0)
    {
        printf("token: %d text: %s\n",token,yytext);
    }
    return 0;
}