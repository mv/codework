/* set_fprio - more careful fixed priority setting utility */
/* Ref: www.aeleen.com
 *      Essential System Administraton
 */

#include <sys/sched.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

main(argc,argv)
char *argv[];
int argc;
{
pid_t pid;
int p, old;
/* make sure root is running this */
if (getuid() != (uid_t)0) {
   printf("You must be root to run setp.\n");
   exit(1);
   }

/* check for the right number of arguments */
if (argc < 3) {
   printf("Usage: setp pid new-priority\n");
   exit(1);
   }

/* convert arguments to integers */
pid=(pid_t)(atoi(*++argv));
p=atoi(*++argv);
old=setpri(pid,p);   /* save and check return value */
if (old==-1) {
   printf("Priority reset failed for process %d.\n",(int)pid);
   exit(1);
   }
else {
   printf("Changing priority of process %d from %d to %d.\n", (int)pid,old,p);
   exit(0);
   }
}
