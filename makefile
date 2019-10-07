OFILES= assign.o read.o write.o gen_infix.o finish.o declare.o
pascal: SPparser.tab.c lex.yy.c $(OFILES)
	g++ $(OFILES) SPparser.tab.c lex.yy.c -lfl -o pascal
lex.yy.c: SPscanner.l
	flex SPscanner.l
SPparser.tab.c:  SPparser.y
	bison --defines=pascal.tab.h SPparser.y 
parser.y.c:g++ -c  $<

clean :
	rm pascal *.o
