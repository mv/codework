/*
** mycat
**   implements cat <filename>
*/

#include <stdio.h>

char _id[] = "$Id: mycat2.c 6 2006-09-10 15:35:16Z marcus $";

#ifndef DEBUG
#define DEBUG 0
#else
#define DEBUG 1
#endif

int cat( char *filename);

int main( int argc, char *argv[] )
{
    FILE *fh;
    char ch;
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
        //Open file
        fh = fopen(argv[i],"rb");
        if (fh==NULL){
            printf("\n  Cannot open file: %s\n",argv[i]);
            return 2;
        }

        if (argc>2){
            // Puts a separator between more than 1 file
            printf("===============\n");
            printf("%s\n", argv[i] );
            printf("===============\n");
        }

        //File Ok: print contents
        ch=getc(fh);
        while ( ch!=EOF ) {
            putchar(ch);
            ch = getc(fh);
        } ;

        fclose(fh);
    }

    //END
    return 0;

    /*
    Outra versao:
    do {
        ch = getc(fh);
        putchar(ch);    // acaba imprimindo EOF
    } while(ch!=EOF);
    */
}
