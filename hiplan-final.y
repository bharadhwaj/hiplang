%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
void yyerror(char *);
int relop(int op, int arg1, int arg2);
int yylex(void);
int sym[32];

install ( char *sym_name )
{
	symrec *s;
	s = getsym (sym_name);
	if (s == 0)
		s = putsym (sym_name);
	else { errors++;
		printf( "\t\t\t%s is already defined\n", sym_name );
	}
}

context_check( char *sym name )
{ 
	if ( getsym( sym name ) == 0 )
	printf( ”%s is an undeclared identifier\n”, sym name );
}


%}
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

%union {
int     val;  /* For returning numbers.                   */
symrec  *tptr;   /* For returning symbol-table pointers      */
}

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
	|IF condition_expression THEN statement %prec IFX { if($2) printf("\t\t\tCondition True."); else printf("Condition False.\n"); }
	|IF condition_expression THEN statement NOPE statement { if($2) printf("\t\t\tCondition True."); else printf("Condition False.\n"); }
	;

declaration
	:IDENTIFIER IS NUMBER { install($1)}

expression_statement
	: '!'
	| expression '!'
	;


expression
	:IDENTIFIER {$$ = $1->value}
	|INTEGER {$$ = $1}
	|BLOCK_START expression BLOCK_END {$$ = $2}
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
	: IDENTIFIER ASSIGNMENT_OP expression { $$ = $3; $1->value = $3}


%%

void yyerror(char *s) {
	printf("\n ERROR. Exiting.\n");
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

symrec * putsym(char *sym_name)
{
  symrec *ptr;
  ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->intvalue = 0; /* set value to 0 even if fctn.  */
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
