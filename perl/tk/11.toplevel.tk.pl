#!/c/usr/perl/5.8.8/bin/perl -w
# $Id: 11.toplevel.tk.pl 9930 2007-02-16 13:49:04Z marcus.ferreira $
# file:///C:/pub/doc/oreilly_Bookshelves/perl3/tk/ch11_02.html

use Tk;
$mw = MainWindow->new;
$mw->title("MainWindow");
$mw->Button(-text => "Toplevel", -command => \&do_Toplevel)->pack( );

MainLoop;
sub do_Toplevel {
  if (! Exists($tl)) {
    $tl = $mw->Toplevel( );
    $tl->title("Toplevel");
    $tl->Button(-text => "Close",
                -command => sub { $tl->withdraw })->pack;
  } else {
    $tl->deiconify( );
    $tl->raise( );
  }
}
