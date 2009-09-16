/*
    Variáveis Globais que definem o registro de estoque
*/

/*char db_h_rcsid[] = "$Id: db.h 6 2006-09-10 15:35:16Z marcus $";
*/

// Tamanhos das strings
#define COD_PROD 10
#define DESC_PROD 30
#define FLAG_DELETE 2

struct estoque {
    int     rec_id;         /* record id: para uso interno */
    char    dirty[1];       /* dirty: registro alterado? - uso interno */
    char    cod_prod[COD_PROD];         /* codigo do produto     */
    char    desc_prod[DESC_PROD];       /* descrição do produto  */
    float   vlr_prod;                   /* valor do produto      */
    int     qtd_est;                    /* quantidade em estoque */
    int     qtd_min;                    /* quantidade minima em estoque */
    char    flag_delete[FLAG_DELETE];   /* produto deletado? (S/N) */
} ;

struct estoque item;
struct estoque item1;
struct estoque item2;
