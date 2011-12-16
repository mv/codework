#!/usr/bin/perl

# hashes
#

# lista
# transforma cada sequencia de 2 num par (chave, valor)
%hash = qw( mv  MarcusVinicius
            mn  MargareteNishimura
            pl  Perl
            sql SQL
            c   C/C++
            pc  Pro*C
    );

# debug
# @array = %hash;
# print "Valores [ @array ] \n ";
# print "Valores [ %hash ] \n ";

print "\n Qte de elementos " . keys(%hash) . "\n\n";

foreach $key ( keys(%hash) ){
    print " Key: $key \t= $hash{$key} \n";
};

# values: retorna valor do hash
print "\n\n Valores \n";
foreach $vlr ( values(%hash) ){
    print " Valores: $vlr \n";
};

# key: retorna key do hash
print "\n\n Chaves \n";
foreach $key ( keys(%hash) ){
    print " Chaves: $key \n";
};

# each: fornece key + value
print "\n\n Pares \n";
while ( @par = each(%hash) ){
    print " Pares: @par \n";
};

print "\n\n  FIM \n";
