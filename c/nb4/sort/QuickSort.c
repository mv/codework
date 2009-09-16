/*
 * $Id: QuickSort.c 6 2006-09-10 15:35:16Z marcus $
 *
 * QuickSort
 *      comparando vizinhos
 *
 */

void QuickSort (long item[], int left, int right)
{
    int i,j;
    int num,tmp;  // x: referencia


    i=left; j=right;
    num = item[ (left+right)/2 ]; // referencia: o do meio

    do {
        while( num > item[i] && i<right)
        {   i++;    // procura da E para D
        }
        while( num < item[j] && j<left)
        {   j--;    // procura da D para E
        }
        if (i<=j)
        {
            tmp = item[i];      // troca
            item[i] = item[j];
            item[j] = tmp;

            i++; j--;   // ??
        }
    } while(i<=j) ;

    if( left < j )  QuickSort(item, left, j);
    if( i < right)  QuickSort(item, i, right);
}
