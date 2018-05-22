UNDER   "_"
PLUS    "+"
MINUS   "-"
ALPHA   [a-zA-Z]
NUMERIC [0-9]

TYPES     "int"|"bool"
PAR       "("|")"
CHA       "{"|"}"
OPE       {PLUS}|{MINUS}|"*"|"/"|"&&"|"||"|"<"|">"|"=="

SYMB      ","|";"
SPECIAL   ("main"|"var"|"if"|"while"|"do"|"return"|"print"|"function")

NUMBER    {NUMERIC}+
FLOAT     (,({NUMBER}))?
EXP       ("E"(({MINUS}|{PLUS})?)({NUMBER}?))?

INTEGER   {NUMBER}{FLOAT}{EXP}
ID        {ALPHA}({ALPHA}|{NUMERIC})*({UNDER}({ALPHA}|{NUMERIC})+)*
NATURAL   ({PLUS}|{MINUS}){INTEGER}

%%

{TYPES}         {printf("Types: %s.\n", yytext);}
{PAR}           {printf("Parenthesis: %s.\n", yytext);}
{CHA}           {printf("Brackets: %s.\n", yytext);}
{OPE}           {printf("Binary operator: %s.\n", yytext);}
{SYMB}          {printf("Especial symbols: %s.\n", yytext);}
{SPECIAL}       {printf("Especial world: %s.\n", yytext);}
{NATURAL}       {printf("It's a natural: %s.\n", yytext);}
{INTEGER}       {printf("It's an integer: %s.\n", yytext);}
{ID}            {printf("Identifier: %s.\n", yytext);}

%%

int yywrap();

int main() {
  yylex();
  return 0;
}

int yywrap() {
  return 1;
}

/*PAR       "("|")"
CHA       "{"|"}"
OPE       {PLUS}|{MINUS}|"*"|"/"|"&&"|"||"|"<"|">"|"=="

TYPES     "int"
SYMB      ","|";"
SPECIAL   ("main"|"var"|"if"|"while"|"do"|"return"|"print"|"function")

%%

{NATURAL}       {printf("It's a natural: %s.\n", yytext);}
{INTEGER}       {printf("It's an integer: %s.\n", yytext);}
{ID}            {printf("Identifier: %s.\n", yytext);}
{TYPES}         {printf("Type: %s.\n", yytext);}
{SPECIAL}       {printf("Special work: %s.\n", yytext);}

%%
*/
