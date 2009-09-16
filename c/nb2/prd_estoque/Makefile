# $Id: Makefile 6 2006-09-10 15:35:16Z marcus $
# Usando macros

# gcc $(CFLAGS) -o cco-estoque main_cco_estoque.c mod*.c db.c
# Default do make:
#   gcc -o program.o -c program.c
#   gcc -c program.c
#   -o : output
#   -c : compile only

# Dependecias
DEPENDS = db.o          \
	main_cco_estoque.o  \
	mod_menu.o          \
	mod_alteracao.o     \
	mod_atu_qtd.o       \
	mod_consolidacao.o  \
	mod_consulta.o      \
	mod_exclusao.o      \
	mod_insercao.o      \
	mod_relatorio.o		\
	mod_ajuda.o

DEP_DBG = db.do         \
	main_cco_estoque.do \
	mod_menu.do         \
	mod_alteracao.do    \
	mod_atu_qtd.do      \
	mod_consolidacao.do \
	mod_consulta.do     \
	mod_exclusao.do     \
	mod_insercao.do     \
	mod_relatorio.do	\
	mod_ajuda.do

# Programa final e versão de debug
OUTPUT = cco_estoque
DBGPUT = dbg_estoque

# Opções de compilação
CC = gcc
CFLAGS = -W
DEBUG = -DDEBUG -g

#
## Regras
##  por SUFIXOS, ou
##  por PATTERNS (GNU make)
#

# Usando sufixos: limpa a lista E define na 2a. chamada
#.SUFFIXES:
#.SUFFIXES: .c .o .do
#
# Regra 1: cada ".o" depende de ".c"
#.c.o:; gcc $(CFLAGS) -o $@ -c $<
#
# Regra 2: em debug cada ".do" depende de ".c"
#.c.do:; gcc $(DEBUG) $(CFLAGS) -c -o $@ $<
#
# $@ - target name
# $* - target without extension
# $< - source file ( *.c )
#
# gcc -c mod_alteracao.c
# gcc -c $*.c
# (output padrão de -c é um arquivo ".o" )


# Usando PATTERNS
%.o : %.c
	$(CC) $(CFLAGS) -c $<

# Quando debug é desejado ( output "*.do" )
%.do : %.c
	$(CC) $(CFLAGS) $(DEBUG) -o $@ -c $<

#
## Targets
#
# Exemplo de target
#
# target: prg1.o prg2.o etc... ( i.e, "*.o" = módulos de dependência )
#

cco_estoque: $(DEPENDS)
	$(CC) $(CFLAGS) -o $(OUTPUT) $(DEPENDS)
	# ".exe" ocorre no Cygwin
	ln -s $(OUTPUT).exe $(OUTPUT)
	ident $(OUTPUT)

debug: $(DEP_DBG)
	#
	# DEBUG enabled
	#
	$(CC) $(DEBUG) -o $(DBGPUT) $(DEP_DBG)
	ln -s $(DBGPUT).exe $(DBGPUT)
	ident $(DBGPUT)

clean:
	rm $(OUTPUT).exe $(OUTPUT) $(DBGPUT) $(DBGPUT).exe *.o *.do
	chmod 664 *.c
	chmod 775 *.exe
