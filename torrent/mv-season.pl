#!/usr/bin/env perl
#
# Move to Season dir
#
# 2011/05
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com.


use strict;
use File::Copy;

my $dirname;

foreach my $filename (@ARGV) {

#   printf "argv: $filename \n";

    # Match: Name.Snn
    if ( $filename =~ /(^ .* S[0-9][0-9]) E[0-9][0-9] /xi ) {

        $dirname = ${1};

        mkdir $dirname;
        move $filename,$dirname;

        printf "move to: ${dirname}/$filename\n";

    } # if

} # for

printf "\n";

