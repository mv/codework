/*
** $Id: const_pointer.c 6 2006-09-10 15:35:16Z marcus $
**
**  Marcus Vinicius Ferreira
**
**  template :
*/

#include <stdio.h>

int main()
{

    const int limit = 10;

    const int *p1;
    int *p2;

    p1 = &limit;

    p2 = &limit;
    /* --warning: assignment discards qualifiers from pointer target type--
    ** i.e., 'p2' is not "const" so attributions to p2 can be made and
    ** 'limit' can be override via 'p2'.
    */
    *p2 = 15;

    printf("limit = %d, p1 = %d, p2 = %d \n\n", limit, *p1, *p2 );
    printf("limit = %d, p1 = %d, p2 = %d \n\n", (int) &limit,(int)&p1, (int)&p2 );

    return 0;
}
