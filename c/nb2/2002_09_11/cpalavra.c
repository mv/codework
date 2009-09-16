/*
   cpalavra.c
*/

char cpalavra(a,b)
  char *a;
  char *b;
{
    int i;
    for (i=0; a[i] != '0'; i++)
    {
        if ( a[i] != b[i] )
            break;
    }

    if ( a[i] == b[i] && b[i] == '\0' )
        return 1;
    else
        return 0;
}
