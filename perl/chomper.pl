#!perl


# Simple slurp
my $script = do { local $/; <> };

$script =~ s|\n'|'|mg;

print $script

