%{
	#include "y.tab.h"
    #include <string.h>
    #include <stdio.h>
%}
%% 

"main" return tMAIN;
\{ return tACCOLADE_OUVRANTE;
\} return tACCOLADE_FERMANTE;
"const" return tCONST;
"int" return tINT;
"printf" return tPRINTF_VARIABLE;

"if"        return tIF;
"else"      return tELSE;
"while"     return tWHILE;
"return"    return tRETURN;
"=="        return tCMP;
"<"         return tINF;
">"         return tSUP;
"<="        return tINFEGALE;
">="        return tSUPEGALE;
"!="        return tNOTEGALE;

([a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|_)*  {yylval.variable = yytext;  return (tVAR_NAME);}
\( return tPARENTHESE_OUVRANTE;
\) return tPARENTHESE_FERMANTE;
\+ return tPLUS;
\- return tMOINS;
\* return tFOIS;
\/ return tDIVISER;
\= return tEGALE;
[" "|"	"|"\n"]+ ;
\, return tVIRGULE;
; return tPOINT_VIRGULE;
(\-?[0-9]+)|((\-?[0-9]+)e(\-?[0-9]+)) {
    if(strstr(yytext,"e") == NULL ){
        yylval.nombre =atoi(yytext);
        return (tENTIER);
    }
    else{
        char * nbr = strtok(yytext, "e");
        printf("nbr = %s",nbr);
        int nombre = atoi(nbr);
        char * exp = strtok(NULL, "");
        printf("exp = %s",exp);
        int expo = atoi(exp);
        for(int i = 0 ; i < expo ; i++ ){ //pb does not rcognise 0 in the end
            nombre = nombre * 10 ;
        }
        char * token = strtok(yytext, "e");
        yylval.nombre =nombre;
        return(tENTIER);
    }
}



%%

int yywrap(){
	return 1;
}

