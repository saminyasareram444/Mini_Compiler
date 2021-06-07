%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include<math.h>
	#include "1707006.tab.h"
%}

alpha [a-zA-Z]
digit [0-9]
keyWord					IF|ELIF|ELSE|LOOP|RETURN|INTGR|FLOATING|CHARAC|SWITCHING|CASING|BREAK|DEF|PRINTS
singleLineComment		[ ]*[#][#][a-zA-Z0-9@$%^&*(){}_+-,.:\|?>< ]*


%%

{digit}+	{ yylval = atoi(yytext); return NUM; }
{alpha}	    { yylval = *yytext - 'a'; return	VAR; }

SWITCHING 		   { return SWITCH; }
PRINTS 		       { return PF; }
CASING   		   { return CASE;  } 
IF 			   { return IF;   }
ELIF			{return ELIF;}
ELSE 		   { return ELSE; }
BREAK  		   { return BREAK;  }
DEF 	       { return DEFAULT; }
"{" 		   { return START;  }
"}"  		   { return END;	}
LOOP 		   { return LOOP;}
SIN			   {return SIN;}
COS            {return COS;}
TAN            {return TAN;}
LN			   {return LOG;}
LOG 		   {return LOG10;}

{singleLineComment}		{return COM;}

[-+/*<>=,():;%^]     {yylval = yytext[0];	return *yytext;	}
INTGR  			 {return INT;}
CHARAC 		         {return CHAR;}
FLOATING 			 	{return FLOAT;}
"main"	   { return MAIN; }
[ ]*	    			{}
[\n]*					{}
[\t]*					{}
.						{printf("%s --> invalid\n",yytext);}


%%
int yywrap()
{
	return 1;
}

int main()
{
	freopen("input.txt","r",stdin);
	freopen("output.txt","w",stdout);
	yyparse();
    
	return 0;
}