#!/c/usr/perl/5.8.8/bin/perl -w
# $Id: 01.hello.tk.pl 9930 2007-02-16 13:49:04Z marcus.ferreira $
#

use Tk;
use strict;
use warnings;

my $mw = MainWindow->new;

$mw->Label(
        -text => 'Hello, world!'
        )->pack;
$mw->Button(
        -text => 'Quit',
        -command => sub { exit },
        )->pack;

MainLoop;
