#include "symbol.h"
#define TAILLE 100

//initialise symbol table
symbol *symbolTable[TAILLE] ;
int position = -1;
int Tmp = 200;
symbol *New_Symbol(char *name, bool isConstant, bool isInitialised, enum types type)
{
    if (position != -1) //if symbolTable is not empty
    {
        for (int i = 0; i < position; i++)
        {
            if (strcmp(symbolTable[i]->name, name) == 0)
            {
                //printf("Variable name already exsites: %s \n", name);
                return NULL;
            }
        }
    }
    symbol *s = malloc(sizeof(symbol));
    s->name = strdup(name);
    s->isInitialised = isInitialised;
    s->isConstant = isConstant;
    s->type = type;
    return s;
}

int pushSymbol(char *name, bool isConstant, bool isInitialised, enum types type)
{
    if (position >= TAILLE - 1)
    {
        printf("TABLE FULL\n");
    }
    else
    {
        symbol *s = New_Symbol(name, isConstant,isInitialised,type);
        if (s != NULL)
        {
            position++;
            symbolTable[position] = s;
        }
    }
    return position;
}
int pushTmp()
{
    Tmp++;
    //printf("TMP : %d \n",Tmp);
    return Tmp;
}

int popTmp()
{
    int ret = Tmp ;
    Tmp -- ;
    //printf("TMP : %d \n",Tmp);
    return ret;
}

void popSymbol()
{
    free(symbolTable[position]);
    position--;
}

bool isInitialised(char* name)
{
    int i=findSymbol(name);
    return symbolTable[i]->isInitialised;
}

//if exits return position else return -1
int findSymbol(char* name)
{
    for(int i=0;i<=position;i++){
        if(!strcmp(symbolTable[i]->name, name))
            return i;
    }
    return -1;
}


bool setInitialised (char* name){
    int index= findSymbol(name);
    if(index!=-1){
        symbolTable[index]->isInitialised=true;
        return true;
    }
    else return false;
}

bool isConstant(char* name)
{
    int i=findSymbol(name);
    return symbolTable[i]->isConstant;
}

void printSymbol(symbol *s)
{
    printf("name = %s  const = %d  initilised = %d type = %s\n ", s->name, s->isConstant , s->isInitialised ,getType(s->type));
}
void printSymbolTable()
{
    printf("-------------------------\n");
    printf("position = %d\n", position);
    for (int i = 0; i < position + 1; i++)
    {
        printf("[%d]",i);
        printSymbol(symbolTable[i]);
    }
    printf("-------------------------\n");
}
void printTmp(){

    printf("-------------------------\n");
    printf(" Tmp = %d\n", Tmp);
    printf("-------------------------\n");
}

char* getType(enum types type)
{
   switch (type)
   {
      case INT: return "INT";
   }
}
