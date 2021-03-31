%{
	#include <stdio.h>
	#include "symbol.h"
	#include "instructions.h"
    void yyerror( char*);
	int yylex();
    char * VAR ; //temporoary var name
    char * VAR1 ;
    int entier ;
    int yylineno;
    int compteur_error = 0;
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


%verbose
%error-verbose

/* priorité */

%right tEGALE;
%left tPLUS tMOINS;
%left tFOIS tDIVISER;

%%

/* Non considéré les paramètres */

start :  tINT tMAIN tPARENTHESE_OUVRANTE tPARENTHESE_FERMANTE  Body {printf("main \n"); printSymbolTable();};

Body : tACCOLADE_OUVRANTE Phrase  tACCOLADE_FERMANTE;



/* only in calcul so we add it to the tmp */
EntierOuVar : tENTIER
            {
            printf("nombre : %d \n", yyval.nombre);
            pushTmp();
            asm_add_2(1,Tmp,yyval.nombre); //-1 means no need to use this reg in afc
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
            asm_add_2(5,Tmp,index);
            }
            ;

Var : tVAR_NAME {
    printf("varname: %s \n",yylval.variable );
    VAR = malloc(sizeof(yylval.variable)); // nom varaiable passé qu'une fois
    strcpy(VAR,yylval.variable);
};

Phrase : Phrase Phrase
	| tINT Def_VAR_INT tPOINT_VIRGULE /* declaration INT*/
	| Var  tEGALE  Calcul tPOINT_VIRGULE /* affectation */
    {
    printf("affectationAvecCalcul \n");
    if(findSymbol(VAR) == -1){
        compteur_error ++ ;
        yyerror("Varaible has not been declared");
    }
    int index = findSymbol(VAR);
    setInitialised(VAR);
    asm_add_2(5,index,Tmp);
    popTmp();
    }
	| tPRINTF_VARIABLE tPARENTHESE_OUVRANTE tVAR_NAME tPARENTHESE_FERMANTE tPOINT_VIRGULE {printf("printf \n");}
	|
    ;



Calcul : tPARENTHESE_OUVRANTE Calcul tPARENTHESE_FERMANTE
    |Calcul tPLUS Calcul
        {
        printf("plus \n");
        asm_add_3(1,Tmp-1,Tmp,Tmp-1); //add and put the result in the top of the tmp
        popTmp() ;
        }
    |Calcul tMOINS Calcul
        {
        printf("moins \n");
        asm_add_3(3,Tmp-1,Tmp-1,Tmp);
        popTmp() ;
        }
    |Calcul tFOIS Calcul
        {
        printf("fois \n");
        asm_add_3(2,Tmp-1,Tmp-1,Tmp);
        popTmp() ;
        }
    |Calcul tDIVISER Calcul
        {
        printf("diviser \n");
        asm_add_3(4,Tmp-1,Tmp-1,Tmp);
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
            asm_add_2(6,findSymbol(VAR),entier);
            free(VAR);
            }
            | Def_VAR_INT tVIRGULE Def_VAR_INT
            ;

%%

void yyerror( char* str) {
    extern int yylineno;
    compteur_error ++ ;
    fprintf(stderr, "ERROR yyparse : %d: %s\n", yylineno, str);
}
int main() {
    asm_init();
    yyparse();
    asm_run();
    return 0;
}
