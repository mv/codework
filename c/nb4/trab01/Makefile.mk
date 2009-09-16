CC = gcc
FLAGS = -Wall

%.o : %.c
	$(CC) -c $<

SUBROTINAS = loadArray.o printArray.o

BUBBLE = b.o $(SUBROTINAS)
B1 = $(BUBBLE) BubbleSort1.o
B2 = $(BUBBLE) BubbleSort2.o

SELECT = sl.o $(SUBROTINAS) SelectionSort.o
INSERT = ins.o $(SUBROTINAS) InsertionSort.o
QUICK  = qs.o   $(SUBROTINAS) QuickSort.o
SHAKER = shk.o   $(SUBROTINAS) ShakerSort.o

b1: $(B1)
	# BubbleSort 1
	gcc $(FLAGS) $(B1) -o $@

b2: $(B2)
	# BubbleSort 2
	gcc $(FLAGS) $(B2) -o $@

sl: $(SELECT)
	# SelectionSort
	$(CC) $(FLAGS) $(SELECT) -o $@

ins: $(INSERT)
	# InserctionSort
	$(CC) $(FLAGS) $(INSERT) -o $@

qs: $(QUICK)
	# QuickSort
	$(CC) $(FLAGS) $(QUICK) -o $@

shk: $(SHAKER)
	# Shaker
	$(CC) $(FLAGS) $(SHAKER) -o $@

all: b1 b2
	#make $<

clean:
	# Clean
	/bin/rm -f *.o core *.exe *.exe.*

cl:
	# Clean2
	/bin/rm -f *.o core *.exe.*
