#!/usr/bin/perl


#kitty: just like cat

# <> : lê os arquivos fornecidos via command line
#      i.e., processa a lista de @ARGV

# ex: @ARGV = qw( hash1.pl ask.pl );
while ( <> ) {

    # procura /perl/ em $_
    if (/perl/){
        print $_;
    }

}