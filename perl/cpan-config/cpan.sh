#!/bin/bash
#
# My CPAN modules
#
# Marcus Vinicius Ferreira           ferreira.mv[ at ]gmail.com
# 2009/09

# Post-install
cpan -i LWP

cpan -i Term::ReadKey
cpan -i Term::ReadLine::Perl
cpan -i IPC::Run3
cpan -i Probe::Perl

cpan -i Test::Simple
cpan -i Test::More
cpan -i Test::Harness
cpan -i Test::Pod
cpan -i Test::Pod::Coverage
cpan -i Test::Script
cpan -i Test::Env

# Add-ons
cpan -i Data::Dumper
cpan -i YAML
cpan -i YAML::Syck

cpan -i Mail::SendEasy
cpan -i Mail::Sender

cpan -i Path::Class
cpan -i File::Next
cpan -i File::SearchPath
cpan -i File::Which

cpan -i File::Find::Wanted
cpan -i File::Find::Closures
cpan -i File::Find::Rule
cpan -i File::Find::Rule::VCS

# Fun
# cpan -i Tk
# cpan -i WWW::Mechanize

# DBA
cpan -i DBI
cpan -i DBD::mysql
cpan -i DBD::SQLite
cpan -i DBD::Oracle

# Dev
cpan -i Perl::Tidy

cpan -i Scalar::Util
cpan -i List::Util
cpan -i List::MoreUtils
cpan -i Hash::Util

cpan -i Error
cpan -i Log::Log4perl
cpan -i Log::Log4perl::CommandLine

cpan -i Params::Validate

cpan -i DateTime # drolski
cpan -i DateTime::Functions
cpan -i TimeDate # gbarr http://github.com/gbarr/perl-TimeDate

cpan -i Archive::Zip
cpan -i Archive::Builder
#   Class::Autouse [requires]
#   Archive::Zip [requires]
#   IO::String [requires]
#   Test::ClassAPI [requires]
#   File::Flat [requires]
#   Params::Util [requires]
#   Class::Inspector [requires]

# sysutils
cpan -i IPC::Run
cpan -i Proc::Simple
cpan -i Sysadm::Install
cpan -i App::Ack

# perl utils
cpan -i Devel::Loaded # pmtools

# Tidy
# sql, xml

# Modules
# Text::Autoformat
# Parse::RecDescent
#
