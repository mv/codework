/* $Id: b.c 6 2006-09-10 15:35:16Z marcus $
**
** Bloco main para uso do BubbleSort
**
** Marcus Vinicius Ferreira     Set/2003
**
*/


#include <stdio.h>
#include "vetor.h"

void printArray( long k[], int n);  // sub-programas
void BubbleSort( long k[], int n);

int main(void)
{
    int qtd = MAX ;

    printf("\nOrdenando: BubbleSort \n\n");
    printArray( valores, qtd ); //antes
    BubbleSort( valores, qtd );
    printArray( valores, qtd ); //depois

    return 0;
}
