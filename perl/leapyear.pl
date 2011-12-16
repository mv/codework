
sub leapyear {
    my $year = shift;
    my $leapyear =
            $year %   4 ? 0 :
            $year % 100 ? 1 :
            $year % 400 ? 0 : 1;

    return $leapyear;
}

for (1970 .. 2020) {
    print "$_ : ", leapyear($_) ? "leap\n" : "\n";
}

# vim:ft=perl:

