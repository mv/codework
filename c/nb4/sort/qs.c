/* $Id: qs.c 6 2006-09-10 15:35:16Z marcus $
**
** Bloco main para uso do SelectSort
**
** Marcus Vinicius Ferreira     Set/2003
**
*/


#include <stdio.h>

int  loadArray ( long k[], int n);  // sub-programas
void printArray( long k[], int n);
void QuickSort ( long item[], int left, int right);

int main(void)
{

    long a[5000];       // no.s no arquivo
    int  qtd = 5000;     // quantidade
    int  err;           // codigo de erro

    err = loadArray( a, qtd );
    if ( err )
    {
        printf("\n\n   Erro carregando array \n\n");
        return 1;
    }

    printf("\nOrdenando: QuickSort \n\n");
 // printArray( a, qtd ); //antes
    QuickSort ( a, 0, qtd );
 // printArray( a, qtd ); //depois

    return 0;
}
