cd C:\Users\User\OneDrive\Desktop\Mini-Compiler-With-Flex-and-Bison-master
bison -d 1707006.y
flex 1707006.l
gcc 1707006.tab.c lex.yy.c -o out
out
pause