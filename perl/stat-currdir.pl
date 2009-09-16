
$dirname=".";
$order=0;
$ac_size=0;
$ac_blk_tape=0;

sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}

opendir(DIR, $dirname)
    or die "can't opendir $dirname: $!";

while (defined($file = readdir(DIR)))
{
    next if ( $file eq "." || $file eq ".." );

    ( $dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size,
      $atime, $mtime, $ctime, $blksize, $blocks ) = stat( "$dirname/$file ")
            or die "no $file: $!";
    $order++;
    $ac_size += $size;
    $ac_blk_tape += $blocks ;

    $l_order          = commify $order;
    $l_ac_blk_tape    = commify $ac_blk_tape  ;
    $l_ac_size        = commify $ac_size      ;
    $l_blksize        = commify $blksize      ;
    $l_blocks         = commify $blocks       ;
    $l_size           = commify $size         ;

    printf  (" %10s - %10s blk_tape : %7s bytes file:[ %4s blocks %9s bytes ] %s/%s \n"
                    , $l_order, $l_ac_blk_tape, $l_ac_size
                    , $l_blocks, $l_size
                    , $dirname, $file);

}

closedir(DIR);

