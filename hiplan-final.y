%token SHOWME GIMME IS OF IF ARE NUMBER CHARACTER REALNUM THEN NOPE GOTTADO WHEN FOR FROM TO KEEPDOING CALLME WITH TODO THROW TOGET HEY TAKE YOUGOT BRINGITON

%token IDENTIFIER INTEGER
%token EQUALS RLOP_LTE RLOP_LT RLOP_GT RLOP_GTE NOTEQUAL ASSIGNMENT_OP
%token BLOCK_START BLOCK_END
%token MAIN_START MAIN_END


%left '+' '-'
%left '*' '/'

%{
#include <stdio.h>
void yyerror(char *);
int yylex(void);
int sym[26];
%}


%%

program
	:MAIN_START statement MAIN_END {printf("End of main. Exiting\n");return;}
	;

statement
	:expression_statement
	|compound_statement
	|IF expression THEN expression_statement
	;

expression_statement
	: '!'
	| expression '!'
	;

expression
	: IDENTIFIER
	| INTEGER
	|assignment_expression
	;

compound_statement
	: BLOCK_START BLOCK_END
	| BLOCK_START block_item BLOCK_END
	;

block_item
	: statement
	| block_item statement
	;

assignment_expression
	: IDENTIFIER ASSIGNMENT_OP expression


%%

void yyerror(char *s) {
	printf("\n ERROR. Exiting.\n");
	return;
}


void main(int argc, char *argv[]) {

	//yyin = fopen(argv[1], "r");
	printf("\n \t HIPLANG v0.1.2\n");
	yyparse();
	//fclose(yyin);

}