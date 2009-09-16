#!/c/usr/perl/5.8.8/bin/perl -w
# $Id: 01.more_than_1_windows.tk.pl 9930 2007-02-16 13:49:04Z marcus.ferreira $
# file:///C:/usr/perl/5.8.8/html/lib/Tk/UserGuide.html

use Tk;
use strict;
use warnings;

my $mw = MainWindow->new;
fill_window($mw, 'Main');
my $top1 = $mw->Toplevel;
fill_window($top1, 'First top-level');
my $top2 = $mw->Toplevel;
fill_window($top2, 'Second top-level');
MainLoop;

sub fill_window {
    my ($window, $header) = @_;
    $window->Label(-text => $header)->pack;
    $window->Button(
        -text    => 'close',
        -command => [$window => 'destroy']
    )->pack(-side => 'left');
    $window->Button(
        -text    => 'exit',
        -command => [$mw => 'destroy']
    )->pack(-side => 'right');
}
