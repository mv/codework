/*
** $Id: myftpd.c 6 2006-09-10 15:35:16Z marcus $
**
** myftp server
**
** Marcus Vinicius Ferreira
**
*/

#include <stdio.h>

#include "l4c.h"
#include "my_error.h"
#include "my_socket.h"

#include <sys/stat.h>
#include <sys/types.h>

#define PORTDEFAULT     5000
#define LISTENQ         3
#define MAX_CONN        2

int     work_conn( int fd );
int     send_msg ( char * buff );
void    the_end  ( int err );

int main( int argc, char *argv[] )
{
    l4c_init( L4ALL, "/tmp/myftpd.log" );

    /* Sockets */
    int                 i, port = PORTDEFAULT;
    int                 fd_listen, fd_conn;
    socklen_t           cli_len;
    struct sockaddr_in  addr_cli, addr_serv;
    struct protent      *proto;
    /* hostname */
    struct hostent      *haddr;
    char                myhost[HOSTNAME];
    /* fork */
    pid_t               child_pid;
    /* msg  */
    char                buff[MAXLINE];
    char                msgb[MAXLINE];


#   ifdef WIN32
    WSADATA wsaData;
    WSAStartup( 0x0101, &wsaData );
    l4c_warn( "Server [WIN32] defined.\n" );
#   elif  unix
    l4c_warn( "Server [unix] defined.\n" );
#   else
    l4c_warn( "Server undefined.\n" );
#   endif


    /*
    **
    ** Command line processing
    **
    */
    l4c_diag( "Parameters: %d\n", argc-1 );

    if( argc == 1 )
    {
        l4c_info( "   Using default port.\n" );
        l4c_info( "   Port = %d\n", port );
    }

    for( i = 1; i < argc; i++ )
    {
        l4c_diag( "   Param [%d] = [%s] \n", i, argv[i] );

        if ( strcmp( argv[i], "-port" ) == 0 )
        {
            if ( argv[i+1] == NULL )
            {
                l4c_error( "Missing port.\n" );
                fprintf( stderr, "\nMissing port.\n" );
                the_end( 2 );
            }
            else
            {
                i++;
                port = atoi( argv[i] );
                l4c_info( "   Port = %d\n", port );
            }
        }
        else
        {
            l4c_error( " Invalid option: %s\n", argv[i] );
            printf( "\n    Usage: %s -port <port number> \n\n", argv[0] );
            the_end( 1 );
        }
    }

    /*
    **
    ** Sockets! ( based on Stevens - UNP v2 )
    **
    */

    // Initialize server data
    bzero( &addr_serv, sizeof( addr_serv ) );
    addr_serv.sin_family      = AF_INET;
    addr_serv.sin_addr.s_addr = htonl( INADDR_ANY );
    addr_serv.sin_port        = htons( port );

    // Create socket to listen
    fd_listen = Socket( AF_INET, SOCK_STREAM, 0 );
    l4c_log( "Socket created.\n" );

    // Bind addr to socket
    Bind( fd_listen, ( SA * ) &addr_serv, sizeof( addr_serv ) );
    l4c_log( "Bind ok.\n" );

    // Listening
    Listen( fd_listen, LISTENQ );
    l4c_log( "Listening.\n" );

    // Server loop for MAX_CONN requests
    for ( i = 1; i <= MAX_CONN ; i++ )
    {
      //l4c_debug( "Accept...\n" );
        cli_len = sizeof( addr_cli );
        fd_conn = Accept( fd_listen, ( SA * ) &addr_cli, &cli_len );
        l4c_log( "Accepted connection [%3d]\n", i );

        l4c_log( "connection from %s, port %d\n"
               , inet_ntop( AF_INET, &addr_cli.sin_addr, buff, sizeof(buff) )
               , ntohs( addr_cli.sin_port )
               );
        printf ( "connection from %s, port %d\n"
               , inet_ntop( AF_INET, &addr_cli.sin_addr, buff, sizeof(buff) )
               , ntohs( addr_cli.sin_port )
               );


        /*
        ** pid == 0: child
        **           close listen ( just the parent listens )
        **           keeps conn   ( to process )
        **           process req
        ** pid != 0: parent
        **           close conn ( just child uses conn )
        **           keeps listen
        **           go back to the loop
        */

        /********/
        child_pid = fork() ;
        if ( child_pid == -1 )
        {
            l4c_fatal( "Cannot fork.\n" );
        }
        else if ( child_pid == 0 )
        {
            // CHILD process
            l4c_log( "    CONN process %d\n", getpid() );
            close( fd_listen );
            get_fnm( fd_conn );
            work_conn( fd_conn );
            l4c_log( "    CONN process %d : END\n", getpid() );
            exit( 0 );
        }
        /***********/

        // PARENT process
        close( fd_conn );
    }

    /*
    **
    ** END!
    **
    */
    sleep( 2 );
    l4c_warn( "Server end.\n" );
    the_end( 0 );
}

int work_conn( int fd )
{
    /*
    ** work connection
    ** (the hard work comes here)
    */
    sleep( 2 );

    FILE * fh;
    struct stat fs;
    int    bytes=0, total=0, remain=0, transfer=READ_SIZE, n, size=0;
    float  perc;
    char   buff[READ_SIZE];

    // Open file
    fh = fopen( "/tmp/1.jpg", "rb" );
    if( fh == NULL )
    {
        err_quit( "FILE not found on this server.\n" );
    }

    // File size
    n = ( stat( "/tmp/1.jpg", &fs ) );
    size = fs.st_size ;
    printf( "    Size: %d bytes.\n", size );

    // File scan
    while( !feof(fh) && total < size )
    {

        bytes = fread( buff, 1, transfer, fh );
      //printf( "Transfer: %4.2f %% - %d/%d/%d \n", perc, total, transfer, remain );
        printf( "Transfer: %4.2f %% \n", perc );

        // Will transfer READ_SIZE bytes until last batch.
        // Last batch to transfer will be "remain" bytes
        remain = size - ( READ_SIZE + total);
        transfer = remain > READ_SIZE ? READ_SIZE : remain;

        total += bytes;
        perc = ((float) total / (float) fs.st_size) * (float) 100;

      //Write( fd, buff, remain );
        Write( fd, buff, READ_SIZE );
    }
    printf( "\n    Sent: %d bytes of %d bytes\n", total, size );
    l4c_log( "    Tranfered: %d bytes.\n", total );

    if( n = fclose( fh ) )
    {
        err_quit( "ERROR closing file: %d.\n", n );
    }

    sleep( 2 );
    return 0;
}

void the_end( int err )
{
    printf( "\n\n" );
    l4c_info( "-- END = %d.\n", err );
    l4c_end;
}

int send_msg( char * msg )
{

//  snprintf(msgb, READ_SIZE, "%s", msg );
//  Write(connfd, msgb, READ_SIZE );

    return 0;
}

int get_fnm( int fd )
{
    /*
    ** get file name (from the client)
    */
    return 0;
    sleep( 2 );

    static char fnm[FILENAME];
    int    rd;

    rd = Read(fd, fnm, FILENAME);
    if( rd < 1 )
    {
        l4c_error( "No FILENAME from client received.\n");
    }
    l4c_log( "    Client: filename=[%s]\n", fnm);

    return 0;
}
