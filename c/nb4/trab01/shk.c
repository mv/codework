/* $Id: shk.c 6 2006-09-10 15:35:16Z marcus $
**
** Bloco main para uso do BubbleSort
**
** Marcus Vinicius Ferreira     Set/2003
**
*/


#include <stdio.h>
#include "vetor.h"

// sub-programas
void BubbleSort( long k[], int n);
int  loadArray ( long k[], int n);

int main(void)
{

    int  qtd = MAX;     // quantidade


    printf("\nOrdenando: ShakerSort \n\n");
    printArray( valores, qtd ); //antes
    ShakerSort( valores, qtd );
    printArray( valores, qtd ); //depois

    return 0;
}
