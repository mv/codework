/*
** $Id: loadArray.c 6 2006-09-10 15:35:16Z marcus $
**
** loadArray
**      Carrega arquivo de numeros (1 por linha) no array
**
** Marcus Vinicius Ferreira Set/2003
**
*/

#include <stdio.h>
#include <stdlib.h>

int loadArray (long k[], int n)
{
    FILE *fh;
    int  i=0;
    char line[80];

    fh = fopen("list.txt","r");
    if ( fh==NULL)
    {
        printf("\n\n   Erro abrindo arquivo \n");
        return 1;
    }

    while( i<n )    // le <n> no.s requisitados
    {

        // fim do arquivo
        if ( feof(fh) )
        {
            break;
        }

        // le valor e carrega no array
        fscanf(fh, "%s\n", line);
        k[i] = atol(line);  // "asc to long"
        i++;
    } //end while

    printf("\n\nNo.s lidos: %d \n\n", i);

    if ( fclose(fh) )
    {
        printf("\n\n   Erro fechando aquivo \n\n");
        return 2;
    }

    return 0;
}
