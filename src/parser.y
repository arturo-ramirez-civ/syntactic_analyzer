/*
   Updated by: Arturo Ramirez
   CMSC 430 Compiler Theory and Design
   Project 2
   Updated: February 4,2024 */ 

/* Project 2 Parser */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER INT_LITERAL CHAR_LITERAL REAL_LITERAL

%token ADDOP MULOP ANDOP RELOP ARROW REMOP EXPOP NEGOP OROP NOTOP

%token BEGIN_ CASE CHARACTER END ENDSWITCH FUNCTION INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN ELSE ELSIF ENDFOLD ENDIF FOLD IF LEFT REAL RIGHT THEN

%%

function:	
	function_header optional_variable body ;

function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' |
	error ';' ;

optional_parameters:
	optional_parameters parameters |
	%empty ;

parameters:
	parameters ',' parameter |
	parameter ;

parameter:
	IDENTIFIER ':' type ;

type:
	INTEGER |
	REAL |
	CHARACTER ;
	
optional_variable:
	optional_variable variable |
	%empty ;
    
variable:	
	IDENTIFIER ':' type IS statement ';' |
	IDENTIFIER ':' LIST OF type IS list ';' ;

list:
	'(' expressions ')' ;

expressions:
	expressions ',' expression| 
	expression ;

body:
	BEGIN_ statement_ END ';' ;

statement_:
	statement ';' |
	error ';' ;
    
statement:
	expression |
	WHEN condition ',' expression ':' expression |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH |
	IF condition THEN statement_ other ELSE statement_ ENDIF |
	FOLD direction operator list_choice ENDFOLD;

other:
	other ELSIF condition THEN statement ';' |
	%empty ;

cases:
	cases case |
	%empty ;
	
case:
	CASE INT_LITERAL ARROW statement ';' ; 

direction:
	LEFT |
	RIGHT ;

operator:
	ADDOP |
	MULOP ;

list_choice:
	list |
	IDENTIFIER ;

condition:
	condition OROP condition_ |
	condition_ ;

condition_:
	condition_ ANDOP relation |
	relation ;

relation:
	'(' condition ')' |
	expression RELOP expression ;

expression:
	expression ADDOP term |
	term ;
      
term:
	term MULOP factor |
	term REMOP factor |
	factor ;

factor:
	unary |
	factor EXPOP unary ;

unary:
	NOTOP primary |
	primary ;

primary:
	'(' expression ')' |
	NEGOP expression |
	INT_LITERAL |
	REAL_LITERAL |
	CHAR_LITERAL |
	IDENTIFIER '(' expression ')' |
	IDENTIFIER ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 

