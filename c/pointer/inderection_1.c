#
#

#include <stdio.h>

int main(void)
{
    int  *p;
    int **ptr; // a pointer to store a pointer to int
    int   a;

      a = 10 ;
      p = &a ;
    ptr = &p ;

    printf("  a (int)  = %d \n",a);
    printf("  p (addr) = %p \n",p);
    printf("ptr (addr) = %p \n",ptr);
    printf("\n");
    printf("  p stores : %d \n", *p );
    printf("ptr stores : %p \n", *ptr );
    printf("ptr indirection : %d \n", **ptr );

    return 0;
}
