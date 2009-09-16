/*
    $RCSFile$ $Revision: 1.4 $
*/

char mod_exclusao_rcsid[] = "$Id: mod_exclusao.c 6 2006-09-10 15:35:16Z marcus $";

#include "db.h"

int mod_exclusao (void)
{
    char cod_prod[COD_PROD];
    struct estoque item_del;
    int result;
    char resp;

    cls();
    log("Exclusão");

    printf("Controle de Estoque\n");
    printf("-------------------\n");

    printf("\n\n");
    printf("   Exclusão \n");
    printf("   ======== \n");

    printf("\n\n");
    printf("       Digite o código de produto: ");
    scanf("%s", &cod_prod);

    result = select(&item_del, &cod_prod);
    //printf("  Registro %d \n", result);

    printf("\n\n");

    if (result==0) {
        printf("    Produto não existe");
        log("Produto não existe");

        printf("\n\n");

        pause();
        log("Fim da Exclusão");
        return 1;

    }

    printf(" Detalhes dos produto\n");
    printf(" --------------------\n");
    printf("   Registro : %d   \n",item_del.rec_id   );
    printf("    Produto : %s   \n",item_del.desc_prod);
    printf("      Preço : %.2f \n",item_del.vlr_prod );
    printf("    Estoque : %d   \n",item_del.qtd_est  );
    printf(" Qtd.Minima : %d   \n",item_del.qtd_min  );

    printf("\n\n");

    // Grava modificações

    printf(" Deseja apagar o registro (S/N)? ");

    do {
        resp = getchar();
        resp = toupper(resp);
        if ( resp == 'S' || resp == 'N' )
            break;
    } while ( 1 );

    if (resp=='S'){
        item_del.flag_delete[0]='S';
        update( &item_del );
        log("Registro removido.");
    }

    pause();
    log("Fim da Exclusao");

    return 0 ;
}
