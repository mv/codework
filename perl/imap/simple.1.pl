#!/usr/bin/perl
# $Id$
# Adapting from:
#   http://cpan.uwinnipeg.ca/htdocs/Net-IMAP-Simple/Net/IMAP/Simple.html
#

# Duh
use Net::IMAP::Simple;
use Email::Simple;

die <<THANATOS unless (@ARGV);

    Usage: $0 <mailbox>

    Lists SUBJECTS of email messages inside <mailbox>.

THANATOS

my $mailbox=$ARGV[0];

# Create the object
my $imap = Net::IMAP::Simple->new('pop.mdb.com.br') ||
   die "Unable to connect to IMAP: $Net::IMAP::Simple::errstr\n";

# Log on
if(!$imap->login('marcus.ferreira','terra2003')){
    print STDERR "Login failed: " . $imap->errstr . "\n";
    exit(64);
}

# Print the subject's of all the messages in the INBOX
my $nm = $imap->select($mailbox) or die "Mailbox $mailbox not found.";

for(my $i = 1; $i <= $nm; $i++){
    if($imap->seen($i)){
        print "*";
    } else {
        print " ";
    }

    my $es = Email::Simple->new(join '', @{ $imap->top($i) } );
    printf("[%03d] %s\n", $i, $es->header('Subject'));
}

$imap->quit;
