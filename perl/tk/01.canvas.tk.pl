#!/c/usr/perl/5.8.8/bin/perl -w
# $Id: 01.canvas.tk.pl 9930 2007-02-16 13:49:04Z marcus.ferreira $
# file:///C:/usr/perl/5.8.8/html/lib/Tk/UserGuide.html

use Tk;
use strict;
use warnings;

# Create B<MainWindow> and canvas
my $mw = MainWindow->new;
my $canvas = $mw->Canvas;
$canvas->pack(-expand => 1, -fill => 'both');

# Create various items
create_item($canvas, 1, 1, 'circle', 'blue', 'Jane');
create_item($canvas, 4, 4, 'circle', 'red' , 'Peter');
create_item($canvas, 4, 1, 'square', 'blue', 'James');
create_item($canvas, 1, 4, 'square', 'red' , 'Patricia');

# Single-clicking with left on a 'circle' item invokes a procedure
$canvas->bind('circle', '<1>'       => sub {handle_circle($canvas)});

# Double-clicking with left on a 'blue' item invokes a procedure
$canvas->bind('blue', '<Double-1>'  => sub {handle_blue($canvas)});

MainLoop;

# Create an item; use parameters as tags (this is not a default!)
sub create_item {
    my ($can, $x, $y, $form, $color, $name) = @_; # $can=canvas

    my $x2 = $x + 1;
    my $y2 = $y + 1;
    my $kind;
    $kind = 'oval'      if ($form eq 'circle');
    $kind = 'rectangle' if ($form eq 'square');
    $can->create(
            ( $kind
            , "$x" . 'c' , "$y" . 'c'
            , "$x2" . 'c', "$y2" . 'c'
            )
            , -tags => [$form, $color, $name]
            , -fill => $color
        );
}

# This gets the real name (not current, blue/red, square/circle)
# Note: you'll want to return a list in realistic situations...
sub get_name {
    my ($can) = @_;
    my $item    = $can->find('withtag', 'current');
    my @taglist = $can->gettags($item);
    my $name;
    foreach (@taglist) {
        next if ($_ eq 'current');
        next if ($_ eq 'red'    or $_ eq 'blue');
        next if ($_ eq 'square' or $_ eq 'circle');
        $name = $_;
        last;
    }
    return $name;
}

sub handle_circle {
    my ($can) = @_;
    my $name = get_name($can);
    print "Action on circle $name...\n";
}

sub handle_blue {
    my ($can) = @_;
    my $name = get_name($can);
    print "Action on blue item $name...\n";
}
