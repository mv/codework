/* yes.c */
/* Ref: www.aeleen.com
 *      Essential System Administraton
 */

#include <stdio.h>

main(argc,argv)
int argc;
char *argv[];
{
while(1)                   /* repeat forever */
   if(argc>=2)             /* if there was an argument */
      puts(argv[1]);       /* repeat it */
   else
      puts(argv[0]);       /* otherwise use command's name */
}

