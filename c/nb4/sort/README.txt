
Subprogramas Genericos
    printArray.c
    loadArray.c

Especificos de Sort

    main    Algoritmo/Implementacao
    ----    -----------------------
    b.c     BubbleSort1.c
    b.c     BubbleSort2.c
    sl.c    SelectSort1.c
    sh.c    ShellSort1.c
    sh.c    ShellSort2.c

Compilando:

    Para usar BubbleSort1 (b1.exe)
    gcc loadArray.c printArray.c BubbleSort1.c b.c -o b1

    Para usar BubbleSort2 (b2.exe)
    gcc loadArray.c printArray.c BubbleSort2.c b.c -o b2

    e assim sucessivamente......

    ou: make b1
        make b2
        etc....