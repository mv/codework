#!/usr/bin/perl
# $Id$
#

use Mail::IMAPClient;

my ($host, $user, $pass) = qw ( pop.mdb.com.br marcus.ferreira terra2003 );

my $imap = Mail::IMAPClient->new(
                Server  => $host,
                User    => $user,
                Password=> $pass,
            ) or die "Cannot connect to $host as $user: $@";

$imap->Connected()      ? print "\nConnected.\n"   : print "\nNO CONNECTION.\n";
$imap->Authenticated()  ? print "Authenticated.\n" : print "NO AUTH.\n";

# print "Folder: $_\n" foreach( @{$imap->folders});

my $msg_text = "

Teste do Imap

" . scalar(localtime) . "\n";

print $msg_text,"-----\n";

my $folder = "Drafts";
   $imap->select($folder)  or die "Could not select: $@\n";
my $uid = $imap->append($folder,$msg_text)
        or die "Could not append: $@\n";

print "Created message: $uid\n";


