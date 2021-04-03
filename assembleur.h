#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef ASSEMBLEUR_H
#define ASSEMBLEUR_H

//#include "symbol_table.h"

#define ADD   01
#define MUL   02
#define SOU   03
#define DIV   04
#define COP   05
#define AFC   06
#define LOAD  07
#define STORE 08
#define max_instructions 1024

typedef struct instruction {
    char operation[5];
    int r1;
    int r2;
    int r3;
} instruction;
void add_instruction(char *operation,int r1, int r2, int r3 );
void write_all_instructions();
int get_line_asm();
void patcher();
void patcher_else();
#endif


