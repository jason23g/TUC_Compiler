bison -d -v -r all myanalyzer.y
flex mylexer.l
gcc -o mycompiler myanalyzer.tab.c lex.yy.c cgen.c -lfl
./mycompiler < correct1.pi > correct1.c
gcc -o correct1 -std=c99 -Wall correct1.c
./correct1