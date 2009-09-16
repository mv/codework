/* $Id: printArray.c 6 2006-09-10 15:35:16Z marcus $
**
** Imprime <n> elementos do parametro array
**
** Marcus Vinicius Ferreira     Set/2003
**
*/

# include <stdio.h>

void printArray( long a[], int n )
{
    int i;

    printf("Array ---\n");

    for( i=0; i<=n-1; i++ )
    {
        printf ("%4d ", (int) a[i] );
    }

    printf ("\n\n");
}
