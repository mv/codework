/*
** $Id: SelectionSort.c 6 2006-09-10 15:35:16Z marcus $
**
** SeleciontSort
**      trocando pelo minimo
**
*/

void SelectionSort (long k[], int n)
{
    int x,y;
    int tmp, min;

    for( x=0; x<=(n-2); x++ )
    {
        min = x; // local do menor valor
        for( y=x; y<=(n-1); y++ ){ // varre y procurando o menor valor
                                   // e vai ignorando a lista de x
            if( k[y] < k[min] )
            {
                min = y;    // valor encontrado
            } // end if

        } // end y

        tmp   = k[x] ;
        k[x]  = k[min] ;
        k[min]= tmp ;

    } // end x

} // end SelectionSort
