/*
** $Id: argv_2.c 6 2006-09-10 15:35:16Z marcus $
**
** obfuscated variation
**
*/


#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char *argv[])
{
    int i;

    printf("\n\n");
    printf("Command line arguments: %d \n\n", argc);

    for ( i=0 ; argv[i]!=NULL ; i++ )   // NULL pointer makes final of argv[]
    {
        printf("      %d: ",i);
        while( *argv[i] )               // '\0' makes while exit
        {
            putchar( *(argv[i]++) );    // pointer address + 1
        }
        printf("\n");
    }

    exit(0);
}
