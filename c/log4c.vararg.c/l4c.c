/*
** $Id: l4c.c 149 2005-03-29 21:19:01Z marcus $
** A very very simple "log for c" implementation
**
** Marcus Vinicius Ferreira     Mar/2005
**
*/

#include <stdio.h>
#include <stdarg.h>
#include <fcntl.h>
#include "l4c.h"

/* Private variables */
static FILE *   l4c_handle;
static int      l4c_level;

static int      l4c_put( char *label, char *fmt, va_list ap );
static char *   level( void );

va_list         args;

int
l4c_init( int loglevel, char *filename )
{
    /* Create file, unbuffered */
    l4c_handle = fopen(filename, "a");
    if( l4c_handle == NULL )
    {
        printf("l4c: Error opening log! %d \n",l4c_handle );
        return 1;
    }

    /* Initial log level */
    l4c_level = loglevel;
    l4c_log ( "-------\n");
    l4c_log ( "Init ok\n" );
    l4c_log ( "-------\n");

    return 0;
}

void
l4c_end(void)
{
    l4c_log ( "End.\n" );
    fflush( l4c_handle );
    fclose( l4c_handle );
};

void
l4c_setlevel( int loglevel )
{
    if( loglevel >= L4FATAL && loglevel >= L4DEBUG )
        l4c_level = loglevel;
}

/************************************************/
void
l4c_fatal( char *msg, ... )
{
    va_start( args, msg );
    fprintf( stderr, msg, args );
    if( l4c_level >= L4FATAL )
    {
        l4c_put( "FATAL", msg, args );
    }
    va_end( args );
}

void
l4c_error( char *msg, ... )
{
    va_start( args, msg );
    fprintf( stderr, msg, args );
    if( l4c_level >= L4ERROR )
    {
        l4c_put( "ERROR", msg, args );
    }
    va_end( args );
}

void
l4c_warn( char *msg, ... )
{
    if( l4c_level >= L4WARN )
    {
        va_start( args, msg );
        fprintf( stderr, msg, args );
        l4c_put( " WARN", msg, args );
        va_end( args );
    }
}

void
l4c_log( char *msg, ... )
{
    if( l4c_level >= L4LOG )
    {
        va_start( args, msg );
        l4c_put( "  LOG", msg, args );
        va_end( args );
    }
}

void
l4c_info( char *msg, ... )
{
    if( l4c_level >= L4INFO )
    {
        va_start( args, msg );
        l4c_put( " INFO", msg, args );
        va_end( args );
    }
}

void
l4c_verbose( char *msg, ... )
{
    if( l4c_level >= L4VERBOSE )
    {
        va_start( args, msg );
        l4c_put( "VERBO", msg, args );
        va_end( args );
    }
}

void
l4c_diag( char *msg, ... )
{
    if( l4c_level >= L4DIAG  )
    {
        va_start( args, msg );
        l4c_put( " INFO", msg, args );
        va_end( args );
    }
}

void
l4c_debug( char *msg, ... )
{
    if( l4c_level >= L4DEBUG )
    {
        va_start( args, msg );
        l4c_put( "DEBUG", msg, args );
        va_end( args );
    }
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
l4c_put( char *label, char *fmt, va_list ap )
{
    char    mytime[24];
    char    buf[1024];

    vsprintf( buf, fmt, ap );
    iso_time( mytime );
    fprintf( l4c_handle, "[%s] %s - %s", mytime, label, buf );
    fflush ( l4c_handle );

    return 0;
}
