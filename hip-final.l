
digit [0-9]
letter [a-z]
%{
	#include <stdlib.h>
	void yyerror(char *);
	void yyprint(char *);
	#include "y.tab.h"
	#include "symtab.h"
%}

%%

NEVERMIND(.)*THIS {printf("\nComment: %s \n",yytext);}
SHOWME {return (SHOWME);}
GIMME {return (GIMME);}
IS {return (IS);}
OF {return (OF);}
IF {return (IF);}
ARE {return (ARE);}
NUMBER {return (NUMBER);}
CHARACTER {return (CHARACTER);}
REALNUM {return (REALNUM);}
THEN {return (THEN);}
NOPE? {return (NOPE);}
GOTTADO {return (GOTTADO);}
WHEN {return (WHEN);}
FOR {return (FOR);}
FROM {return (FROM);}
TO {return (TO);}
KEEPDOING {return (KEEPDOING);}
CALLME {return (CALLME);}
WITH {return (WITH);}
TODO {return (TODO);}
THROW {return (THROW);}
TOGET {return (TOGET);}
HEY {return (HEY);}
TAKE {return (TAKE);}
YOUGOT {return (YOUGOT);}
BRINGITON {return (BRINGITON);}
{digit}+ { yylval.val = atoi(yytext); return (INTEGER); }

{letter}({letter}|{digit}|_)* {
								symrec *s;
								s = getsym(yytext);
								if(s == 0)
									s = putsym(yytext)
								yylval.tptr = s;
								return (IDENTIFIER); 
							  }



EQUALS {return EQUALS;}
"<=" {return RLOP_LTE;}
"<"  {return RLOP_LT;}
">"  {return RLOP_GT;}
">="  {return RLOP_GTE;}
NOTEQUAL {return NOTEQUAL;}
= {return ASSIGNMENT_OP;}

"<-" {return BLOCK_START;}
"->" {return BLOCK_END;}


[+] {return '+';}
[-] {return '-';}
[*] {return '*';}
[/] {return '/';}

"!" {return '!';}

HI {return (MAIN_START);}
BYE {return (MAIN_END);}
[ \t\n]+ {/* Do nothing. \n*/}
%%


int yywrap(void) {
return 1;
}

