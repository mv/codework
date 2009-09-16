/* Variável Static 2/2 */
/* MV 10/12/1999 */
#include <stdio.h>

void f_estatic(void);
int main(void)
{       int i=0;
        while( i<10 )
        {       printf("%d ",i++);
                f_estatic();
                printf("\n");
        }
        printf("\n");
        exit(0);
}

void f_estatic(void)
{       static int j=0;
        ++j;
        printf("%d ",j);
}
