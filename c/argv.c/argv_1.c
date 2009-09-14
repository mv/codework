/*
** $Id: argv_1.c 6 2006-09-10 15:35:16Z marcus $
**
** argv is an array of pointers
** argv[i] is a pointer to a null terminated string
**
** printf( "%s", argv[i] );  -- prints the string
**
*/

#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char *argv[])
{
    int i;

    printf("\n\nCommand line arguments: %d \n\n", argc);

    for ( i=0 ; i < argc ; i++ )
    {
        printf("      %d : %s\n", i, argv[i] );
    }

    exit(0);
}
