/*
 * $Id: ShakerSort.c 6 2006-09-10 15:35:16Z marcus $
 *
 * ShakerSort
 *      Recolocando MIN e MAX por iteracao
 *
 */

void ShakerSort (long k[], int n)
{
    int x,y;            // loops de transversao
    int tmp, min, max;  // de trabalho
    int i=n-1;      // Extremo D

    for( x=0; x<(n-x-2); x++ )
    {
        min = x;
        max = x;
        for( y=x+1; y<(n-x-1); y++ )
        {
            if( k[y] < k[min] )
            {
                min = y;        // guarda a posicao do minimo
            } // end if

            if( k[y] > k[max] )
            {
                max = y;        // guarda a posicao do maximo
            } // end if

        } // end for;

        //Poe o minimo no extremo E (q nem BubbleSort)
        tmp = k[min];
        k[min] = k[x];
        k[x] = tmp;

        //Poe o maximo no extremo D
        tmp = k[max];
        k[max] = k[y];
        k[y] = tmp;

    } // end x

}
