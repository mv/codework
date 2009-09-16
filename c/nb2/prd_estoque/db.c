/*
    $RCSfile: db.c,v $
*/

char db_rcsid[] = "$Id: db.c 6 2006-09-10 15:35:16Z marcus $";

#include <stdio.h>
#include "db.h"

/*
    sub-rotinas de acesso aos arquivos
*/

//int select();           /* Lê um  registro   */
//int insert();           /* Insere registro   */
//int update();           /* Atualiza registro */
//int delete();           /* Remove registro   */

int delete(void)
{
    printf("\n   delete() \n");
    return 0 ;
    printf("%s", db_rcsid);
}

