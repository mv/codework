
### Perl < 5.10
    SWITCH: {
        if (/^abc/) { $abc = 1; last SWITCH; }
        if (/^def/) { $def = 1; last SWITCH; }
        if (/^xyz/) { $xyz = 1; last SWITCH; }
        $nothing = 1;
    }

    SWITCH: {
        /^abc/      && do { $abc = 1; last SWITCH; };
        /^def/      && do { $def = 1; last SWITCH; };
        /^xyz/      && do { $xyz = 1; last SWITCH; };
        $nothing = 1;
    }

### Perl >= 5.10

    use feature;

    given ($foo) {
        when (/^abc/) { $abc = 1; }
        when (/^def/) { $def = 1; }
        when (/^xyz/) { $xyz = 1; }
        default       { $nothing = 1; }
    }

# vim:ft=perl:

