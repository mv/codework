/* $Id: b_0.c 6 2006-09-10 15:35:16Z marcus $
**
** Bloco main para uso do BubbleSort
**
** Marcus Vinicius Ferreira     Set/2003
**
*/


#include <stdio.h>

void printArray( long k[], int n);  // sub-programas
void BubbleSort( long k[], int n);

int main(void)
{

    long a[] = { 32,27,12,97,51,15,01 }; // para ordenar
    int  qtd = 7;                        // quantidade

    printf("\nOrdenando: BubbleSort \n\n");
    printArray( a, qtd ); //antes
    BubbleSort( a, qtd );
    printArray( a, qtd ); //depois

    return 0;
}
