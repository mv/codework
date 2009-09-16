/*
    Teste 1: define + arquivo + struct

    $RCSfile: bin2data.c,v $ $Revision: 1.3 $
*/

char bin2data_rcsid[] = "$Id: bin2data.c 6 2006-09-10 15:35:16Z marcus $";

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "db.h"
//

/*
    Variáveis Globais de controle
*/

#define LINEMAX 1024

int     rec;    /* qtd registros    */
int     pos;    /* posição no arquivo binário */
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
    fdat = fopen("data_estoque2.txt","w"); // Escrita
    if ( fdat == NULL ) {
        printf("\n   Erro abrindo arquivo de dados\n\n");
        return 1;
    }

    fdbf = fopen("data_estoque.dbf","rb"); // Leitura
    if ( fdbf == NULL ) {
        printf("\n   Erro abrindo arquivo dbf\n\n");
        return 3;
    }

    /*
    *** Corpo principal do programa
    */
    while ( !feof(fdbf) ) {

        //printf("%d\n",rec);
        rec += 1;

        // Lê binário
        pos = ftell(fdbf);
        fread( &item, sizeof(item), 1, fdbf );

        // Escreve no arquivo texto
        fprintf( fdat, " %2d : %s | %s : %.2f : %3d : %3d : %s \n", rec
                                     , item.cod_prod
                                     , item.desc_prod
                                     , item.vlr_prod
                                     , item.qtd_est
                                     , item.qtd_min
                                     , item.flag_delete
                                     );
        // Mostra na tela
        printf( "Pos[%2d] %2d : %s | %s : %.2f : %3d : %3d : %s \n"
                                     , pos
                                     , rec
                                     , item.cod_prod
                                     , item.desc_prod
                                     , item.vlr_prod
                                     , item.qtd_est
                                     , item.qtd_min
                                     , item.flag_delete
                                     );
    }

    /* FIM */
    fclose(fdat);
    fclose(fdbf);

    return 0 ;
}
