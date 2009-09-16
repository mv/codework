/*
** $Id: my_socket.h 6 2006-09-10 15:35:16Z marcus $
**
** my_socket.h
** "my_socket": routines based on Richard Stevens examples
**
** Created
**     Marcus Vinicius Ferreira  Mar/2005
**
*/

#   ifdef WIN32

#include <windows.h>
#include <winsock.h>
#define  bzero( ptr,n )    memset( ptr, 0, n )

#   else

#include <sys/types.h>      // socklen_t
#include <sys/socket.h>     // struct sockaddr, ...
#include <netinet/in.h>     // sockaddr_in
#include <strings.h>        // bzero

#   endif

#define SA              struct sockaddr
#define SAI             struct sockaddr_in
#define HOSTNAME        255
#define MAXLINE         4096
#define READ_SIZE       1000
#define FILENAME        1024

#ifndef INET_ADDRSTRLEN
#define INET_ADDRSTRLEN 16
#endif
