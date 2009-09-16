/*
   Marcus Vinicius Ferreira
   CCO-NB2 02127044
   04/Set/2002

   ex2.c

   Contagem de letras dentro de uma palavra

*/

#include <stdio.h>

int main()
{
    int count=0;
    int i=0;
    char c;
    char palavra[100];


    /* Entrada dos valores
    */
    printf("Digite uma palavra: ");
    scanf("%s", &palavra);

    printf("Entre com uma letra: ");
    c = getche();

    /* Varre a string "palavra" até o final
       final: última letra = '\0'
    */
    while( palavra[i] != '\0')
    {
        /* Se 'c' é encontrado incrementa contagem */
        if( palavra[i] == c )
        {
            ++count;
        }
        /* Próxima letra da palavra */
        ++i;
    }

    /* Resultado */
    printf("\n   Resultados:");
    printf("\n       A letra %c foi digitada %d vezes",c,count);
    printf("\n       \n\n",y);

    return 0;
}