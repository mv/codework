#!/c/usr/perl/5.8.8/bin/perl -w
# $Id: 01.callback_scrollbar.tk.pl 9930 2007-02-16 13:49:04Z marcus.ferreira $
# file:///C:/usr/perl/5.8.8/html/lib/Tk/UserGuide.html

use Tk;
use strict;
use warnings;

my $mw = MainWindow->new;

# Create box
my $box = $mw->Listbox(
        -relief => 'sunken',
        -height  => 5,
        -setgrid => 1,
        );
my @items = qw(One Two Three Four Five Six
                Seven Eight Nine Ten Eleven Twelve);

foreach (@items) { $box->insert('end', $_); }

# Create scroll to the box
my $scroll = $mw->Scrollbar(
                -command => ['yview', $box]
                );

# Tie scroll to box
$box->configure(-yscrollcommand => ['set', $scroll]);

# Display both
$box->pack(
        -side => 'left',
        -fill => 'both',
        -expand => 1);
$scroll->pack(
        -side => 'right',
        -fill => 'y');

MainLoop;
