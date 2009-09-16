/*
   Marcus Vinicius Ferreira
   CCO-NB2 02127044
   11/Set/2002

   ex1.c

   Soma de 2 números via função

*/

#include <stdio.h>

/* OBS: Implementando funções ANSI */
int soma(int x, int y)
{
    int z;

    z = x + y;
    return ( z );
}

int main()
{
    int x,y,z;

    /* Entrada dos valores
    */
    printf("Entre com o valor de x: ");
    scanf("%d", &x);

    printf("Entre com o valor de y: ");
    scanf("%d", &y);

    /* Faz a soma usando a função
    */
    z = soma(x,y);

    /* Resultado */
    printf("\n   Soma: x + y = %d \n\n",z);

    return 0;
}