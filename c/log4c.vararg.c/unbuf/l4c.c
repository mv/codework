/*
** $Id$
** A very very simple "log for c" implementation
**
** Marcus Vinicius Ferreira     Mar/2005
**
*/

#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include "l4c.h"

/* Private variables */
static int  l4c_g_log_handle;
static int  l4c_g_log_level;
char        buf[20];

int     l4c__put( char *fmt);

int
l4c_init( int loglevel, char *filename )
{
    /* Create file, unbuffered */
    l4c_g_log_handle = open(filename, O_RDWR | O_APPEND | O_CREAT);
    if( l4c_g_log_handle < 0 )
    {
        printf("l4c: Error opening log! %d \n",l4c_g_log_handle );
        return 1;
    }

    /* Initial log level */
    l4c_g_log_level = loglevel;
    l4c__put("l4c: Init ok\n");

    return 0;
}

void
l4c_end(void)
{
    l4c__put("l4c: End.\n");
    close(l4c_g_log_handle);

};

void
l4c_setlevel( int loglevel )
{
    if( loglevel >= L4FATAL && loglevel <= L4DEBUG )
        l4c_g_log_level = loglevel;
}

/************************************************/
void
l4c_fatal( char *msg )
{
    if( l4c_g_log_level <= L4FATAL )
        l4c__put( msg );
}

void
l4c_error( char *msg )
{
    if( l4c_g_log_level <= L4ERROR )
        l4c__put( msg );
}

void
l4c_warn( char *msg )
{
    if( l4c_g_log_level <= L4WARN )
        l4c__put( msg );
}

void
l4c_log( char *msg )
{
    if( l4c_g_log_level <= L4LOG )
        l4c__put( msg );
}

void
l4c_info( char *msg )
{
    if( l4c_g_log_level <= L4INFO )
        l4c__put( msg );
}

void
l4c_verbose( char *msg )
{
    if( l4c_g_log_level <= L4VERBOSE )
        l4c__put( msg );
}

void
l4c_diag( char *msg )
{
    if( l4c_g_log_level <= L4DIAG  )
        l4c__put( msg );
}

void
l4c_debug( char *msg )
{
    if( l4c_g_log_level <= L4DEBUG )
        l4c__put( msg );
}

/*
**                            **
**   Private to this file     **
**                            **
*/

void
iso_time(char *buf)
{
    time_t      now_t;
    struct tm   *now;

    time(&now_t);
    now = localtime(&now_t);

    /* 2005-03-03 12:12:00 */
    strftime( buf, 20, "%Y-%m-%d %H:%M:%S\0", now );

}

int
l4c__put( char *fmt)
{
    int     len = 0;
    char    mytime[20];

    iso_time( mytime );
    write(l4c_g_log_handle, mytime, 20);

    while( *fmt++ )
        { len++; }
    write(l4c_g_log_handle, fmt, len);
    return 0;
}

