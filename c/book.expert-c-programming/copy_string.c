/*
** $Id: copy_string.c 6 2006-09-10 15:35:16Z marcus $
**
**  Marcus Vinicius Ferreira
**
**  copy string:
*/

#include <stdio.h>

int main()
{
    char s[] = "Marcus";
    char p[50];

    while ( *p++ = *s++ ) ;

    printf ("String: [%s] [%p]", s, p);

    return 0;
}
