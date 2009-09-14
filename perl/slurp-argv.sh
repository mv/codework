
perl -e '
    foreach my $f (@ARGV)
    {
        print "File: $f\n";
        open my $in, "<", $f;
        my $txt = do { local $/; <$in> };
        close $in;

        $txt =~ s/\n \s* \n \s* \n/\n\n/xmg;
       #$txt =~ s/\n \s* \n       /\n  /xmg;

        open my $out, ">", "${f}.bak";
        print $out $txt;
        close $out;
    }
' u115wip406_009*

