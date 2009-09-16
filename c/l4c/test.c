/*
** $Id: test.c 6 2006-09-10 15:35:16Z marcus $
** Marcus Vinicius Ferreira
**
*/

#include <stdio.h>
#include "l4c.h"

int
main (int argc, char *argv[])
{
    int     l4c_file;

    l4c_init( L4ALL, "/tmp/test_l4c.log");

    l4c_fatal("Here is a log 1\n");
    l4c_error("Here is a log 2\n");
    l4c_warn ("Here is a log 3\n");

    l4c_log  ("Here is a log 4\n");

    l4c_info   ("Here is a log 5\n");
    l4c_verbose("Here is a log 6\n");
    l4c_diag   ("Here is a log 7\n");
    l4c_debug  ("Here is a log 8\n");

    l4c_end;
}
