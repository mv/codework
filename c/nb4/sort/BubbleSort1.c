/*
** $Id: BubbleSort1.c 6 2006-09-10 15:35:16Z marcus $
**
** BubbleSort
**      comparando extremos
**
*/

void BubbleSort (long k[], int n)
{
    int  x,y;
    long tmp;

    for( x=0; x<=(n-2); x++ )
    {
        for( y=x+1; y<=(n-1); y++ )  // Menor fica `a E e move
        {                            // ref da E até o final
            if( k[x] > k[y] )   // Menor `a D
            {
                tmp  = k[x];
                k[x] = k[y];
                k[y] = tmp ;
            } // end if

        } // end y

    } // end x

}
