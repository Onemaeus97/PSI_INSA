%{
	#include <stdio.h>
	#include "symbol.h"
	#include "assembleur.h"
    void yyerror( char*);
	int yylex();
    char * VAR ; //temporoary var name
    char * VAR1 ;
    int entier ;
    int yylineno;
    int compteur_error = 0;
    int index_label = 0 ;
    int label[max_instructions];
    int index_while = 0 ;
    int label_while[max_instructions];
    void patch(int from, int to){
        label[from] = to ;
    }
	%}

/* Terminales */

%union {
    char * variable;
    int nombre;
}
%token <nombre> tENTIER
%token <variable> tVAR_NAME
%token tMAIN ;
%token tPARENTHESE_OUVRANTE tPARENTHESE_FERMANTE;
%token tACCOLADE_OUVRANTE tACCOLADE_FERMANTE;
%token tCONST tINT ;
%token tPLUS tMOINS tFOIS tDIVISER tEGALE;
%token tESPACE tVIRGULE tPOINT_VIRGULE ;
%token tPRINTF_VARIABLE;
%token tIF tELSE tWHILE tRETURN tCMP tINF tSUP tINFEGALE tSUPEGALE tNOTEGALE;

%verbose
%error-verbose

/* priorité */

%right tEGALE;
%left tPLUS tMOINS;
%left tFOIS tDIVISER;
%right tELSE;

%%

/* Non considéré les paramètres */

start :  tINT tMAIN tPARENTHESE_OUVRANTE tPARENTHESE_FERMANTE  Body {printf("main \n"); printSymbolTable();};

Body : tACCOLADE_OUVRANTE Phrase  tACCOLADE_FERMANTE;


/* only in calcul so we add it to the tmp */
EntierOuVar : tENTIER
            {
            printf("nombre : %d \n", yyval.nombre);
            pushTmp();
            add_instruction("AFC",Tmp,yyval.nombre,-1);
            }
            | tVAR_NAME
            {
            printf("varname: %s \n",yylval.variable );
            if(findSymbol(yylval.variable) == -1){
                compteur_error ++ ;
                yyerror("Varaible has not been declared");
            }
            int index = findSymbol(yylval.variable);
            pushTmp();
            add_instruction("COP",Tmp,index,-1);
            }
            ;

Var : tVAR_NAME {
    printf("varname: %s \n",yylval.variable );
    VAR = malloc(sizeof(yylval.variable)); // nom varaiable passé qu'une fois
    strcpy(VAR,yylval.variable);
};

Phrase : Phrase Phrase
	| tINT Def_VAR_INT tPOINT_VIRGULE /* declaration INT*/
    | tCONST tINT Def_VAR_CONST_INT tPOINT_VIRGULE /* declaration CONST*/
    | If_else
    | While
	| Var  tEGALE  Calcul tPOINT_VIRGULE /* affectation */
    {
    printf("affectationAvecCalcul \n");
    if(findSymbol(VAR) == -1){
        compteur_error ++ ;
        yyerror("Varaible has not been declared");
    }
    else if (isConstant(VAR)){
        compteur_error ++ ;
        yyerror("Error : intent to change a constant");
    }
    int index = findSymbol(VAR);
    setInitialised(VAR);
    add_instruction("COP",index,Tmp,-1);
    popTmp();
    }
	| tPRINTF_VARIABLE tPARENTHESE_OUVRANTE Var tPARENTHESE_FERMANTE tPOINT_VIRGULE
    {
        add_instruction("PRI",findSymbol(VAR),-1,-1);
    }
    |
    ;


Calcul : tPARENTHESE_OUVRANTE Calcul tPARENTHESE_FERMANTE
    |Calcul tPLUS Calcul
        {
        printf("plus \n");
        add_instruction("ADD",Tmp+1,Tmp,Tmp+1); //add and put the result in the top of the tmp
        popTmp() ;
        }
    |Calcul tMOINS Calcul
        {
        printf("moins \n");
        add_instruction("SOU",Tmp+1,Tmp+1,Tmp);
        popTmp() ;
        }
    |Calcul tFOIS Calcul
        {
        printf("fois \n");
        add_instruction("MUL",Tmp+1,Tmp+1,Tmp);
        popTmp() ;
        }
    |Calcul tDIVISER Calcul
        {
        printf("diviser \n");
        add_instruction("DIV",Tmp+1,Tmp+1,Tmp);
        popTmp() ;
        }
    |EntierOuVar
    ;

Entier : tENTIER{
    printf("nombre : %d \n", yyval.nombre);
    entier = yyval.nombre;
}

/* Plural declarations INT */
Def_VAR_INT: Var
            {
            printf("declarationSimple  \n");
            if(findSymbol(VAR) != -1){
                compteur_error ++ ;
                yyerror("Varaible has already been declared");
            }
            pushSymbol(VAR, false,false, INT);
            //printSymbolTable();
            free(VAR);
            }
            |Var tEGALE Entier
            {
            printf("declarationAvecAffectation \n" );
            if(findSymbol(VAR) != -1){
                compteur_error ++ ;
                yyerror("Varaible has already been declared");
            }
            pushSymbol(VAR, false,true, INT);
            add_instruction("AFC",findSymbol(VAR),entier,-1);
            free(VAR);
            }
            | Def_VAR_INT tVIRGULE Def_VAR_INT
            ;

/* Plural declarations CONST INT */
Def_VAR_CONST_INT : Var
                    {
                    printf("declarationSimple_CONST  \n");
                    if(findSymbol(VAR) != -1){
                        compteur_error ++ ;
                        yyerror("Varaible has already been declared");
                    }
                    pushSymbol(VAR, true,false, INT);
                    //printSymbolTable();
                    free(VAR);
                    }
                    |Var tEGALE Entier
                    {
                    printf("declarationAvecAffectation_CONST \n" );
                    if(findSymbol(VAR) != -1){
                        compteur_error ++ ;
                        yyerror("Varaible has already been declared");
                    }
                    pushSymbol(VAR, true,true, INT);
                    add_instruction("AFC",findSymbol(VAR),entier,-1);
                    free(VAR);
                    }
                    | Def_VAR_CONST_INT tVIRGULE Def_VAR_CONST_INT
                    ;


Condition : Calcul tINF Calcul
            {
                printf("tINF \n");
                add_instruction("INF",Tmp+1, Tmp+1, Tmp);
                popTmp();
                index_label ++ ;
                label[index_label] = get_line_asm(); //label comme une sorte de pile - last in first out
                add_instruction("JMF",Tmp,-1,-1); //-1 car on ne sait pas
                popTmp();
            }
            |Calcul tSUP Calcul
            {
                printf("tSUP \n");
                add_instruction("SUP",Tmp+1, Tmp+1, Tmp);
                popTmp();
                index_label ++ ;
                label[index_label] = get_line_asm(); //label comme une sorte de pile - last in first out
                add_instruction("JMF",Tmp,-1,-1); //-1 car on ne sait pas
                popTmp();
            }
            |Calcul tCMP Calcul
            {
                printf("tCMP \n");
                add_instruction("CMP",Tmp+1, Tmp+1, Tmp);
                popTmp();
                index_label ++ ;
                label[index_label] = get_line_asm(); //label comme une sorte de pile - last in first out
                add_instruction("JMF",Tmp,-1,-1); //-1 car on ne sait pas
                popTmp();
            }
            |Calcul tINFEGALE Calcul
            {
                printf("tINFEGLE \n");
                add_instruction("INF",Tmp-1, Tmp+1, Tmp);
                add_instruction("CMP",Tmp, Tmp+1, Tmp);
                add_instruction("ADD",Tmp+1, Tmp-1, Tmp);
                popTmp();
                index_label ++ ;
                label[index_label] = get_line_asm(); //label comme une sorte de pile - last in first out
                add_instruction("JMF",Tmp,-1,-1); //-1 car on ne sait pas
                popTmp();
            }
            |Calcul tSUPEGALE Calcul
            {
                printf("tSUPEGALE \n");
                add_instruction("SUP",Tmp-1, Tmp+1, Tmp);
                add_instruction("CMP",Tmp, Tmp+1, Tmp);
                add_instruction("ADD",Tmp+1, Tmp-1, Tmp);
                popTmp();
                index_label ++ ;
                label[index_label] = get_line_asm(); //label comme une sorte de pile - last in first out
                add_instruction("JMF",Tmp,-1,-1); //-1 car on ne sait pas
                popTmp();
            }
            |Calcul tNOTEGALE Calcul
            {
                printf("tNOTEQUAL \n");
                add_instruction("CMP", Tmp+1, Tmp+1, Tmp);
                add_instruction("AFC", Tmp, 0, -1);
                add_instruction("CMP", Tmp+1, Tmp+1,Tmp);
                popTmp();
                index_label ++ ;
                label[index_label] = get_line_asm(); //label comme une sorte de pile - last in first out
                add_instruction("JMF",Tmp,-1,-1); //-1 car on ne sait pas
                popTmp();
            }
            ;


If_else:
     tIF tPARENTHESE_OUVRANTE Condition tPARENTHESE_FERMANTE Body{
        printf("finition if statement , pas surement dans la bonne place\n"); //afficher à la fin d'accolade if
        int line =get_line_asm();
        patcher( label[index_label], line); //patcher la table avec l'index de cette ligne +1, on a un décalage de 1 déjà car get _line compte les lignes à partir de 1
        index_label -- ; //décrementer index_label, c'est à dire que pour cet index , on a patché, plus rien à inquieter
     }
     
    | tIF  tPARENTHESE_OUVRANTE Condition tPARENTHESE_FERMANTE Body tELSE
    {
        printf("finition if statement with else\n");  //afficher à la fin d'accolade
        int line =get_line_asm();
        patcher( label[index_label], line+1); //patcher avec une ligne en plus
        index_label -- ;
        printf("else statement \n");
        index_label ++ ;
        label[index_label] = get_line_asm();
        add_instruction("JMP",-1,-1,-1);
        
    }
    Body {
        int line =get_line_asm();
        patcher_else(label[index_label], line);
        index_label -- ;
    }
    ;




While:
    tWHILE {
        printf("while statement \n");
        index_while ++;
        label_while[index_while] = get_line_asm() ;
    }
    tPARENTHESE_OUVRANTE Condition tPARENTHESE_FERMANTE Body
    {
        int line =get_line_asm();
        patcher(label[index_label], line+1);
        add_instruction("JMP",label_while[index_while],-1,-1);
        index_label -- ;
        index_while --;
    }
;



%%

void yyerror( char* str) {
    extern int yylineno;
    compteur_error ++ ;
    fprintf(stderr, "ERROR yyparse : %d: %s\n", yylineno, str);
}
int main() {
    yyparse();
    write_all_instructions_for_human();
    write_all_instructions_for_machine();
    return 0;
}
