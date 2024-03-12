/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER
%token INT_LITERAL
%token REAL_LITERAL
%token BOOL_LITERAL


%token ADDOP MULOP RELOP ANDOP

%token IF THEN ELSE ENDIF

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS RETURNS 

%token REDUCE REAL CASE ARROW OTHERS WHEN ENDCASE REMOP EXPOP NOTOP OROP

%%

function:	
	function_header optional_variable body ;
	
function_header:
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	FUNCTION error ';'
	;
	

optional_variable:
	optional_variable variable | 
	error ';' | 
    	;
	
variable:
	IDENTIFIER ':' type IS statement_ ;

parameters:
       	| parameter_list
   	 ;

parameter_list:
	parameter |
	parameter_list ',' parameter
	;	


parameter:
	IDENTIFIER ':' type
	;	

type:
	INTEGER |
	REAL |
	BOOLEAN;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE ;

operator:
    	ADDOP |
    	RELOP |
    	EXPOP |
    	MULOP ;

reductions:
	reductions statement_ |
	;
	
cases:
	cases case |
	;

case:
	WHEN INT_LITERAL ARROW statement_ ;


expression:
	expression OROP and_expression |
	and_expression ;
	
and_expression:
	and_expression ANDOP relation |
	relation ;
		    		    

relation:
	relation RELOP term |
	term ;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP exponent |
	factor REMOP exponent |
	exponent ;

exponent:
	unary EXPOP exponent |
	unary ; 

unary:
	NOTOP unary |
	primary ;


primary:
	'(' expression ')' |
	INT_LITERAL |
	REAL_LITERAL|
	BOOL_LITERAL | 
	IDENTIFIER ;


%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
