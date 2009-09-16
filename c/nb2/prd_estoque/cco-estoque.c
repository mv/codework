/*
    cco_estoque: Programa de estoque - Anhembi/Morumbi
                 Ling. de Programação I
                 Walter
                 Nov/2002

                 Carlos Aberto Ide
                 Marcus Vinicius Ferreira
                 Meire Aparecida Pereira

    $RCSFile$ $Revision: 1.2 $

Programas:
----------
    mod_menu
        +- mod_consulta
        |   +- select
        |   +- log()
        |
        +- mod_alteracao
        |   +- select
        |   +- update
        |   +- log()
        |
        +- mod_insercao
        |   +- select
        |   +- insert
        |   +- log()
        |
        +- mod_exclusao
        |   +- select
        |   +- delete
        |   +- log()
        |
        +- mod_atu_qtd
        |   +- select
        |   +- update
        |   +- log()
        |
        +- mod_relatorio
        |   +- select
        |   +- log()
        |
        +- mod_consolidacao
            +- log()

*/

char rcsid[] = "$Id: cco-estoque.c 6 2006-09-10 15:35:16Z marcus $";

#include <stdio.h>

/*
    Variáveis Globais que definem o registro de estoque
*/

char    cod_prod[10];   /* codigo do produto     */
char    desc_prod[50];  /* descrição do produto  */
float   vlr_prod;       /* valor do produto      */
int     qtd_est;        /* quantidade em estoque */
int     qtd_min;        /* quantidade minima em estoque */
char    flag_delete;    /* produto deletado? (S/N) */

/*
    Variáveis Globais de controle
*/

int     rec;    /* qtd registros    */
FILE    *fdata; /* arquivo de dados */
FILE    *flog;  /* arquivo de log   */


/*
    sub-rotinas de acesso aos arquivos
*/

int select();           /* Lê um  registro   */
int insert();           /* Insere registro   */
int update();           /* Atualiza registro */
int delete();           /* Remove registro   */
int log(char *msg);     /* Grava uma mensagem no log */

int mod_consulta();
int mod_alteracao();

int main (void)
{
    /*
    **  Inicializa os arquivos
    */
    fdata = fopen("data_estoque.txt","a");
    if ( fdata == NULL )
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



    /* FIM */
    log("Fechado: Banco de Dados Fechado.");
    fclose(fdata);
    fclose(flog);
    return 0 ;

    /* Bogus: codigo burro apenas para apontar o uso de "rcsid" */
    if (1==0)
        printf("%s", rcsid);
}

int log(char *msg)
{
    fprintf(flog,"yyyy/mm/dd hh:mi:ss - %s \n", msg);
}
