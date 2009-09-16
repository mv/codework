#!/c/usr/perl/5.8.8/bin/perl -w
# $Id: 01.entry.tk.pl 9930 2007-02-16 13:49:04Z marcus.ferreira $
#

use Tk;
use strict;
use warnings;

my $mw = MainWindow->new;

$mw->Label(-text => 'File Name')->pack;
my $filename = $mw->Entry(-width => 20);
$filename->pack;

$mw->Label(-text => 'Font Name')->pack;
my $font = $mw->Entry(-width => 10);
$font->pack;

$mw->Button(
    -text => 'Fax',
    -command => sub{do_fax($filename, $font)}
)->pack;

$mw->Button(
    -text => 'Print',
    -command => sub{do_print($filename, $font)}
)->pack;

MainLoop;

sub do_fax {
    my ($file, $font) = @_;
    my $file_val = $file->get;
    my $font_val = $font->get;
    print "Now faxing $file_val in font $font_val\n";
}

sub do_print {
    my ($file, $font) = @_;
    my $file_val = $file->get;
    my $font_val = $font->get;
    print "Sending file $file_val to printer in font $font_val\n";
}
