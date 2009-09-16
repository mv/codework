/*
     somapalavra.c
*/

somapalavra(a,b,c)
  char *a, *b, *c;
{
    int i,j;

    for (i=0; a[i] != '\0'; i++)
    {
        c[i] = a[i];
    }

    for (j=0; b[j] != '\0'; j++);
    {
        c[i++] = b[j];
    }

    c[i] = '\0';

}