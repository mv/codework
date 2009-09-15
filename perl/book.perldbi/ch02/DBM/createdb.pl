#!/usr/bin/perl -w
#
# ch02/DBM/createdb: Creates a Berkeley DB

use strict;

use DB_File;

my  %database;
tie %database, 'DB_File', "createdb.dat"
    or die "Can't initialize database: $!\n";

untie %database;

exit;
