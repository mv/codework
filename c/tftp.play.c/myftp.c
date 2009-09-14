/*
** $Id: myftp.c 149 2005-03-29 21:19:01Z marcus $
**
** myftp client
**
** Marcus Vinicius Ferreira
**
*/

#include <stdio.h>

#include "l4c.h"
#include "my_error.h"
#include "my_socket.h"

char    *host;
char    *port;
char    *filename;
char    *localname;

int usage( char *prg )
{
    printf( "\n    Usage: %s -host <host ip> -port <port number> -file <filename>\n\n", prg );
    exit( 1 );
}

int main (int argc, char *argv[])
{
    ssize_t     rd, wr;
    int         sockfd, n, i, total=0

    ;
    socklen_t   len;
    char        buff[READ_SIZE];
    SAI         servaddr, cliaddr;

    FILE*       fh;

    if( argc < 9 )
    {
        usage( argv[0] );
    }

    l4c_init( L4ALL, "/tmp/myftp.log" );

    l4c_diag( "Parameters: %d\n", argc );
    for( i = 1; i < argc; i+=2 )
    {
        l4c_debug( "    Param [%d] = [%s] \n", i, argv[i] );

        if ( strcmp(argv[i], "-port") == 0 )
        {
            if ( argv[i+1] == NULL)
            {
                l4c_error( "Missing port.\n" );
                fprintf( stderr, "\nMissing port.\n" );
                exit( 2 );
            }
            else
            {
                port = argv[i+1];
                l4c_info("    Port = %s\n", port);
            }
        }
        if ( strcmp(argv[i], "-host") == 0 )
        {
            if ( argv[i+1] == NULL)
            {
                l4c_error( "Missing host ip.\n" );
                fprintf( stderr, "\nMissing host ip.\n" );
                exit( 3 );
            }
            else
            {
                host = argv[i+1];
                l4c_info("    Host = %s\n", host);
            }
        }
        if ( strcmp(argv[i], "-file") == 0 )
        {
            if ( argv[i+1] == NULL)
            {
                l4c_error( "I need a filename.\n" );
                fprintf( stderr, "\nMissing filename.\n" );
                exit( 4 );
            }
            else
            {
                filename = argv[i+1];
                l4c_info("    Filename = %s\n", filename);
            }
        }
        if ( strcmp(argv[i], "-local") == 0 )
        {
            if ( argv[i+1] == NULL)
            {
                l4c_error( "I need a local filename.\n" );
                fprintf( stderr, "\nMissing local filename.\n" );
                exit( 4 );
            }
            else
            {
                localname = argv[i+1];
                l4c_info("    Localname = %s\n", localname);
            }
        }
    }

    /* New client Socket */
    if ( (sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
        err_sys("socket error");

    /* Params */
    bzero(&servaddr, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port   = htons( atoi(port) );
    if (inet_pton(AF_INET, host, &servaddr.sin_addr) <= 0)
        err_quit("inet_pton error for %s", host);

    /* Connect to Server */
    if (connect(sockfd, (SA *) &servaddr, sizeof(servaddr)) < 0)
        err_sys("connect error");


    /* Create local file */
    fh = fopen( localname, "wb" );
    if( fh == NULL )
    {
        err_quit( "Cannot create file.\n" );
    }

    printf( "Server file: %s\n", filename );
    printf( " Local file: %s\n", localname);

    /* Transfer file and write local */
    /****/
    while ( (rd = Read(sockfd, buff, READ_SIZE)) > 0)
    {
        wr = fwrite( buff, 1, READ_SIZE, fh );
        total += wr ;
        printf( "Tranfer: read %d, write %d, total %d \n", rd, wr,total );
    }
    printf( "\n  Total: %d\n", total );
    l4c_log( "File: %s %d bytes\n", localname, total );
    /****/


    l4c_info( "%s : END.\n", argv[0] );
    l4c_end;
}

void    param( char * p )
{
    l4c_debug( "%s\n", p );
/*  if( strcmp() )
    {

    }
    else if( strcmp() )
    {

    }
*/
}
