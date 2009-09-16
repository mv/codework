/*
** $Id: my_error.c 6 2006-09-10 15:35:16Z marcus $
**
** my_error.h
** "my_error": routines based on Richard Stevens examples
**
** Created
**     Marcus Vinicius Ferreira  Mar/2005
**
*/

#include    <errno.h>
#include    <stdio.h>
#include    <stdarg.h>
#include    <syslog.h>
#define     MAX_LINE    4096

static void     err_doit( int, int, const char *, va_list );
static va_list  ap;

/*              SystemCall      Quit
** err_sys          Y             Y
** err_ret          Y             N
** err_quit         N             Y
** err_msg          N             N
**
*/

void err_sys( const char *fmt, ... )
{
    va_start( ap, fmt );
    err_doit( 1, LOG_ERR, fmt, ap );
    va_end( ap );
    exit( 1 );
}

void err_ret( const char *fmt, ... )
{
    va_start( ap, fmt );
    err_doit( 1, LOG_INFO, fmt, ap );
    va_end( ap );
    return;
}

void err_quit( const char *fmt, ... )
{
    va_start( ap, fmt );
    err_doit( 0, LOG_ERR, fmt, ap );
    va_end( ap );
    exit( 1 );
}

void err_msg( const char *fmt, ... )
{
    va_start( ap, fmt );
    err_doit( 0, LOG_INFO, fmt, ap );
    va_end( ap );
    return;
}

static void err_doit( int errnoflag, int level, const char *fmt, va_list ap )
{
    int     errno_save, n;
    char    buf[MAX_LINE];

    errno_save = errno;
    vsnprintf( buf, sizeof( buf ), fmt, ap );

    n = strlen( buf );
    if ( errnoflag )
        snprintf( buf+n, sizeof( buf )-n, ": %s", strerror( errno_save ) );

    strcat( buf, "\n" );
    fflush( stdout );     /* in case stdout and stderr are the same */
    fputs ( buf, stderr );
    fflush( stderr );

    return;
}
