#!/usr/bin/perl
# $Id: mail.file.pl 60 2006-09-27 17:11:05Z marcus.ferreira $
#
#

use Mail::Sender;

my $sender = new Mail::Sender
        { smtp      => 'mdbpx2.mdb.com.br'
        , from      => 'marcus.ferreira@mdb.com.br'
        };

$sender->MailFile(
        { to        => 'marcus.ferreira@mdb.com.br'
        , cc        => 'ferreira.mv@gmail.com'
        , subject   => 'MDB TE 0.20'
        , msg       => "Attach via Perl"
        , file      => '/home/marcus/Desktop/MDB_MD040_padroes_de_construcao.doc'
        , charset   => 'iso-8859-1'
        , b_charset => 'iso-8859-1'
        }
);


if( $sender->{'error'} ) {
    print "Error: ", $sender->{'error_msg'},"\n\n";
    exit abs( $sender->{'error'} );
}
else {
    print "\n\nMail sent.\n\n";
};

exit 0;

