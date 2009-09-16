/*
** $Id: my_socket.c 6 2006-09-10 15:35:16Z marcus $
**
** my_socket.h
** "my_socket": routines based on Richard Stevens examples
**
** Created
**     Marcus Vinicius Ferreira  Mar/2005
**
*/

#include "my_error.h"
#include "my_socket.h"

#include <errno.h>

int Socket( int family, int type, int protocol )
{
    int n;

    n = socket( family, type, protocol );
    if ( n < 0 )
        err_sys( "my_socket: Socket error." );

    return( n );
}

void Connect( int fd, const SA *sa, socklen_t sa_len )
{
    if ( connect( fd, sa, sa_len ) < 0  )
        err_sys( "my_socket: Connect error." );
}

void Bind( int fd, const SA *sa, socklen_t sa_len )
{
    if ( bind( fd, sa, sa_len ) < 0 )
        err_sys( "my_socket: Bind error." );
}

void Listen( int fd, int backlog )
{
    char    *ptr;

    if ( listen( fd, backlog ) < 0 )
        err_sys( "my_socket: Listen error." );
}

int Accept(int fd, SA *sa, socklen_t *sa_len_ptr)
{
    int n;

    n = accept(fd, sa, sa_len_ptr);
    if ( n < 0)
        err_sys("my_socket: Accept error.");

    return(n);
}

void Write(int fd, void *ptr, size_t nbytes)
{
    if (write(fd, ptr, nbytes) != nbytes)
        err_sys("my_socket: Write error");
}

ssize_t Read(int fd, void *ptr, size_t nbytes)
{
    ssize_t     n;

    if ( (n = read(fd, ptr, nbytes)) == -1)
        err_sys("read error");
    return(n);
}

/*
** Network TO Presentation: binary -> xx.xx.xx.xx
*/
const char *
inet_ntop(int family, const void *addrptr, char *strptr, size_t len)
{
    const u_char *p = (const u_char *) addrptr;
    char  temp[INET_ADDRSTRLEN];

    if (family == AF_INET)
    {
        snprintf(temp, sizeof(temp), "%d.%d.%d.%d"
                                   , p[0], p[1], p[2], p[3]
                                   );
        if (strlen(temp) >= len)
        {
            errno = ENOSPC;
            return (NULL);
        }
        strcpy(strptr, temp);
        return (strptr);
    }
    errno = EAFNOSUPPORT;
    return (NULL);
}

/*
** Presentation TO Network : xx.xx.xx.xx -> binary
*/
int
inet_pton(int family, const char *strptr, void *addrptr)
{
    if (family == AF_INET) {
        struct in_addr  in_val;

        if (inet_aton(strptr, &in_val)) {
            memcpy(addrptr, &in_val, sizeof(struct in_addr));
            return (1);
        }
        return(0);
    }
    errno = EAFNOSUPPORT;
    return (-1);
}
