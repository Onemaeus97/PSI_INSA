exec: y.tab.c lex.yy.c symbol.c assembleur.c
	gcc y.tab.c lex.yy.c symbol.c assembleur.c -o exec

y.tab.c: yacc.y
	yacc -d yacc.y

lex.yy.c: lexx_V2.1.lex
	flex lexx_V2.1.lex


clean:
	rm *.o
	rm Monexe

