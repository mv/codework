/*
   Marcus Vinicius Ferreira
   CCO-NB2 02127044
   11/Set/2002

   ex4.c

   Soma/Concatena 2 strings via função
*/

/* Interface estilo K&R */
somapalavra(a,b,c)
  char *a, *b, *c;
{
    int i,j;

    /* Varre a string "a" do início ao fim
    */
    for (i=0; a[i] != '\0'; i++)
    {
        /* Copia a em c */
        c[i] = a[i];
    }

    /* Varre a string "b" do início ao fim
    */
    for (j=0; b[j] != '\0'; j++)
    {
        /* coloca b no final de c (concatena!!!) */
        c[i++] = b[j];
    }

    /* Indica o final de "c" */
    c[i] = '\0';

}

int main()
{
    char s1[50];
    char s2[50];

    char s3[100];

    /* Entrada dos valores
    */

    printf("Digite string1 [tam 50] ");
    scanf("%s", &s1);

    printf("Digite string2 [tam 50] ");
    scanf("%s", &s2);

    /* Concatena as strings s1 e s2
       resultado em s3
    */
    somapalavra(&s1, &s2, &s3);

    /* Resultado */
    printf("\n   Concatenado = [%s] \n\n",s3);

    /* FIM */
    return 0;
}