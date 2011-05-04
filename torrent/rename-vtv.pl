#!/usr/bin/env perl
#
# Remove "[VTV]" "[NoTV]" from filename
#
# 2011/05
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com.


use strict;

my $newname;

foreach my $filename (@ARGV) {

#   printf "argv: $filename \n";

    # Match: [VTV]. [NoTV].
    if ( $filename =~ /\[ .* tv \] [.] /xi ) {

        $newname = ${^PREMATCH} . ${^POSTMATCH};
        rename $filename,$newname;

        printf "  file: $filename \n";
        printf "rename: $newname \n\n";

    } # if

} # for

# printf "\n";

