/*
    cco_estoque: Programa de estoque - Anhembi/Morumbi
                 Ling. de Programação I
                 Walter
                 Nov/2002

                 Carlos Aberto Ide
                 Fernando Bardella
                 Marcus Vinicius Ferreira
                 Meire Aparecida Pereira

    $RCSfile: main_cco_estoque.c,v $ $Revision: 1.7 $

Programas:
----------

 main - Marcus
  +-mod_menu - Carlos
        +- mod_consulta - Carlos
        |   +- select
        |   +- log()
        |
        +- mod_insercao - Meire
        |   +- select
        |   +- insert
        |   +- log()
        |
        +- mod_alteracao- Meire
        |   +- select
        |   +- update
        |   +- log()
        |
        +- mod_exclusao - FernandoBardella
        |   +- select
        |   +- delete
        |   +- log()
        |
        +- mod_atu_qtd - FernandoBardella
        |   +- select
        |   +- update
        |   +- log()
        |
        +- mod_relatorio - Marcus
        |   +- select
        |   +- log()
        |
        +- mod_consolidacao - Marcus
            +- log()

*/

char rcsid[] = "$Id: main_cco_estoque.c 6 2006-09-10 15:35:16Z marcus $";

#include <stdio.h>
#include <time.h>
#include "db.h"

/*
    Variáveis Globais que definem o registro de estoque
*/

char    cod_prod[10];   /* codigo do produto     */
char    desc_prod[50];  /* descrição do produto  */
char    vlr_prod;       /* valor do produto      */
char    qtd_est;        /* quantidade em estoque */
char    qtd_min;        /* quantidade minima em estoque */
char    flag_delete;    /* produto deletado? (S/N) */


/*
    Variáveis de controle
*/

FILE    *fdat;  /* arquivo de dados */
FILE    *flog;  /* arquivo de log   */

int     rec;    /* qtd registros    */
int     menu;   /* opção do menu    */

int log(char *msg);     /* Grava uma mensagem no log */

int main (void)
{
    /*
    **  Inicializa os arquivos
    */
    fdat = fopen("data_estoque.dbf","r+b"); //Binário: Read/Write
    if ( fdat == NULL )
    {
        printf("\n   Erro abrindo arquivo de dados\n\n");
        return 1;
    }

    flog = fopen("alert_estoque.log","a");
    if ( flog == NULL )
    {
        printf("\n   Erro abrindo arquivo de log\n\n");
        return 2;
    }

    log(" Aberto: Banco de Dados Iniciado.");

    /*
    *** Corpo principal do programa
    */
    while(1) {

        menu = mod_menu();
        //printf("\n\n   Escolhido: %d \n\n",menu);

        switch(menu) {
            case 1:
                    printf("@1\n");
                    mod_consulta();
                    break;
            case 2:
                    printf("@2\n");
                    mod_insercao();
                    break;
            case 3:
                    printf("@3\n");
                    mod_alteracao();
                    break;
            case 4:
                    printf("@4\n");
                    mod_exclusao();
                    break;
            case 5:
                    printf("@5\n");
                    mod_atu_qtd();
                    break;
            case 6:
                    printf("@6\n");
                    relatorio();
                    break;
            case 7:
                    printf("@7\n");
                    consolida();
                    break;
            case 8:
                    printf("@8\n");
                    mod_ajuda();
                    break;
            case 9:
                    //printf("@9\n");
                    break;
        }
        if (menu==9)
            break; /* break para while */
    }


    /* FIM */
    log("Fechado: Banco de Dados Finalizado.");
    fclose(fdat);
    fclose(flog);
    return 0 ;

}

int log(char *msg)
{
    time_t tmp;
    struct tm *now;
    char   date[30];

    /* Time no formato Epoch */
    time(&tmp);
    /* Time quebrado na estrutura tm */
    now = localtime(&tmp);
    /* Time formatado em string */
    strftime(date, 30, "%Y/%m/%d %X", now );

    /* Escreve a mensagem */
    fprintf(flog,"%s - %s \n",date, msg);
    fflush(flog);
}

void pause(void)
{
    char ch;

    printf("\n <Pressione '.' para retornar> \n");
    do{
        ch = getchar();
    } while ( ch!='.' );
}

int trim(char *str)
{
    int i=0;
    // Termina a string no primeira espaço encontrado
    while( ! str[i]=='\0') {
        ++i;
        if (str[i]==' ')
            str[i] = '\0';
    }
    return 0;
}

int select(struct estoque *item, char *cod_prod)
{
    // conta os registros
    int i=1;

    // posiciona no início do arquivo
    rewind(fdat);

    // varre arquivo
    while ( !feof(fdat) && i<100 ){

        // Lê um registro
        // printf("   SELPos: %d \n", ftell(fdat) );
        fread(item, sizeof(struct estoque), 1, fdat);

        // Limpa espaços à D
        trim(item->cod_prod);

     /* printf("Id: [%d] Cod: [%s] Nome: %s \n", item->rec_id
                                               , item->cod_prod
                                               , item->desc_prod);
     */
        if ( strcmp(cod_prod, item->cod_prod) == 0){
            // Encontrado
            log( "Select: FOUND" );

            if ( item->flag_delete[0]== 'S' ){
                log("Registro DELETADO");
                return (0);
            }

            return (i);
        }

        ++i;
    }
    log( "Select: NOTFOUND" );

    return 0 ;
}

int insert(struct estoque *item)
{
    int pos;

    // posiciona o arquivo no final
    fseek(fdat, 0, SEEK_END);
    //printf("Pos: %d", ftell(fdat) );

    // Calcula o num. do registro físico
    pos = ftell(fdat) / sizeof(struct estoque);
    //printf("   INSPos: %d \n",pos);

    item->rec_id = pos;

    // grava registro
    fwrite(item, sizeof(struct estoque), 1, fdat);

    log("INSERT: gravado novo registro.");

    return 0 ;
}

int update(struct estoque *item)
{
    int pos;

    // posiciona o arquivo
    pos = ( item->rec_id - 1 ) * sizeof(struct estoque) ;
    fseek(fdat, pos, SEEK_SET);
    //printf("   UPDPos: %d, Rec_id: %d \n", ftell(fdat), item->rec_id );

    // grava registro
    fwrite(item, sizeof(struct estoque), 1, fdat);

    log("UPDATE: feito.");

    return 0 ;
}

int relatorio(void)
{
    struct estoque item;
    int kount=0;
    int lines=0;
    char repor[15];

    cls();
    log("Relatório");

    printf("Controle de Estoque\n");
    printf("-------------------\n");

    printf("\n\n");
    printf("   Relatorio \n");
    printf("   ========= \n");

    printf("\n\n");

    printf("Reg  Prod.        Descrição                        Preço Est Min\n");
    printf("---  -----        ---------                        ----- --- ---\n");

    rewind( fdat );
    while( !feof(fdat) ){

        fread( &item, sizeof( item ), 1, fdat );

        if ( item.flag_delete[0]=='N' ) {

            kount+=1;
            lines+=1;

            // Verifica Estoque
            if (item.qtd_est<= item.qtd_min)
                strcpy( repor, "Repor" );
            else
                strcpy( repor, "Ok");

            // Imprime
            printf("%03d: %-10s - %-31s %6.2f %3d [%3d] %s \n"
                                     , item.rec_id
                                     , item.cod_prod
                                     , item.desc_prod
                                     , item.vlr_prod
                                     , item.qtd_est
                                     , item.qtd_min
                                     , repor );
        }

    }

    //printf("\n  Contagem %d \n",kount);

    pause();
    log("Fim do Relatório");
    return 0 ;
}

int consolida(void)
{

    // Faz truncate: remove registros deletados do arquivo binário

    FILE *ftmp;
    struct estoque item;
    int orig=0;
    int dest=0;
    int resp;

    cls();
    log("Consolidação");

    printf("Controle de Estoque\n");
    printf("-------------------\n");

    printf("\n\n");
    printf("   Consolidação \n");
    printf("   ============ \n");

    printf("\n\n");

    printf(" Deseja consolidar a base (S/N)? ");

    do {
        resp = getchar();
        resp = toupper(resp);
        if ( resp == 'S' || resp == 'N' )
            break;
    } while ( 1 );

    if (resp=='N'){
        log("Consolidação: NÃO.");
        return 1;
    }

    // Cria arquivo temporário
    ftmp = fopen("data_estoque.tmp","wb"); //Binário: Write
    if ( ftmp == NULL )
    {
        log("Erro abrindo arquivo temporario");
        return 1;
    }

    log("Arquivo temporário criado.");


    // Lê arquivo de origem
    rewind(fdat);
    while ( !feof(fdat) ){

        fread(&item, sizeof(struct estoque), 1, fdat );
        orig += 1;

        if ( item.flag_delete[0]=='N' ){
            // Copia
            dest += 1;

            // Novo sequencia física
            item.rec_id = dest;
            fwrite(&item, sizeof(struct estoque), 1, ftmp );
        }

    }

    log("Registros copiados.");

    printf("\n\n Registros lidos: %d, Registros movidos: %d \n",orig, dest);
    printf("\n\n");

    fclose(ftmp);

    // Muda nome do arquivo
    fclose(fdat);
    rename("data_estoque.tmp", "data_estoque.dbf");
    log("Arquivo renomeado");

    // Reabre db
    fdat = fopen("data_estoque.dbf","r+b"); //Binário: Read/Write
    if ( fdat == NULL )
    {
        printf("\n   Erro abrindo arquivo de dados\n\n");
        log("Erro re-abrindo arquivo de dados");
        return 1;
    }

    log("Arquivo re-aberto.");

    pause();

    log("Fim da consolidação.");

    return 0;

}
