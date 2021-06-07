cd C:\Users\User\OneDrive\Desktop\Compiler_Project
bison -d 1707006.y
flex 1707006.l
gcc 1707006.tab.c lex.yy.c -o out
out
pause