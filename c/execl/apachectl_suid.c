/*
**  suid to make apache/svn bind to port 80
**
**  Marcus Vinicius Ferreira   ferreira.mv[ at ]gmail.com
**  Out/2006
**
**  # gcc -o apachectl suid.c
**	# chown root:svn apachectl
**	# chmod +s apachectl
**  # cp apachectl /u01/subversion/local/bin
**
*/

#include <unistd.h>

int
main (int argc, char *argv[])
{
    char svn_id[]="$Id: apachectl_suid.c 2200 2006-10-25 19:33:11Z marcus.ferreira $";
    char *env [1];
    char *arg [3];

    env[0] = NULL;	// No additional env

    /*
    ** httpd -k start|stop|restart
    */
    arg[0] = "-k";
    arg[2] = NULL;
    if (argc == 2){ arg[1] = argv [1]; 	}
    else          { arg[1] = NULL;		}

    /*
    ** Oh, yeah, baby
    */
    setuid (0);

    // Finally
    execve ("/u01/subversion/local/apache/bin/apachectl", arg, env);

    return 0;
}
