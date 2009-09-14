#!/usr/bin/perl
# $Id: svn.validate.name.pl 16688 2007-06-26 16:50:23Z marcus.ferreira $
#
# Marcus Vinicius Ferreira    ferreira.mv[ at ]gmai.com
#
# Apply rules to file names
#
# Usage:
#   svnlook changed -t "$TXN" "$REPOS" | svn.validate.name.pl
#   or
#   svnlook changed -t "$TXN" "$REPOS" > 1.txt
#   cat 1.txt | svn.validate.name.pl
#
# Install:
#   scp svn.validate.name.pl appsvn:~/repos/db01/
#

use strict;
use File::Basename;

my %Err;
my $file;

while( <> ) {

    next if /^#/;
    next if /^\s*$/;
    next unless /^A/;       # Validate added files only
#   print;
    next if m{/$};          # ignore dir

    chomp;
    m/^A\s+(.*)/; $_ = $1; # ignores 1st column

    invalido( 'acentos'     , $_ )  if ( /[ãõñáéíóúàèìòùâêîôûçÃÕÑÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÇ]/i );
    invalido( 'acentos'     , $_ )  if ( / \\ \? \d\d\d /xi ); # octal
    invalido( 'espacos'     , $_ )  if ( /\s/ );
    invalido( 'pontuacao'   , $_ )  if ( /[~(){}\[\] ]/x );
    invalido( 'redundancias', $_ )  if ( / _-_ | _d[aeo]s?_ | _n[ao]s?_ | _para_ |_com_ | _em_ /x );

    # filename size
    $file = fileparse($_);
    invalido( 'nome_longo'  , $_ )  if ( length($file) ) > 65;

    # mdb: src/module/file
    check_src_module( $_ )          if ( m{/trunk/src/}i );
}

my @errors = (sort keys %Err);

if( @errors ) {
    print STDERR "SVN Commit:\n";
    print STDERR "SVN Commit: Nomes de arquivo invalidos:\n";
    print STDERR "SVN Commit: ---------------------------\n";

    foreach my $type (@errors) {
        printf STDERR "SVN Commit: %s: %d\n", $type, $Err{$type}->{'count'};

        foreach my $file ( @{$Err{$type}->{'files'} } ) {
            print STDERR "SVN Commit:", " " x 8, $file, "\n";
        }
        print STDERR "SVN Commit:\n";
        print STDERR "SVN Commit:\n";

    }
    exit 1;
}

exit 0;

sub invalido {
    my $type = shift;
    my $file = shift;

    $Err{ $type }->{'count'}++;
    push @{ $Err{ $type }->{'files'} }, $file;

    return;
};

sub check_src_module {
    my $path = shift;
    my $file;
    my $app_dir;
    my $app_nm;

    ($app_dir) = $path =~ m{/trunk/src/(\w+)/}xi;
    ($app_nm)  = $path =~ m{/mdb[_]? (\w\w\w)}xi;
    # print "app_dir=",$app_dir," app_nm=",$app_nm,"\n";

    return if( ! $app_nm );    # Validate only files MDB_*
    return if( $app_dir =~ m{ pll | drv }xi );  # ignore src/pll e src/drv
    return if( $app_dir =~ m{ri}  && $app_nm =~ m{REC});  # ok: src/ri/MDB_REC
    return if( $app_dir =~ m{fnd} && $app_nm =~ m{ZZ} );  # ok: src/fnd/MDB_ZZ
    return if( $app_dir =~ m{ins} && $app_nm =~ m{ZZ} );  # ok: src/ins*/MDB_ZZ
    return if( $app_dir =~ m{ins} && $app_nm =~ m{INS});  # ok: src/ins*/MDB_INS
    return if( $app_dir =~ m{datafix}                 );  # ok: src/datafix/*

    # lowercase, without extension
    $file = fileparse($path);
    $file =~ s{ [.]\w+ $ }{}x;
    if( $file eq lc($file) ) {
        invalido( 'lower_case', $_);
        return;
    }

    # match dir /cm/ to file MDBCMX....rdf
    $app_nm = substr( $app_nm, 0, length($app_dir) );
    return if( $app_nm =~ m{$app_dir}i );

    # Error
    invalido("Arquivo do modulo [$app_nm] esta' no caminho incorreto: [trunk/src/$app_dir]", $path );
    return;
};

__END__
    print "check_src_mod: $path \n";
    print "               app_dir: $app_dir\n";
    print "               app_nm : $app_nm\n";
    print "               match  : error\n";

    return;

1.txt:
A   /trunk/src/install/pls/MDB_INST_EXP_DATA_PKS.pls
A   /trunk/src/install/pls/MDB_INST_EXP_DATA_PKB.pls
A   /trunk/src/install/pls/MDB_ZZ_EXPORT_DATA_KS.pls
A   /trunk/src/install/pls/MDB_ZZ_EXPORT_DATA_KB.pls
A   /trunk/src/install/pls/mdb_zz_export_data_ks.pls
A   /trunk/src/install/pls/mdb_zz_export_data_kb.pls
