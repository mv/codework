/*
   Marcus Vinicius Ferreira
   CCO-NB2 02127044
   04/Set/2002

   ex1.c

   Posição da 1a. letra 'A' dentro da palavra

*/

#include <stdio.h>

int main()
{
    int i=0;
    char palavra[100];


    /* Entrada dos valores
    */
    printf("Digite uma palavra: ");
    scanf("%s", &palavra);

    /* Varre a string "palavra" até o final
       final: última letra = '\0'
    */
    while( palavra[i] != '\0' || palavra[i] != 'A')
    {
        /* Próxima letra da palavra */
        ++i;
    }

    /* Loop: confere se saiu 1) porque encontrou 'A'
                             2) porque é final
             i está parado na posição desejada da palavra
    */
    if ( palavra[i] = 'A' )
        printf ("\n\n A letra 'A' foi encontrada na posição %d.\n",i);

    if ( palavra[i] = '\0' )
        printf ("\n\n Não foi encontrada nenhuma letra A \n");


    return 0;
}