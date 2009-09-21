#!/bin/bash
# $Id: cygmod.pl 60 2006-09-27 17:11:05Z marcus.ferreira $
#

find . | perl -ne 'chomp; chmod 0775, $_ if -d $_; chmod 0664, $_ if -f $_;'


