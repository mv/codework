/* Stephen Toub
 * toub@fas.harvard.edu
 * CS50 Fall 2000
 *
 * shaker.c
 *
 * Implementation of shaker sort
 */

#include <stdio.h>

/* Sort array a[] of n integers using shaker sort */
void shakersort(int a[], int n) 
{
	int min, max, i, j, k, swap;

	for(i=0; i<n; i++, k--) {
		min = max = i;
		
		for (j = i + 1; j <= k; j++) {
			if (a[j] < a[min]) min = j;
			if (a[j] > a[max]) max = j;
		} 
		
		swap = a[min];
		a[min] = a[i];
		a[i] = swap; 
		
		if (max == i) {
			swap = a[min];
			a[min] = a[k];
			a[k] = swap;
		} else {
			swap = a[max];
			a[max] = a[k];
			a[k] = swap;
		}
	}
}

/*
 * end of shaker.c
 */
