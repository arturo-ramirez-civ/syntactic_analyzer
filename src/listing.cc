// Arturo Ramirez
// CMSC 430 Compiler Theory and Design
// Project 2 
// February 4,2024

// This file contains the bodies of the functions that produces the 
// compilation listing

#include <cstdio>
#include <string>
#include <queue>

using namespace std;

#include "listing.h"

static int lineNumber;
static queue<string> errorQueue;
//index 0 is lexical, index 1 is syntax, and index 2 is semantic
static int totalErrors[] = {0, 0, 0}; 

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");

	int total = totalErrors[0] + totalErrors[1] + totalErrors[2];
		
		if (total > 0)
		{
			printf("\nLexical Errors: %d", totalErrors[0]);
                	printf("\nSyntax Errors: %d", totalErrors[1]);
                	printf("\nSemantic Errors: %d", totalErrors[2]);
			printf("\n");
		}
		else 
		{
			printf("Compiled Successfully \n");
		}
		return total;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate ",
		"Semantic Error, Undeclared " };

	errorQueue.push(messages[errorCategory] + message);
	totalErrors[errorCategory]++;
}

void displayErrors()
{
	while (!errorQueue.empty())
	{
		printf("%s\n", errorQueue.front().c_str());
		errorQueue.pop();
	}
}

