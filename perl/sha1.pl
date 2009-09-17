#!/usr/bin/env perl
#
# Usage: $0 file
#
# Marcus Vinicus Ferreira                   ferreira.mv[ at ]gmail.com
#
# 2009/09
#

use Digest::SHA1  qw(sha1 sha1_hex sha1_base64);

my $data = do { local $/; <$in> };

# print "SHA1         ", sha1($data)       , "\n"; Binary
  print "SHA1 hex     ", sha1_hex($data)   , "\n";
  print "SHA1 base64  ", sha1_base64($data), "\n";

exit 0;
