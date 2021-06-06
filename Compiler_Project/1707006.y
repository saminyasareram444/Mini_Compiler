%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	int data[60];
%}

/* bison declarations */

%token NUM VAR IF ELIF ELSE MAIN INT FLOAT CHAR COM START END SWITCH CASE DEFAULT BREAK LOOP PF SIN COS TAN LOG LOG10
%nonassoc IFX
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

statement: ';'			
	| declaration ';'		{ printf("Declaration\n"); }

	| expression ';' 			{}
	
	| VAR '=' expression ';' { 
							data[$1] = $3; 
							printf("Value of the variable: %d\t\n",$3);
							$$=$3;
						} 
	| COM	{
				printf("This is a single line comment.\n");
		}
   
	| LOOP '(' expression '<' expression ';' expression '+''+' ')' START statement END {
	                                int i;
	                                for(i=$3 ; i<$5 ; i++) {printf("value of variable: %d expression value: %d\n", i,$12);}									
				               }
	| LOOP '(' expression '>' expression ';' expression '-''-' ')' START statement END {
	                                int i;
	                                for(i=$3 ; i>$5 ; i--) {printf("value of variable: %d expression value: %d\n", i,$12);}									
				               }
	| LOOP '(' expression '<' expression ';' expression '-''-' ')' START statement END {
	                                int i;
	                                for(i=$5 ; i>$3 ; i--) {printf("value of variable: %d expression value: %d\n", i,$12);}									
				               }
	| LOOP '(' expression '>' expression ';' expression '+''+' ')' START statement END {
	                                int i;
	                                for(i=$5 ; i<$3 ; i++) {printf("value of variable: %d expression value: %d\n", i,$12);}									
				               }
	| SWITCH '(' VAR ')' START B  END

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
									printf("value of expression in ELIF: %d\n",$11);
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
C   : C '+' C
	| CASE NUM ':' expression ';' BREAK ';' {}
	;
D   : DEFAULT ':' expression ';' BREAK ';' {}
	
declaration : TYPE ID1   
             ;


TYPE : INT   
     | FLOAT  
     | CHAR   
     ;



ID1 : ID1 ',' VAR  
    |VAR  
    ;

expression: NUM					{ $$ = $1; 	}

	| VAR						{ $$ = data[$1]; }
	
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


yyerror(char *s){
	printf( "%s\n", s);
}

