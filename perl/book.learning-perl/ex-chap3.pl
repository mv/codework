#!/usr/bin/perl

# Invertendo as linhas do texto

# <STDIN> como array: CTRL+D finaliza input


print "Entre texto : \n----------\n";
@a = <STDIN> ;
print "----------\n";

print "Texto \n[" . reverse(@a) . "\n] \n";
