/*
    $Id: t1.c 6 2006-09-10 15:35:16Z marcus $
    Teste 1: define + arquivo + struct

*/

#define PRD "/tmp/prd_estoque.txt"
#define LOG "/tmp/prd_log.txt"

#include <stdio.h>

int main (void)
{
    char prd[] = PRD;
    char log[] = LOG;


    struct rec_prod { char      cod[10];
                      char      desc[30];
                      float     preco;
                      int       qte;
                      int       qte_min;
                    };
    typedef prod_t rec_prod ;
    prod_t  prod1, prod2;

    strcpy(prod1.cod, "100.001");
    strcpy(prod1.desc, "HD 10G");
    prod1.preco = 109.99 ;
    prod1.qte   = 100;
    prod1.qte_min = 10;

    strcpy(prod1.cod, "100.002");
    strcpy(prod1.desc, "HD 20G");
    prod1.preco = 139.99 ;
    prod1.qte   = 110;
    prod1.qte_min = 20;
    /* */



    FILE *fd;
    FILE *fl;
/***
    fd = fopen( prd[0] , 'w' );
    fl = fopen( log[0] , 'w' );


    fclose(fd);
    fclose(fl);
*/
    printf( PRD );
    printf( "\n\n");
    printf( LOG   );

    printf("\n  %s  %s \n", prd, log );

    return 0;
}