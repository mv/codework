/* $Id: ex_01_06.c 6 2006-09-10 15:35:16Z marcus $
**
** Linguagem de Programacao II / Calebe
**
** Exercicios: no. 6
**
*/


#include <stdio.h>

float  recursivo ( int n);
float  interativo( int n);

int main(void)
{

    printf("\nRecursivo: \n");
    printf("  4: %10.5f \n", recursivo(4) );
    printf(" 10: %10.5f \n", recursivo(10) );
    printf(" 12: %10.5f \n", recursivo(12) );

    printf("\nInterativo: \n");
    printf("  4: %10.5f \n", interativo(4) );
    printf(" 10: %10.5f \n", interativo(10) );
    printf(" 12: %10.5f \n", interativo(12) );

    return 0;
}

float  recursivo ( int n )
{
    float soma = 0.0;

    if ( n == 1) {
        return(1.0);
    }
    n--;
    soma = recursivo(n) + 1.0/(float)n;
    return soma;
}

float  interativo( int n)
{
    float soma = 1.0;
    int     i;
    float   j=0.0;

    for ( i=1; i<n ; i++ )
    {
        j += 1.0;
        soma += 1.0 / j ;
    }
    return (float)soma;
}
