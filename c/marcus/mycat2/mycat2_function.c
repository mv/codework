/*
** mycat
**   implements cat <filename>
*/

#include <stdio.h>

char _id[] = "$Id: mycat2_function.c 6 2006-09-10 15:35:16Z marcus $";

#ifndef DEBUG
#define DEBUG 0
#else
#define DEBUG 1
#endif

int cat( char *filename);
FILE *fh;
char ch;

int main( int argc, char *argv[] )
{
    int  i;

    if (argc<2){
        printf("\n  Usage: mycat <filename>\n");
        return 1;
    }

#if DEBUG
    printf("\n  No. of parameters : %d \n", argc);
    for ( i=1; i<argc; i++ ) {
        printf("  File: %s\n",argv[i] );
    }
#endif

    //Process list of files
    for ( i=1; i<argc; i++ ) {
        cat ( &argv[i] );
    }

    return 0;

    /*
    Outra versao:
    do {
        ch = getc(fh);
        putchar(ch);    // acaba imprimindo EOF
    } while(ch!=EOF);
    */
}

int cat (char *filename) {

    //Open file
    fh = fopen( filename, "rb");
    if (fh==NULL){
        printf("\n  Cannot open file: %s\n",filename );
        return 2;
    }

    //File Ok: print contents
    printf("===============\n");
    printf("%s\n", filename   );
    printf("===============\n");

    ch=getc(fh);
    while ( ch!=EOF ) {
        putchar(ch);
        ch = getc(fh);
    } ;

    fclose(fh);
}