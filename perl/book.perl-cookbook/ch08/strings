#!/usr/bin/perl
# strings - pull strings out of a binary file
$/ = "\0";
while (<>) {
    while (/([\040-\176\s]{4,})/g) {
        print $1, "\n";
    }
}
