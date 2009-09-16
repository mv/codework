/*
   Marcus Vinicius Ferreira
   CCO-NB2 02127044
   11/Set/2002

   ex2.c

   Multiplicação de 2 números via função
   Retorna 2 valores (ponteiro modificam valores in situ)

*/

#include <stdio.h>

/* OBS: Implementando funções K&R */
m2( x, y )
   int *x;
   int *y;
{
    *x = *x * 2;
    *y = *y * 2;
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

    /* Multiplica os 2 números usando a função
       (usando &<variavel> os valores serão modificados in situ)
    */
    m2( &x, &y);

    /* Resultado */
    printf("\n   Resultados:");
    printf("\n       x = %d ",x);
    printf("\n       y = %d \n\n",y);

    return 0;
}