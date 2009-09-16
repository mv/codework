/*
** mycat
**   implements cat <filename>
*/

#include <stdio.h>

char _id[] = "$Id: mycat.c 6 2006-09-10 15:35:16Z marcus $";

#ifndef DEBUG
#define DEBUG 0
#else
#define DEBUG 1
#endif

int main( int argc, char *argv[] )
{
    FILE *fh;
    char ch;

#if DEBUG
    printf("\n  No. of parameters : %d \n", argc);
    printf("\n  File: %s\n",argv[1] );
#endif

    if (argc<2){
        printf("\n  Usage: mycat <filename>\n");
        return 1;
    }

    //Open file
    fh = fopen(argv[1],"rb");
    if (fh==NULL){
        printf("\n  Cannot open file: %s\n",argv[1]);
        return 2;
    }

    //File Ok: print contents
    printf("===============\n");
    printf("%s\n", argv[1] );
    printf("===============\n");

    ch=getc(fh);
    while ( ch!=EOF ) {
        putchar(ch);
        ch = getc(fh);
    } ;

    fclose(fh);
    return 0;

    /*
    Outra versao:
    do {
        ch = getc(fh);
        putchar(ch);    // acaba imprimindo EOF
    } while(ch!=EOF);
    */
}
