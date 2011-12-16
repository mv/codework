#!/usr/bin/perl
# $Id$
# http://cpan.uwinnipeg.ca/htdocs/Net-IMAP-Simple/Net/IMAP/Simple.html


# Duh
use Net::IMAP::Simple;
use Email::Simple;

# Create the object
my $imap = Net::IMAP::Simple->new('pop.mdb.com.br') ||
   die "Unable to connect to IMAP: $Net::IMAP::Simple::errstr\n";

# Log on
if(!$imap->login('marcus.ferreira','terra2003')){
    print STDERR "Login failed: " . $imap->errstr . "\n";
    exit(64);
}

# Print the subject's of all the messages in the INBOX
my $nm = $imap->select('INBOX');

print "Current Mail Box folder: " . $imap->current_box . "\n";

my @boxes   = $imap->mailboxes;
print "Box: $_ \n" foreach(@boxes);

# my @folders = $imap->mailboxes("Mail/%");
# my @lists   = $imap->mailboxes("lists/perl/*", "/Mail/");

$imap->quit;