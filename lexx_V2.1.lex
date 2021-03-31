%{
	#include "y.tab.h"
%}
%% 

"main" return tMAIN;
\{ return tACCOLADE_OUVRANTE;
\} return tACCOLADE_FERMANTE;
"const" return tCONST;
"int" return tINT;
"printf" return tPRINTF_VARIABLE;
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
(\-?[1-9]+)|((\-?[1-9]+)e(\-?[1-9]+))  {yylval.nombre =atoi(yytext);return (tENTIER);}
%%

int yywrap(){
	return 1;
}

