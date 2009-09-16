#!/usr/bin/perl 
#
# $Id: put_Id_header.pl 6 2006-09-10 15:35:16Z marcus $
#
# Coloca HEADER nos scripts de VIEWS
#
# Marcus Vinicius Ferreira  Abr/2003
#

# $1: ddl
# $2: view name
# $3: "is" ou "as"

# Para alterar extensões de arquivo:
# command line :
#  $ for f in *.vw; do mv $f ${f%.*} ; done                 # tira .ext
#  $ for f in vw*; do hr_vw.pl $f > ${f%.*}.vw; done     # coloca header

while (<>) {

    s/(create or replace view) (\w+) (.s)/$1 $2 $3
--------------------------------------------------------
-- \$Id\$
--
-- CAS - versao IMATURA, pre-producao
--
--/i ;  # regex here!!!!

    print ;
    
}

exit;
