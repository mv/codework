
    $home = $ENV{HOME}
        || $ENV{LOGDIR}
        || (getpwuid($<))[7]
        || die "You're homeless!\n";

# vim:ft=perl:

