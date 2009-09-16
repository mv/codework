/* $Id: recursive.c 6 2006-09-10 15:35:16Z marcus $
**
** Linguagem de Programacao II / Calebe
**
** Exercicios: no. 5 - Funcoes recursivas
**      menor, maior, soma e media de um vetor
**
** Marcus Vinicius Ferreira     Set/2003
** 02127044 - CCO-DDS-NB4 - VO
**
*/


#include <stdio.h>

int  Menor( long item[], int n);
int  Maior( long item[], int n);
int  Soma ( long item[], int n);
int  Media( long item[], int n);
void printArray( long item[], int n);

int main(void)
{
       //   8:   0  1  2  3  4  5  6  7
    long a[]= { 92,12,-2,25,57,15,23,-1};       // lista
//  long a[]= { 50,50,50,50}; //,50,50,50,50};       // lista
    int qtd = 8;

    printf("\nRecursive: \n\n");
    printArray( a, qtd );

    printf("Resultados ---\n");
    printf("   Menor : %3d \n", Menor( a, qtd) );
    printf("   Maior : %3d \n", Maior( a, qtd) );
    printf("    Soma : %3d \n", Soma ( a, qtd) );
    printf("   Media : %3d \n", Media( a, qtd) );

    return 0;
}

int Menor( long item[], int n)                     //  item[n]     n      return
{                                                  //
    int num;                                       //  0:   92     0        92
                                                   //  1:   12     1        12
    if ( n==0 ) {                                  //  2:   -2     2        -2
        return( item[0] );                         //  3:   45     3        -2
    }                                              //  4:   57     4        -2
                                                   // etc...
    n--;
    num = Menor( item, n ); // recursao: traz no. "anterior"
    if (item[n] < num) {
        num = item[n];      // Sobrepoe se menor
    }                       // [senao] mantem no. "anterior"

    return(num);            // retorna [ "o anterior" | "o trocado" ]
}

int Maior( long item[], int n)
{
    int num;

    if ( n==0 ) {
        return( item[0] );
    }

    n--;
    num = Maior( item, n );
    if (item[n] > num) {
        num = item[n];      // Sobrepoe se maior
    }                       // [senao] mantem no. "anterior"

    return(num);            // retorna [ "o anterior" | "o trocado" ]
}

int Soma ( long item[], int n)                     //  item[n]     n      return
{                                                  //
    int num;                                       //  0:   92     0         0
//  int tmp;                                       //  1:   12     1        92 + 12 = 104
    if ( n==0 ) {                                  //  2:   -2     2       104 - 02 = 102
        return( 0 );                               //  3:   45     3       102 + 45 = 147
    }                                              //  4:   57     4       147 + 57 = 204
                                                   // etc...
    n--;
//  tmp = Soma( item, n );
//  num = tmp + item[n];
    num = Soma( item, n ) + item[n];    // soma restante da lista + item atual
    return(num);
}

int Media( long item[], int n)
{
    int num;
    int tmp;

//  n--;
//  tmp = Media( item, n );
//  num = (tmp + item[n])/n;

    num =  Soma( item, n ) /n ;         // !!!?! (Soma já é recursivo :D )

    return(num);

}
