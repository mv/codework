/*
** $Id: unsigned_compare.c 6 2006-09-10 15:35:16Z marcus $
**
**  Marcus Vinicius Ferreira
**
**  template :
*/

#include <stdio.h>

int main()
{
    if ( (unsigned char) 1 > -1 )
        printf("-1 is less than (unsigned char) 1: ANSI\n");
    else
        printf("-1 is NOT LESS than (unsigned char) 1: K&R\n");

    return 0;
}
