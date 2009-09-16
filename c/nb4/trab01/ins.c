/* $Id: ins.c 6 2006-09-10 15:35:16Z marcus $
**
** Bloco main para uso do SelectSort
**
** Marcus Vinicius Ferreira     Set/2003
**
*/


#include <stdio.h>
#include "vetor.h"

// sub-programas
void printArray( long k[], int n);
void InsertionSort( long k[], int n);

int main(void)
{

    int  qtd = MAX;     // quantidade

    printf("\nOrdenando: InsertionSort \n\n");
    printArray( valores, qtd ); //antes
    InsertionSort( valores, qtd );
    printArray( valores, qtd ); //depois

    return 0;
}
