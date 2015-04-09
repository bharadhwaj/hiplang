/* Data type for links in the chain of symbols.      */
struct symrec
{
  char *name;  /* name of symbol                     */
  int type;    /* type of symbol: either VAR or FNCT */
  int value;
  struct symrec *next;    /* link field              */
};

typedef struct symrec symrec;

/* The symbol table: a chain of `struct symrec'.     */
symrec *sym_table = (symrec *)0;

symrec *putsym ();
symrec *getsym ();
