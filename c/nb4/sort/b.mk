CC = gcc
FLAGS = -Wall

%.o : %.c
	# Sub-Rotinas
	$(CC) -c $<

SUBROTINAS = loadArray.o printArray.o

BUBBLE=$(SUBROTINAS) b.o
B1=

b1: $(BUBBLE) BubbleSort1.o
	# BubbleSort 1
	gcc $(FLAGS) -o b1 $(BUBBLE) BubbleSort1.o

b2: $(BUBBLE) BubbleSort2.o
	# BubbleSort 2
	gcc $(FLAGS) $< -o $@

clean:
	# Clean
	/bin/rm -f *.o core *.exe *.exe.*
