#include <stdio.h>

int m2(x,y)
  int *x;
  int *y;
{
    *x = *x * 2;
    *y = *y * 2';
}

int main (void)
{
    /* Valores */
    int x,y;
    printf("Entre com x:");
    scanf("%d",&x);
    printf("Entre com y:");
    scanf("%d",&y);

    /* Calcula e retorna 2 valores simultaneament */
    m2( &x, &y );

    /* Resultados */
    printf ("\n   Valores x = %d, y = %d \n\n", x,y);
    return 0;
}
