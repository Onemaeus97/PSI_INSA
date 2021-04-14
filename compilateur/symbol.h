#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
int position ;
int Tmp ;
enum types{INT};

typedef struct{
	char* name;
    enum types type;
    bool isInitialised;
    bool isConstant;
} symbol;

int pushSymbol(char *name, bool isConstant, bool isInitialised, enum types type);

int pushTmp( );

void popSymbol();

int popTmp();

int findSymbol(char* name);

bool isInitialised(char* name);

bool setInitialised (char* name);

bool isConstant(char* name);

void printSymbolTable();

void printTmp();


char* getType(enum types type);
