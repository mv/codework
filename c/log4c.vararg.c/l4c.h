/*
** $Id: l4c.h 148 2005-03-23 03:43:31Z marcus $
**
** l4c.h
** "log 4 c" facility
**
** Created
**     Marcus Vinicius Ferreira  Mar/2005
**
*/

#define L4NONE      0
#define L4FATAL     1
#define L4ERROR     2
#define L4WARN      3
#define L4LOG       4
#define L4INFO      5
#define L4VERBOSE   6
#define L4DIAG      7
#define L4DEBUG     8
#define L4ALL       9

int     l4c_init    ( int loglevel, char *filename );
void    l4c_end     ( void );

void    l4c_setlevel( int loglevel );

void    l4c_fatal   ( char *msg, ... );
void    l4c_error   ( char *msg, ... );
void    l4c_warn    ( char *msg, ... );
void    l4c_log     ( char *msg, ... );
void    l4c_info    ( char *msg, ... );
void    l4c_verbose ( char *msg, ... );
void    l4c_diag    ( char *msg, ... );
void    l4c_debug   ( char *msg, ... );
