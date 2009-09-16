/*
   Marcus Vinicius Ferreira
   CCO-NB2 02127044
   11/Set/2002

   ex3.c

   Compara 2 strings via função
*/

/* Interface estilo K&R */
char cpalavra(a,b)
  char *a;
  char *b;
{
    int i;
    /* Loop:
            Do início ao fim de 'a'
    */
    for ( i=0; a[i] != '\0'; i++)
    {
        /* Qq valor diferente em qq posição quebra o loop,
           i.e. , as palavras não são iguais
        */

        if ( a[i] != b[i] )
            break;
    }

    /* Descobre o ponto de saída do Loop:
       se foi por IGUALDADE e no FINAL de b => IGUAIS
       senão => DIFERENTES
    */
    if ( a[i] == b[i] && b[i] == '\0' )
        return 1;
    else
        return 0;
}

int main()
{
    char s1[50];
    char s2[50];

    /* Entrada dos valores
    */

    printf("Digite string1 [tam 50] ");
    scanf("%s", &s1);

    printf("Digite string2 [tam 50] ");
    scanf("%s", &s2);

    /* Compara as strings
    */
    if ( cpalavra( &s1, &s2 ) == 1 )
        printf("\n   IGUAIS \n\n ");
    else
        printf("\n   DIFERENTES \n\n ");


    /* FIM */
    return 0;
}