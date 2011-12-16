#!/usr/bin/env perl
#
# sample.pl
#     sample
#
#     Usage: sample.pl
#
#
# Marcus Vinicius Ferreira                  ferreira.mv[ at ]gmail.com
# Set/2006
#

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Carp;
use POSIX qw(strftime);

use Log::Log4perl;

BEGIN { $Exporter::Verbose = 0 };

###
### Main
###

