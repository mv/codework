#!perl
# $Id$
#
# adpck.pl
#     Check file for: $Header$, $Id$, exit at end, WHENEVER, CONNECT
#
# 2006/Set

my %info_for;
my @ptt;

$ptt[0] = qr{ ( [\$] Header .* [\$] ) }x;
$ptt[1] = qr{ ( [\$] Header: \s* $file .* [\$] [_| ]* ) }x;
$ptt[2] = qr{ ( [\$] Header: \s* %f% \s* %v% \s* %d% \s* %u% \s* ship \s* [\$] [_| ]* ) }x;
$ptt[3] = qr{ ( [\$] Id     .* [\$] ) }x;
$ptt[4] = qr{ ^ \s* WHENEVER \s+ SQLERROR \s+ EXIT \s+ FAILURE \s+ ROLLBACK \s* \n+
                \s* CONNECT  \s+ &1/&2 }x;

if( ! @ARGV ) {
    opendir my $dir, "." or die "Cannot open current dir: $!";
    @ARGV = readdir($dir);
    close $dir;
}

for my $file ( @ARGV ) {

    next unless -f $file;

    $info_for{$file}->{'name'}= $file;

    my $len = length $file;
    $info_for{$file}->{'len'} = $len;
    $info_for{$file}->{'len'} = '*' . $len if $len > 30;

    open my $fh, "<", $file or die "Cannot open $file: $!";
  # my $code = do {local $/; <$fh>};
    my @code = <$fh>;
    my $code = join '',@code;
    close $fh;

    if( -T $file ) {
        $info_for{$file}->{'type'}= 'txt' ;
        if($code =~ m{\r}){$info_for{$file}->{'dos'} = 'Dos'  ; }
                     else {$info_for{$file}->{'dos'} = 'Unix' ; }
        if($code =~ m{\t}){$info_for{$file}->{'tab'} = 'Error'; }
                     else {$info_for{$file}->{'tab'} = 'Ok'   ; }

        if($code =~ $ptt[3]) { $info_for{$file}->{'id'} = "Ok" ; }
        else                 { $info_for{$file}->{'id'} = "Err"; }
        if($code =~ $ptt[4]) { $info_for{$file}->{'when'} = "Ok";  }
        else                 { $info_for{$file}->{'when'} = "Err"; }

        # Look backward
        $info_for{$file}->{'exit'} = "Err";
        for my $line ( reverse 0 .. $#code ) {
            $info_for{$file}->{'exit'} = "Ok"  if $code[$line] =~ m/^ \s* exit/xi;
            last if $code[$line] =~ m/^ \s* [a-z] /xi; ## qq palavra-chave: aborta
        }
    }
    else {
        $info_for{$file}->{'type'} = 'bin' ;
    }

    $info_for{$file}->{'hdr'}  = 'Err' ;
    for my $i (0 .. 2) {
        $info_for{$file}->{'hdr'}  = "Ok:Hdr " .$i if $code =~ $ptt[$i];
    }
}

print "FileName                            NameLen Tabs  Unix  Header    Id  When Exit\n";
print "----------------------------------- ------- ----- ----- --------- --- ---- ----\n";

foreach my $file (sort keys %info_for) {
     printf "%-35s %7d %-5s %-5s %-9s %-3s %-4s %-4s\n"
        , $file
        , $info_for{$file}->{'len'} || '-'
        , $info_for{$file}->{'tab'} || '-'
        , $info_for{$file}->{'dos'} || '-'
        , $info_for{$file}->{'hdr'} || '-'
        , $info_for{$file}->{'id'}  || '-'
        , $info_for{$file}->{'when'}|| '-'
        , $info_for{$file}->{'exit'}|| '-'
        ;
}

1;
