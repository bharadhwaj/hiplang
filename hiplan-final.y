%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#define YYDEBUG 1
void yyerror(char *);
int relop(int op, int arg1, int arg2);
int yylex(void);
%}
%union {
int     val;  /* For returning numbers.                   */
struct symrec  *tptr;   /* For returning symbol-table pointers      */
}

%token SHOWME GIMME IS OF IF ARE NUMBER CHARACTER REALNUM THEN NOPE GOTTADO WHEN FOR FROM TO KEEPDOING CALLME WITH TODO THROW TOGET HEY TAKE YOUGOT BRINGITON

%token <tptr> IDENTIFIER 
%token <val>INTEGER
%token EQUALS RLOP_LTE RLOP_LT RLOP_GT RLOP_GTE NOTEQUAL ASSIGNMENT_OP
%token BLOCK_START BLOCK_END
%token MAIN_START MAIN_END

%type  <val>  expression
%type  <val>  condition_expression
%type  <val>  assignment_expression

%nonassoc IFX
%nonassoc NOPE



%left EQUALS NOTEQUAL
%left RLOP_LT RLOP_LTE RLOP_GT RLOP_GTE
%left '+' '-'
%left '*' '/'

%%

program
	:MAIN_START statements MAIN_END {printf("End of main. Exiting\n");return;}
	;

statements
	:statements statement
	|statement
	;

statement
	:declaration
	|expression_statement
	|compound_statement
	|assignment_expression
	|io_statement
	|IF expression THEN statement %prec IFX { if($2) printf("\t\t\tCondition True.\n"); else printf("\t\t\tCondition False.\n"); }
	|IF expression THEN statement NOPE statement { if($2) printf("\t\t\tCondition True.\n"); else printf("\t\t\tCondition False.\n"); }
	|iteration_statement
	;

declaration
	:IDENTIFIER IS NUMBER {$1->value = 0;}

io_statement
	:GIMME IDENTIFIER {scanf("%d",&$2->value);}
	|SHOWME IDENTIFIER {printf("Identifier %s = %d\n", $2->name, $2->value);}

iteration_statement
	:GOTTADO WHEN expression statement {printf("\t\t\tIdentified loop\n");}
	|GOTTADO statement WHEN expression {printf("\t\t\tIdentified loop\n");}
	|FOR IDENTIFIER FROM INTEGER TO INTEGER KEEPDOING statement {printf("\t\t\t%s will loop from %d to %d\n", $2->name, $4, $6);}

	;

expression_statement
	: '!'
	| expression '!'
	;


expression
	:IDENTIFIER {$$ = $1->value;}
	|INTEGER {$$ = $1;}
	|BLOCK_START expression BLOCK_END {$$ = $2;}
	|condition_expression
	|expression '+' expression { $$ = $1 + $3; printf("\t\t\t<--(%d,%d)Evaluated to: %d \n",$1,$3,$$); }
	|expression '-' expression { $$ = $1 - $3; printf("\t\t\t<--(%d,%d)Evaluated to: %d \n",$1,$3,$$); }
	|expression '*' expression { $$ = $1 * $3; printf("\t\t\t<--(%d,%d)Evaluated to: %d \n",$1,$3,$$); }
	|expression '/' expression { $$ = $1 / $3; printf("\t\t\t <--(%d,%d)Evaluated to: %d \n",$1,$3,$$); }
	;

condition_expression
	:expression EQUALS expression { $$ = relop(EQUALS, $1, $3);}
	|expression NOTEQUAL expression { $$ = relop(NOTEQUAL, $1, $3);}
	|expression RLOP_LT expression { $$ = relop(RLOP_LT, $1, $3);}
	|expression RLOP_LTE expression { $$ = relop(RLOP_LTE, $1, $3);}
	|expression RLOP_GT expression { $$ = relop(RLOP_GT, $1, $3);}
	|expression RLOP_GTE expression { $$ = relop(RLOP_GTE, $1, $3);}
	;

compound_statement
	: BLOCK_START BLOCK_END
	| BLOCK_START statements BLOCK_END
	;



assignment_expression
	: IDENTIFIER ASSIGNMENT_OP expression { $$ = $3; $1->value = $3;}


%%

void yyerror(char *s) {
	printf("\n ERROR:%s. Exiting.\n",s);
	return;
}

int relop(int op, int arg1, int arg2){
	switch(op){
		case EQUALS:
				return arg1 == arg2;
		case NOTEQUAL:
				return arg1 != arg2;
		case RLOP_LT:
				return arg1 < arg2;
		case RLOP_LTE:
				return arg1 <= arg2;
		case RLOP_GT:
				return arg1 > arg2;
		case RLOP_GTE:
				return arg1 >= arg2;
	}

}
void main(int argc, char *argv[]) {

	//yyin = fopen(argv[1], "r");
	printf("\n \t HIPLANG v0.1.2\n");
	yyparse();
	//fclose(yyin);

}
symrec *sym_table = (symrec *)0;

symrec * putsym(char *sym_name)
{
  symrec *ptr;
  ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->value = 0; /* set value to 0 even if fctn.  */
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec *
getsym (sym_name)
     char *sym_name;
{
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name,sym_name) == 0)
      return ptr;
  return 0;
}
