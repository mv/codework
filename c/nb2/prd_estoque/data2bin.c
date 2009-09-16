/*
    Teste 1: define + arquivo + struct

    $RCSfile: data2bin.c,v $ $Revision: 1.10 $
*/

char data2bin_rcsid[] = "$Id: data2bin.c 6 2006-09-10 15:35:16Z marcus $";

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "db.h"
//

char    vlr_prod[10];   /* valor do produto      */
char    qtd_est[10];    /* quantidade em estoque */
char    qtd_min[10];    /* quantidade minima em estoque */


/*
    Variáveis Globais de controle
*/

#define LINEMAX 1024

int     rec=0;    /* qtd registros    */
char    line[LINEMAX];
char    sub[LINEMAX];

FILE    *fdat;  /* arquivo de dados */
FILE    *flog;  /* arquivo de log   */
FILE    *fdbf;  /* arquivo dbf */

int substr(char *sub, char *str, int col);

int main (void)
{

    /*
    **  Inicializa os arquivos
    */
    fdat = fopen("data_estoque.txt","r"); // Leitura
    if ( fdat == NULL ){
        printf("\n   Erro abrindo arquivo de dados\n\n");
        return 1;
    }

    fdbf = fopen("data_estoque.dbf","wb"); // Escrita
    if ( fdbf == NULL ){
        printf("\n   Erro abrindo arquivo dbf\n\n");
        return 3;
    }

    /*
    *** Corpo principal do programa
    */
    while ( !feof(fdat) ) {

        // Lê do arquivo texto
        fgets(line, LINEMAX, fdat );

        if ( line[0] == '#' || strlen(line) < 10 )
            continue;

        // Separando as colunas
        substr(item.cod_prod    , line, 1);
        substr(item.desc_prod   , line, 2);
        substr(vlr_prod         , line, 3);
        substr(qtd_est          , line, 4);
        substr(qtd_min          , line, 5);
        substr(item.flag_delete , line, 6);

        // Convertendo os números
        item.vlr_prod = atof (vlr_prod);
        item.qtd_est  = atoi (qtd_est);
        item.qtd_min  = atoi (qtd_min);

        rec += 1;
        printf("%d\n",rec);
        item.rec_id = rec;

        // Conferindo os valores de cada coluna e tamanho
        printf("- col 01:{[ %s ]} size: %d \n" , item.cod_prod , sizeof(item.cod_prod) );
     /* printf("- col 02:{[ %s ]} size: %d \n" , item.desc_prod, sizeof(item.desc_prod) );
        printf("- col 03:{[ %s ]} size: %d \n" , vlr_prod, sizeof(vlr_prod) );
        printf("-        {[ %f ]} size: %d \n" , item.vlr_prod, sizeof(item.vlr_prod) );
        printf("- col 04:{[ %s ]} size: %d \n" , qtd_est, sizeof(qtd_est) );
        printf("-        {[ %d ]} size: %d \n" , item.qtd_est, sizeof(item.qtd_est) );
        printf("- col 05:{[ %s ]} size: %d \n" , qtd_min, sizeof(qtd_min) );
        printf("-        {[ %d ]} size: %d \n" , item.qtd_min, sizeof(item.qtd_min) );
        printf("- col 06:{[ %s ]} size: %d \n" , item.flag_delete, sizeof(item.flag_delete) );
      */printf("\n");

      // Escreve em binário
        fwrite( &item, sizeof(item), 1, fdbf );
    }

    printf("\n");
    printf ("Struct size %d \n",sizeof(item));

    /* FIM */
    fclose(fdat);
    fclose(fdbf);

    return 0 ;
}

int substr(char *sub, char *str, int col)
{
    //
    int i=0;
    int j=0;
    int kount=0; // Contagem das colunas começa com 1
    int ipos, fpos;

    do {

        // Procurando nésimo ';' até o fim da string
        if ( str[i] == ';' ){
            ++kount;

            if ( kount == col ){
            // Achou o final da coluna
                break;
            }
        }

        if ( str[i] == '\0' )
            break;

        // Avança uma posição
        ++i;

    } while ( 1 ) ;
    // Guarda final da coluna
    fpos=i-1;

    // Coluna pedida excede qte presente na lina: ERRO
    if ( col > kount )
        return 1;

    // Ponto de início para a procura do começo da coluna
    i=fpos;
    do {

        if ( col == 1 ) {
            // Primeira coluna começa no início da linha
            ipos=0;
            break;
        }

        if ( str[i] == ';') {
            // Início da coluna
            ipos = i+1;
            break;
        }

        // Volta uma posição
        --i;

    } while ( 1 );

    // Copiando a coluna
    for ( i=ipos; i<=fpos; ++i){

        sub[j] = str[i];
        ++j;
    }
    sub[j]='\0';

  //printf ("kount = %d , i = %d , ipos = %d, fpos = %d\n",kount,i, ipos, fpos);
  //printf("strlen = %d, sub = [%s] \n", strlen(sub), sub);
    return 0;
}
