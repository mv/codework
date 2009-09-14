#include <stdio.h>

/* copy input to output; 2nd version */
main()
{
    long nc;

    nc = 0;
    while (	getchar() != EOF)
    	++nc;

    printf("Characters: %ld\n", nc);

}

