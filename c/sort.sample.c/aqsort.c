/* Copyright 1998, M. Douglas McIlroy
   Permission is granted to use or copy with this notice attached.
 
   Aqsort is an antiquicksort.  It will drive any qsort implementation
   based on quicksort into quadratic behavior, provided the imlementation
   has these properties:

   1.  The implementation is single-threaded.

   2.  The pivot-choosing phase uses O(1) comparisons.

   3.  Partitioning is a contiguous phase of n-O(1) comparisons, all
   against the same pivot value.

   4.  No comparisons are made between items not found in the array.
   Comparisons may, however, involve copies of those items.

   Method

   Values being sorted are dichotomized into "solid" values that are
   known and fixed, and "gas" values that are unknown but distinct and
   larger than solid values.  Initially all values are gas.  Comparisons
   work as follows:

   Solid-solid.  Compare by value.  Solid-gas.  Solid compares low.
   Gas-gas.  Solidify one of the operands, with a value greater
      than any previously solidified value.  Compare afresh.

   During partitioning, the gas values that remain after pivot-choosing
   will compare high, provided the pivot is solid.  Then qsort will go
   quadratic.  To force the pivot to be solid, a heuristic test
   identifies pivot candidates to be solidified in gas-gas comparisons.
   A pivot candidate is the gas item that most recently survived
   a comparison.  This heuristic assures that the pivot gets
   solidified at or before the second gas-gas comparison during the
   partitioning phase, so that n-O(1) gas values remain.

   To allow for copying, we must be able to identify an operand even if
   it was copied from an item that has since been solidified.  Hence we
   keep the data in fixed locations and sort pointers to them.  Then
   qsort can move or copy the pointers at will without disturbing the
   underlying data.

   int aqsort(int n, int *a); returns the count of comparisons qsort used
   in sorting an array of n items and fills in array a with the
   permutation of 0..n-1 that achieved the count.
*/

#include <stdlib.h>
#include <assert.h>
int	*val;			/* array, solidified on the fly */
int	ncmp;			/* number of comparisons */
int	nsolid;			/* number of solid items */
int	candidate;		/* pivot candidate */
int	gas;			/* gas value = highest sorted value */
#define freeze(x) val[x] = nsolid++

int
cmp(const void *px, const void *py)  /* per C standard */
{
	const int x = *(const int*)px;
	const int y = *(const int*)py;
	ncmp++;
	if(val[x]==gas && val[y]==gas)
		if(x == candidate)
			freeze(x);
		else
			freeze(y);
	if(val[x] == gas)
		candidate = x;
	else if(val[y] == gas)
		candidate = y;
	return val[x] - val[y];
}

int
aqsort(int n, int *a)
{
	int i;
	int *ptr = malloc(n*sizeof(*ptr));
	val = a;
	gas = n-1;
	nsolid = ncmp = candidate = 0;
	for(i=0; i<n; i++) {
		ptr[i] = i;
		val[i] = gas;
	}
	qsort(ptr, n, sizeof(*ptr), cmp);
	for(i=1;i<n;i++)
		assert(val[ptr[i]]==val[ptr[i-1]]+1);
	free(ptr);
	return ncmp;
}

/* driver main program, to be linked with qsort
	usage: aqsort [-p] n
   constructs an adversarial input and reports the comparison
   count for it.  Option -p prints the adversarial input.
*/

#include <stdio.h>
#include <string.h>

int pflag;

main(int argc, char **argv)
{
	int n, i;
	int *b;
	if(argc>1 && strcmp(argv[1],"-p") == 0) {
		pflag++;
		argc--;
		argv++;
	}
	if(argc != 2) {
		fprintf(stderr,"usage: aqsort [-p] n\n");
		exit(1);
	}
	n = atoi(argv[1]);
	b = malloc(n*sizeof(int));
	if(b == 0) {
		fprintf(stderr,"aqsort: out of space\n");
		exit(1);
	}
	i = aqsort(n, b);
	printf("n=%d count=%d\n", n, i);
	if(pflag)
		for(i=0; i<n; i++)
			printf("%d\n", b[i]);
	exit(0);
}
