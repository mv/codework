/*
** $Id: InsertionSort.c 6 2006-09-10 15:35:16Z marcus $
**
** InsertiontSort
**      desloca o array para achar uma posicao
**
*/

void InsertionSort (long k[], int n)
{
    int x,y;
    int num;

    for( x=1; x<=(n-1); x++ )   // do 2o. ao final
    {

        num = k[x];     // num para comparar/deslocar

        for ( y=x ; k[y-1]> num && y>0; y-- )   // parar: qdo acha um num menor
        {                                       // ou qdo voltou ao inicio do array
            k[y] = k[y-1];      // desloca `a D

        } // end y

        k[y] = num;   // posiciona o num. salvo

    } // end x

} // end InsertionSort
