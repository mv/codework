#!/usr/bin/perl
# $Id$
#

use IMAP::Client;

my $server = 'pop.mdb.com.br';
my $imap = new IMAP::Client();
$imap->connect( PeerAddr        => $server,
                ConnectMethod   => 'PLAIN',
              ) or die "Unable to connect to [$server]: ".$imap->error();

my $user = 'marcus.ferreira';
my $pass = 'terra2003';
$imap->login($user,$pass)
                or die "Unable to authenticate as $user ".$imap->error()."\n";


#########
my $ref;
my $mailbox = "Inbox";
$imap->list($ref, $mailbox);


exit 99;
#########
my $message = "Built via $0\n\n\n\n\n";
my $flaglist = '';
my $mailbox = '';
$imap->append($mailbox, $message, $flaglist);

