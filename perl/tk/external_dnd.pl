#!/usr/local/bin/perl -w

use Tk;
use Tk::DropSite;
use strict;
use vars qw($top $drop);

$top = new MainWindow;
$top->Label(-text => "The drop area:")->pack;
$drop = $top->Scrolled('Listbox',
		       -scrollbars => "osoe",
		      )->pack;
# Tell Tk that $drop should accept drops.
# The allowed drag and drop types on Unix systems are "KDE", "XDND" and "SUN"
# and on Windows systems the "Win32" dnd type.
# When dropping occurs, execute the accept_drop callback.
$drop->DropSite
  (-dropcommand => [\&accept_drop, $drop],
   -droptypes => ($^O eq 'MSWin32' ? 'Win32' : ['KDE', 'XDND', 'Sun'])
  );
MainLoop;

sub accept_drop {
    my($widget, $selection) = @_;

    my $filename;
    eval {
	if ($^O eq 'MSWin32') {
	    $filename = $widget->SelectionGet(-selection => $selection,
					      'STRING');
	} else {
	    $filename = $widget->SelectionGet(-selection => $selection,
					      'FILE_NAME');
	}
    };
    if (defined $filename) {
	$widget->insert(0, $filename);
    }
}

__END__

