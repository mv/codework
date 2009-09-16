/* $Id: ex_01_07.c 6 2006-09-10 15:35:16Z marcus $
**
** Linguagem de Programacao II / Calebe
**
** Exercicios: no. 7
**
*/


#include <stdio.h>

int  mdcr ( int x, int y);
int  mdci ( int x, int y);

int main(void)
{

    printf("\nRecursivo: \n");
    printf(" mdcr( 5,1)= %d\n", mdcr( 5,1) );
    printf(" mdcr(10,2)= %d\n", mdcr(10,2) );
    printf(" mdcr(12,3)= %d\n", mdcr(12,3) );
    printf(" mdcr(12,6)= %d\n", mdcr(12,6) );
    printf(" mdcr(8,12)= %d\n", mdcr(8,12) );

    printf("\nIterativo: \n");
    printf(" mdci( 5,1)= %d\n", mdci( 5,1) );
    printf(" mdci(10,2)= %d\n", mdci(10,2) );
    printf(" mdci(12,3)= %d\n", mdci(12,3) );
    printf(" mdci(12,6)= %d\n", mdci(12,6) );
    printf(" mdci(8,12)= %d\n", mdci(8,12) );

    return 0;
}

int  mdcr ( int x, int y)
{

    if ( x < y) {
        return mdcr(y,x);
    }
    if ( (y <= x) && (x % y == 0) ) {
        return(y);
    }
    x--;
    return ( mdcr(x,y) );
}

int  mdci ( int x, int y)
{

    int tmp, i;

    if ( x < y) {
        return mdci(y,x);
    }

    for( i=x; i>=1; i--)
    {
        if ( (y <= i) && (i % y == 0) ) {
            tmp = i;
        }
    }
    return ( tmp );
}
