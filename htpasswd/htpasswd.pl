#!/usr/bin/perl -w
use strict;
#
# Typical useage:
#       ./htpasswd-sha1.pl  $USERNAME  $PASSWORD
#

use MIME::Base64;  # http://www.cpan.org/modules/by-module/MIME/
use Digest::SHA1;  # http://www.cpan.org/modules/by-module/MD5/

if ($#ARGV!=1) { die "Usage $0: user password\n" }

print $ARGV[0], ':{SHA}', encode_base64( Digest::SHA1::sha1($ARGV[1]) );

