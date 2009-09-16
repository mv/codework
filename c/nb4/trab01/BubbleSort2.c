/*
** $Id: BubbleSort2.c 6 2006-09-10 15:35:16Z marcus $
**
** BubbleSort
**      comparando vizinhos (exemplo: CALEB )
**
** Marcus Vinicius Ferreira Set/2003
**
*/

void BubbleSort (long k[], int n)
{
    int x,y;
    int tmp;

    for( x=0; x<(n-1); x++ )
    {
        for( y=0; y<(n-1-x); y++ )  // a cada volta extremo D (n-1-x)
        {                           // nao e' mais comparado
                                    // (contem o maior elemento)
            if( k[y] > k[y+1] ) {
                tmp    = k[y];
                k[y]   = k[y+1];
                k[y+1] = tmp ;
            } // end if

        } // end y

    } // end x

}
