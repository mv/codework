/*
    $RCSFile$ $Revision: 1.3 $
*/

char mod_consulta_rcsid[] = "$Id: mod_consulta.c 6 2006-09-10 15:35:16Z marcus $";

#include "db.h"

int mod_consulta (void)
{

    char cod_prod[COD_PROD];
    struct estoque item_consulta;
    int result;

    cls();
    log("Consulta");

    printf("Controle de Estoque\n");
    printf("-------------------\n");

    printf("\n\n");
    printf("   Consulta \n");
    printf("   ======== \n");

    printf("\n\n");
    printf("       Produto a ser consultado: ");
    scanf("%s", &cod_prod);

    result = select(&item_consulta, &cod_prod);

    printf("\n\n");

    if (result) {
        printf("   Registro : %d \n", item_consulta.rec_id );
        printf("     Código : %s \n", item_consulta.cod_prod);
        printf("    Produto : %s \n", item_consulta.desc_prod);
        printf("      Preço : %.2f \n", item_consulta.vlr_prod);
        printf("    Estoque : %d \n", item_consulta.qtd_est);
        printf(" Qtd.Minima : %d \n", item_consulta.qtd_min);
      //printf("    DELETE? : %s \n", item_consulta.flag_delete);

        printf("\n\n");

        if ( item_consulta.qtd_est <= item_consulta.qtd_min ){
            printf("\n\n   Quantidade abaixo do mínimo! \n");
            printf("   Fazer reposição assim que possível.\n");
        }
    }
    else {
        printf("   Registro não encontrado. \n");
    }

    pause();
    log("Fim da Consulta");
    return 0 ;
}
