/*
 * $Id: ShellSort.c 6 2006-09-10 15:35:16Z marcus $
 *
 * ShellSort
 *      comparando vizinhos
 *
 */

void ShellSort (long k[], int n)
{
    int x,y;
    int tmp, max;

    for( x=0; x<(n-1); x++ )
    {
        for( y=0; y<(x-1-y); y++ )
        {
            if( k[y] > k[y+1] )
            {

            } // end if

        } // end y

    } // end x

}