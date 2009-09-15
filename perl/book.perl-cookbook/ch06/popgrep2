#!/usr/bin/perl
# popgrep2 - grep for abbreviations of places that say "pop"
# version 2: eval strings; fast but hard to quote
@popstates = qw(CO ON MI WI MN);
$code = 'while (defined($line = <>)) {';
for $state (@popstates) {
    $code .= "\tif (\$line =~ /\\b$state\\b/) { print \$line; next; }\n";
}
$code .= '}';
print "CODE IS\n----\n$code\n----\n" if 0;  # turn on to debug
eval $code;
die if $@;
