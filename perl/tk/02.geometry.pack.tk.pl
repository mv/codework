#!/c/usr/perl/5.8.8/bin/perl -w
# $Id: 01.canvas.tk.pl 9930 2007-02-16 13:49:04Z marcus.ferreira $
# file:///C:/pub/doc/oreilly_Bookshelves/perl3/tk/ch02_01.html

use Tk;
use strict;
use warnings;

my $mw = MainWindow->new;
$mw->title("Good Window");
$mw->Label(-text => "This window looks much more organized, and less haphazard\n" .
    "because we used some options to make it look nice")->pack;

$mw->Button(-text    => "Exit",
            -command => sub { exit })->pack(-side   => 'bottom',
                                            -expand => 1,
                                            -fill   => 'x'
                                            );
$mw->Checkbutton(-text => "I like it!"  )->pack(-side => 'left', -expand => 1);
$mw->Checkbutton(-text => "I hate it!"  )->pack(-side => 'left', -expand => 1);
$mw->Checkbutton(-text => "I don't care")->pack(-side => 'left', -expand => 1);

$mw->Button(-text => "Enlarge",
            -command => \&repack_kids)->pack(-side   => 'bottom',
                                             -anchor => 'center'
                                             );
sub repack_kids {
    my @kids = $mw->packSlaves;
    foreach (@kids) {
        my %packinfo = $_->packInfo();
        $_->pack(-ipadx => 20 + $packinfo{"-ipadx"}, -ipady => 20+$packinfo{"-ipady"}); }
}

MainLoop;
