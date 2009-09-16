/*
** $Id: ptr_param.c 6 2006-09-10 15:35:16Z marcus $
*/

#include <stdio.h>

char _id[]="@(#) $Id: ptr_param.c 6 2006-09-10 15:35:16Z marcus $" ;

char nome[]="123456\0";

int f(char *p1)
{
    *(p1)='M';
    p1[1]='a';
    return 0;

}

int p(char *p2)
{
    int i;
    for (i=0;i<100;i++)
    {
        print(" Valor: %s - %d ", p2[i], p2[i]);
        if ( p2[i]='\0' )
           break;
    }
}

int main (void)
{
    f( nome );
    printf("\n   Nome = %s \n", nome);
    return 0;
}
