/*
    $RCSFile$ $Revision: 1.2 $
*/

char ajuda_rcsid[] = "$Id: mod_ajuda.c 6 2006-09-10 15:35:16Z marcus $";
char mod_ajuda_id[]= "@(#) --";

int mod_ajuda (void)
{
    char ch[2];

    cls();
    log("Ajuda");

    printf("Controle de Estoque\n");
    printf("-------------------\n");

    printf("\n\n");
    printf("   Ajuda do Sistema \n");
    printf("   ================ \n");

    printf("\n\n");
    printf("       ( Texto de ajuda vai aqui) \n");
    printf("       ( em progresso.... )\n");

    printf("\n\n");
    printf("\n\n\n\n\n\n");

    pause();

    log("Fim da Ajuda.");
    return 0 ;
}
