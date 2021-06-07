%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	#include<string.h>
	#include<stdarg.h>
	int data[60];
	int yylex();
	extern FILE *yyin,*yyout;
	int i,f=0;
	typedef struct variable {
			char *str;
	    		int n;
			}array;
	array store[1000];
	void yyerror(char *s);
	void vari (array *p, char *s, int n);
	void valassig (char *s, int n);
	int check(char *key);
	int count = 1,cnt = 1,sw=0;
	int q=0,prev=0;
	float fl;
%}

/* bison declarations */

%union 
{
	 int number;
     char *string;
}

%token <string> VAR
%type <number> expression statement
%token <number> NUM
%token IF ELIF ELSE MAIN INT FLOAT CHAR COM START END SWITCH CASE DEFAULT BREAK LOOP PF SIN COS TAN LOG LOG10
%nonassoc IF
%nonassoc ELSE
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT
%right '='
%left '<' '>'
%left '+' '-'
%left '*' '/' '%'

/* Grammar rules and actions follow.  */

%%

program: MAIN ':' START cstatement END
	 ;

cstatement: /* NULL */

	| cstatement statement
	;

statement: ';'		{}	
	| declaration ';'		{ printf("Declaration\n"); }

	| expression ';' 			{}
	
	| VAR '=' expression ';' { 
								if(check($1))
								{
									valassig ($1,$3);
									printf("\nValue of the Variable (%s)= %d\t\n",$1,$3);
								}
								else
								{
									printf("\n(%s) Variable Not DEclared\n",$1); 
								}
							} 
	| COM	{
				printf("This is a single line comment.\n");
		}
   
	| LOOP '(' expression '<' expression ';' expression '+''+' ')' START expression '=' expression ';' END {
	                                int i;
	                                for(i=$3 ; i<$5 ; i++) {printf("value of variable: %d expression value: %d\n", i,$14);}									
				               }
	| LOOP '(' expression '>' expression ';' expression '-''-' ')' START expression '=' expression ';' END {
	                                int i;
	                                for(i=$3 ; i>$5 ; i--) {printf("value of variable: %d expression value: %d\n", i,$14);}									
				               }
	| LOOP '(' expression '<' expression ';' expression '-''-' ')' START expression '=' expression ';' END {
	                                int i;
	                                for(i=$5 ; i>$3 ; i--) {printf("value of variable: %d expression value: %d\n", i,$14);}									
				               }
	| LOOP '(' expression '>' expression ';' expression '+''+' ')' START expression '=' expression ';' END {
	                                int i;
	                                for(i=$5 ; i<$3 ; i++) {printf("value of variable: %d expression value: %d\n", i,$14);}									
				               }
	| SWITCH '(' expression ')' START B  END {}

	| IF '(' expression ')' START expression ';' END %prec IFX {
								if($3){
									printf("\nvalue of expression in IF: %d\n",$6);
								}
								else{
									printf("condition value zero in IF block\n");
								}
							}

	| IF '(' expression ')' START expression ';' END ELIF '(' expression ')' START expression ';' END ELSE START expression ';' END {
								if($3){
									printf("value of expression in IF: %d\n",$6);
								}
								else if($11){
									printf("value of expression in ELIF: %d\n",$14);
								}
								else{
									printf("value of expression in ELSE: %d\n",$19);
								}
							}
	| PF '(' expression ')' ';' {printf("Print Expression %d\n",$3);}
	;
	
B   : C
	| C D
    ;
C   : C C
	| CASE NUM ':' expression ';' BREAK ';' {}
	;
D   : DEFAULT ':' expression ';' BREAK ';' {}
	
declaration : TYPE ID1 {} 
             ;


TYPE : INT   
     | FLOAT  
     | CHAR   
     ;



ID1 : ID1 ',' ID2 {}
	| ID2 {}
	| {}
;
  
ID2 : VAR {				if(check($1))
						{
							printf("\nERROR:Multiple Declaration Of (%s) \n", $1 );
						}
						else
						{
							printf("(%s) Variable Declared\n",$1);
							vari(&store[count],$1, count);
							count++;
						}
			} 
    

 
expression: NUM					{ $$ = $1; 	}

	| VAR 	{	int i = 1;
				char *name = store[i].str;
				while (name) 
				{
					if (strcmp(name, $1) == 0)
					{
						$$ = (int)store[i].n;
						break;
					}
						name = store[++i].str;
				}
			}						
	
	| expression '+' expression	{ $$ = $1 + $3; }

	| expression '-' expression	{ $$ = $1 - $3; }

	| expression '*' expression	{ $$ = $1 * $3; }

	| expression '/' expression	{ if($3){
				     					$$ = $1 / $3;
				  					}
				  					else{
										$$ = 0;
										printf("\ndivision by zero\t");
				  					} 	
				    			}
	| expression '%' expression	{ if($3){
				     					$$ = $1 % $3;
				  					}
				  					else{
										$$ = 0;
										printf("\nMOD by zero\t");
				  					} 	
				    			}
	| expression '^' expression	{ $$ = pow($1 , $3);}
	| expression '<' expression	{ $$ = $1 < $3; }
	
	| expression '>' expression	{ $$ = $1 > $3; }

	| '(' expression ')'		{ $$ = $2;	}
	| SIN expression 			{printf("Value of Sin(%d) is %lf\n",$2,sin($2*3.1416/180)); $$=sin($2*3.1416/180);}

    | COS expression 			{printf("Value of Cos(%d) is %lf\n",$2,cos($2*3.1416/180)); $$=cos($2*3.1416/180);}

    | TAN expression 			{printf("Value of Tan(%d) is %lf\n",$2,tan($2*3.1416/180)); $$=tan($2*3.1416/180);}

    | LOG10 expression 			{printf("Value of log(%d) is %lf\n",$2,(log($2*1.0)/log(10.0))); $$=(log($2*1.0)/log(10.0));}
	| LOG expression 			{printf("Value of ln(%d) is %lf\n",$2,(log($2))); $$=(log($2));}
	
	;
%%

void vari(array *p, char *s, int n)
				{
				  p->str = s;
				  p->n = n;
				}
void valassig(char *s, int num)
			{
				    int i = 1;
				    char *name = store[i].str;
				    while (name) {
				        if (strcmp(name, s) == 0){
					store[i].n=num;
						break;
				            }
					name = store[++i].str;
				}
			}

int check(char *key)
			{
				
			    int i = 1;
			    char *name = store[i].str;
			    while (name) {
				        if (strcmp(name, key) == 0){
						return i;
					}
						name = store[++i].str;
				}
			    return 0;
			}
void yyerror(char *s){
	printf( "%s\n", s);
}
int yywrap()
{
	return 1;
}

int main()
{
	freopen("input.txt","r",stdin);
	freopen("output.txt","w",stdout);
	yyparse();

	fclose(yyin);
 	fclose(yyout);
    
	return 0;
}

