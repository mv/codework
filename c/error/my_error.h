/*
** $Id: my_error.h 6 2006-09-10 15:35:16Z marcus $
**
** my_error.h
** "my_error": routines based on Richard Stevens examples
**
** Created
**     Marcus Vinicius Ferreira  Mar/2005
**
*/


/*              SystemCall      Quit
** err_sys          Y             Y
** err_ret          Y             N
** err_quit         N             Y
** err_msg          N             N
**
*/

void err_sys( const char *fmt, ... );
void err_ret( const char *fmt, ... );
void err_quit( const char *fmt, ... );
void err_msg ( const char *fmt, ... );
