/*
** $Id: myping.c 6 2006-09-10 15:35:16Z marcus $
**
** Wrapper for ping.pl (using ICMP)
**
**
**   $ gcc -o myping myping.c
**   $ su -
**   # install -m 4750 -o root -g root myping /usr/local/bin
**
** Created
**   Marcus Vinicius Ferreira   Out/2004
**
*/

#include <unistd.h>

int main (int argc, char *argv[])
{
    char _id[]="$Id: myping.c 6 2006-09-10 15:35:16Z marcus $";

    /*
    ** Executa como ROOT
    */
    setuid(0);

    /*
    ** execve ( comando, parametros, ambiente )
    */

    return execve( "/usr/local/bin/ping.pl" , argv, NULL ) ;

}
