/*void add_instruction(char *operation,int r1, int r2, int r3 );
 void print_instruction(instruction i);
 void print_all_instructions();
*/
#include "assembleur.h"
#define TAILLE 1000

instruction instructions[TAILLE];
int index_instructions = 0;

void add_instruction(char *operation,int r1, int r2, int r3){
    struct instruction op;
    strcpy(op.operation, operation);
    op.r1 = r1;
    op.r2 = r2;
    op.r3 = r3;
    instructions[index_instructions] = op;
    index_instructions ++;
}


void write_all_instructions(){
    FILE * file_asm = fopen("asm.txt","w+");
    for (int i = 0; i < index_instructions; i++){
        if(strcmp(instructions[i].operation,"AFC") == 0){
            fprintf(file_asm,"%s | @ : %d | %d \n", instructions[i].operation, instructions[i].r1, instructions[i].r2);
        }
        else if(strcmp(instructions[i].operation,"LOAD") == 0 || strcmp(instructions[i].operation,"STORE") == 0|| strcmp(instructions[i].operation,"COP") == 0){
            fprintf(file_asm,"%s | @ : %d | @ : %d \n", instructions[i].operation, instructions[i].r1, instructions[i].r2);
        }
        else if(strcmp(instructions[i].operation,"JMF") == 0){
            fprintf(file_asm,"%s | @ : %d | %d \n", instructions[i].operation, instructions[i].r1, instructions[i].r2);
        }
        else if(strcmp(instructions[i].operation,"JMP") == 0){
            fprintf(file_asm,"%s |  %d \n", instructions[i].operation, instructions[i].r1);
        }
        else if(strcmp(instructions[i].operation,"PRI") == 0){
            fprintf(file_asm,"%s |  @: %d \n", instructions[i].operation, instructions[i].r1);
        }
        else{
            fprintf(file_asm,"%s | @ : %d | @ : %d |  @ : %d\n", instructions[i].operation, instructions[i].r1, instructions[i].r2, instructions[i].r3);
        }
    }
    fclose(file_asm);
}

int get_line_asm(){
    return index_instructions;
}

void patcher(int from , int to ){
    instructions[from].r2 = to ;
}
void patcher_else(int from , int to ){
    instructions[from].r1 = to ;
}


