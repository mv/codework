
PROGS = myftp myftpd
OBJ = l4c.o my_error.o my_socket.o

CC=gcc
CFLAGS = -O2

%.o : %.c
	$(CC) $(CFLAGS) -c $<

all:	${PROGS}

dep:	${OBJ}

myftp:	myftp.o ${OBJ}
	${CC} ${CFLAGS} ${OBJ} myftp.o -o $@ 

myftpd:	myftpd.o ${OBJ}
	${CC} ${CFLAGS} ${OBJ} myftpd.o -o $@ 

clean:
	/bin/rm -f ${PROGS} *.o ~* *.stackdump
	chmod 664 *.c *.h

rm:
	/bin/rm -f *.o ~* *.stackdump
	chmod 664 *.c *.h

