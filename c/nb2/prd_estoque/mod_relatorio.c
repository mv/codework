/*
    $RCSfile: mod_relatorio.c,v $ $Revision: 1.3 $
*/

char mod_relatorio_rcsid[] = "$Id: mod_relatorio.c 6 2006-09-10 15:35:16Z marcus $";

#include <stdio.h>
#include "db.h"

int mod_relatorio (FILE *frel)
{
    struct estoque item;
    int kount;

    cls();
    log("Relatório");

    printf("Controle de Estoque\n");
    printf("-------------------\n");

    printf("\n\n");
    printf("   Relatorio \n");
    printf("   ========= \n");

    printf("\n\n");


    pause();
    log("Fim do Relatório");
    return 0 ;
}
