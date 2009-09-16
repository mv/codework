/*
    $RCSFile$ $Revision: 1.2 $
*/

char mod_atu_qtd_rcsid[] = "$Id: mod_atu_qtd.c 6 2006-09-10 15:35:16Z marcus $";

#include "db.h"

int mod_atu_qtd (void)
{

    char cod_prod[COD_PROD];
    struct estoque item_atu;
    int result;

    cls();
    log("Atualização de Estoque");

    printf("Controle de Estoque\n");
    printf("-------------------\n");

    printf("\n\n");
    printf("   Atualização de Estoque \n");
    printf("   ====================== \n");

    printf("\n\n");

    printf("       Digite o código de produto: ");
    scanf("%s", &cod_prod);

    result = select(&item_atu, &cod_prod);

    printf("\n\n");

    if (result==0) {
        printf("    Produto não encontrado.\n\n");

        printf("\n\n");

        pause();
        log("Fim da Atualização de Estoque");
        return 1;

    }

    printf(" Digite as informações\n");
    printf(" ---------------------\n");
    printf("    Produto [%s]  \n",item_atu.desc_prod);
    printf("      Preço [%.2f]\n",item_atu.vlr_prod);
    printf(" Qtd.Minima [%d]  \n",item_atu.qtd_min );
    printf("\n");
    printf("    Estoque [%d]: ",item_atu.qtd_est  ); scanf("%d" , &item_atu.qtd_est);

    printf("\n\n");

    // Grava modificações
    update(&item_atu);
    log("Estoque alterado.");

    pause();
    log("Fim da Atualização de Estoque");

    return 0 ;
}
