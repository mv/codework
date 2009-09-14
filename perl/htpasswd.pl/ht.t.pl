#!/usr/bin/perl
# $Id: ht.t.pl 2175 2006-10-25 17:28:28Z marcus.ferreira $
#

use Apache::Htpasswd;
$file = new Apache::Htpasswd(
                        { passwdFile => "svn_htpasswd"
                        , ReadOnly   => 1
                        }
                            );

$user = $ARGV[0];

# Fetch an encrypted password
$passwd = $file->fetchPass( $user )
    or die "Err: $file->error - $!";

print "User $user Passwd $passwd\n";

#   # Write in the extra info field
#   $file->writeInfo("login", "info");
#
#   # Get extra info field for a user
#   $file->fetchInfo("login");
