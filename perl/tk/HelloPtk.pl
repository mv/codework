#!/usr/bin/perl

use strict;
use warnings;

use Tk;

my $mw = MainWindow->new(-title=>$0);

$mw->Label( -text=> "Hello Perl/Tk",
            -anchor=>'center'
           )->pack( -side=>'top');

$mw->Button( -text=> 'Exit',
             -command=>\&doExit
            )->pack( -side=>'bottom');

sub doExit { exit 0; }
