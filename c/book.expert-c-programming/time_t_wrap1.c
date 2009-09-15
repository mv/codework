/*
** $Id: time_t_wrap1.c 6 2006-09-10 15:35:16Z marcus $
**
**  Marcus Vinicius Ferreira
**
**  final dos tempos: wrap of time_t
*/

#include <stdio.h>
#include <time.h>

int main()
{
    time_t biggest = 0x7FFFFFFF;

    printf("\n\n");
    printf("  ctime: Biggest = %s ", ctime(&biggest) );
    printf(" gmtime: Biggest = %s ", asctime(gmtime(&biggest)) );

    return 0;
}
