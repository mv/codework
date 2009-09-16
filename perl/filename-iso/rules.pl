#!/usr/bin/perl
# $Id$
#
# Marcus Vinicius Ferreira    ferreira.mv[ at ]gmai.com
#
# Apply rules to file names
#

while( <> ) {
    next if /^#/;
    next if /^\s*$/;
    next unless /^A/;     # Validate added files only

    chomp;
    m/^A\b(.*)/; $_ = $1; # ignores 1st column

   if ( /[דץסביםףתאטלעשגךמפûח]/i ) {
       $err{'acentos'}++   ;
     # print $_, "\n";
   }
   if ( /\?\\\d\d\d/i ) { # octal
       $err{'acentos'}++   ;
     # print $_, "\n";
   }
   if ( /\s\w/ ) {
       $err{'espacos'}++   ;
       print $_, "\n";
   }
   if ( /[~\(\)\{\}\[\]]/ ) {
       $err{'invalidos'}++;
       print $_, "\n";
   }
   if ( /_-_|_d[aeo]s?_|_n[ao]s?_|_para_|_com_|_em_/ ) {
       $err{'excessos'}++  ;
       print $_, "\n";
   }
    if ( /relatorio d[aeo]s?|tela d[aeo]s?|processo d[aeo]s?/i ) {
        $err{'excessos'}++  ;
        print $_, "\n";
    }

}

print "\nNomes de arquivo invalidos:\n";
foreach (sort keys %err) {
    printf "    %-10s: %2d\n", $_, $err{$_};
}
print "\n";
