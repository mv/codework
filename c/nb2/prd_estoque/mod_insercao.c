/*
    $RCSFile$ $Revision: 1.4 $
*/

char mod_insercao_rcsid[] = "$Id: mod_insercao.c 6 2006-09-10 15:35:16Z marcus $";

#include "db.h"
#include <string.h>

int mod_insercao (void)
{
    char cod_prod[COD_PROD];
    struct estoque item_consulta;
    int result;

    cls();
    log("Inserção");

    printf("Controle de Estoque\n");
    printf("-------------------\n");

    printf("\n\n");
    printf("   Inserção \n");
    printf("   ======== \n");

    printf("\n\n");

    printf("       Digite o novo código de produto: ");
    scanf("%s", &cod_prod);

    result = select(&item_consulta, &cod_prod);

    printf("\n\n");

    if (result) {
        printf("    Produto já existe.\n\n");
        printf("    Produto : %s \n", item_consulta.desc_prod);
        log("Código do registro já existe.");

        printf("\n\n");

        pause();
        log("Fim da Inserção");
        return 1;

    }

    printf(" Digite as informações\n");
    printf(" ---------------------\n");
    printf("    Produto : ");
    //scanf("%s" , &item_consulta.desc_prod);
    scan( &item_consulta.desc_prod );
    printf("      Preço : "); scanf("%f" , &item_consulta.vlr_prod);
    printf("    Estoque : "); scanf("%d" , &item_consulta.qtd_est);
    printf(" Qtd.Minima : "); scanf("%d" , &item_consulta.qtd_min);

    printf("\n\n");

    // Defaults
    item_consulta.flag_delete[0] = 'N';
    item_consulta.flag_delete[1] = '\0';

    // Cria registro
    strcpy( item_consulta.cod_prod, cod_prod);
    insert(&item_consulta);
    log("Registro criado.");

    pause();
    log("Fim da Consulta");

    return 0 ;
}

int scan(char *vlr)
{
    char str[1024];
    int ch=0;
    int i=0;

    getchar();
    do {
        ch = getchar();
        str[i]=ch;
        ++i;
    } while (ch != 10);

    // Fim da string
    str[i-1]='\0';

    strcpy(vlr, str);
    //printf("Vlr %s, Str %s",vlr,str);

    return 0;
}


