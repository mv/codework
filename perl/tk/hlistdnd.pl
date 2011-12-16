#!/usr/local/bin/perl -w

use Tk;
use Tk::DragDrop;
use Tk::DropSite;
use Tk::HList;
use strict;
use vars qw($top $f $lb_src $lb_dest $dnd_token $drag_entry);

$top = new MainWindow;

$top->Label(-text => "Drag items from the left HList to the right one"
	   )->pack;
$f = $top->Frame->pack;
$lb_src  = $f->Scrolled('HList', -scrollbars => "osoe", -selectmode => 'dragdrop')
  ->pack(-side => "left");
$lb_dest = $f->Scrolled('HList', -scrollbars => "osoe", -selectmode => 'dragdrop')
  ->pack(-side => "left");

my $i=0;
foreach (sort keys %ENV) {
    $lb_src->add($i++, -text => $_);
}

# Define the source for drags.
# Drags are started while pressing the left mouse button and moving the
# mouse. Then the StartDrag callback is executed.
$dnd_token = $lb_src->DragDrop
  (-event     => '<B1-Motion>',
   -sitetypes => ['Local'],
   -startcommand => sub { StartDrag($dnd_token) },
  );
# Define the target for drops.
$lb_dest->DropSite
  (-droptypes     => ['Local'],
   -dropcommand   => [ \&Drop, $lb_dest, $dnd_token ],
  );

MainLoop;

sub StartDrag {
    my($token) = @_;
    my $w = $token->parent; # $w is the source hlist
    my $e = $w->XEvent;
    $drag_entry = $w->nearest($e->y); # get the hlist entry under cursor
    if (defined $drag_entry) {
	# Configure the dnd token to show the hlist entry
	$token->configure(-text => $w->entrycget($drag_entry, '-text'));
	# Show the token
	my($X, $Y) = ($e->X, $e->Y);
	$token->MoveToplevelWindow($X, $Y);
	$token->raise;
	$token->deiconify;
	$token->FindSite($X, $Y, $e);
    }
}

# Accept a drop and insert a new item in the destination hlist and delete
# the item from the source hlist
sub Drop {
    my($lb, $dnd_source) = @_;
    my $end = ($lb->info("children"))[-1];
    my @pos = (-after => $end) if defined $end;
    my $y = $lb->pointery - $lb->rooty;
    my $nearest = $lb->nearest($y);
    if (defined $nearest) {
	my(@bbox) = $lb->infoBbox($nearest);
	if ($y > ($bbox[3]-$bbox[1])/2+$bbox[1]) {
	    @pos = (-after => $nearest);
	} else {
	    @pos = (-before => $nearest);
	}
    }
    $lb->add($drag_entry, @pos, -text => $dnd_source->cget(-text));
    $lb_src->delete("entry", $drag_entry);
    $lb->see($drag_entry);
}

__END__


