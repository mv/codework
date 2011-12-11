#!/usr/bin/perl
# $Id: consolid.pl 746 2006-03-07 15:13:19Z fjunqueira $
# $Rev: 746 $
# $HeadURL: http://fileserver/svn/netset/trunk/implementation/dba/policard/db/consolid/consolid.pl $
#
# Consolidacao: relatorios hiperlog
# Obs:
#     Rotina de controle generica.
#     Depende do arquivo de config com as strings SQL que realmente
#     consolidam.
#
# Created:
#     Marcus Vinicius Ferreira       Jun/2005
# Modified:
#
#

package Consolid;

# BEGIN { $Exporter::Verbose=1 }

$VERSION = '1.1';

use strict;
use warnings;

use FindBin         qw($RealScript $RealDir $Script $Dir);
use lib "$Dir";
use lib "$Dir/lib";

use Getopt::Std;
use Sys::Hostname;
use Time::Local         qw(timelocal);  # DMYHMS to Epoch Seconds

use DBI                 qw(:sql_types);
use DBD::Pg             qw(:pg_types);
use Log::Log4perl       qw(:easy);


##
## Declarations
##

# Variables for ''Consolid::Definitions''
my ( $Cons_File
   , $Cons_Sel
   , $Cons_Ins
   , $Cons_Upd
   , %Cons_Attr
   );

# Globals
my ( %Opt , $Log
   , $Dbh , $Sth_q, $Sth_i, $Sth_u
   );
my ($Kount, $Kount_i, $Kount_u, $Kount_e) = (0,0,0,0);

##
## Main
##

Log::Log4perl->init_and_watch( $Dir . "/consolid.l4pl.conf", 60);

$Log = get_logger();
$Log->info ("---------------------------------");
$Log->info ("===--- Beginning....");
$Log->debug("===---    myself: $0");
$Log->debug("===---  Realname: ", $RealScript  );
$Log->debug("===---   Realdir: ", $RealDir     );
$Log->debug("===---  basename: ", $Script      );
$Log->debug("===---   workdir: ", $Dir         );

consolid();

$Log->info("===--- Ending....");
$Log->info("---------------------------------");

exit 0;

#####################################################
#
#
#####################################################

sub consolid {

    init_signal();
    cli_param();

    init_sql();
    db_connect();

    my %var;
    my ($last_exec, $cfg_id)     = get_last_exec( $Cons_File );
    my ($b_date   , $e_date)     = db_param( $last_exec );

    my ($rows, $b_exec, $e_exec) = db_run($b_date, $e_date );

    %var = ( cfg_id => $cfg_id
           , rows   => $rows
           , b_date => $b_date
           , e_date => $e_date
           , b_exec => $b_exec
           , e_exec => $e_exec
           );
    put_last_exec( %var );

    db_final( 'Success' );
}

sub cli_param
{
    $Getopt::Std::STANDARD_HELP_VERSION = 1;
    getopts( "f:b:e:h:n", \%Opt); #print Dumper( \%opt ); exit 99;

    if ( defined $Opt{f}  )
    {
        $Cons_File = $Opt{f};
        $Log->info("=================================");
        $Log->info("==== SCRIPT");
        $Log->info("==== SCRIPT $Cons_File  ===");
        $Log->info("==== SCRIPT");
        $Log->info("=================================");
    }
    else {
        HELP_MESSAGE();
    }

    if( defined $Opt{b} && ! defined $Opt{e} ) {
        $Log->error("ERROR: -e MUST be present with -b option.");
        HELP_MESSAGE();
        die;
    }

}

sub db_param
{
    my ( $has_offset
       , %b       # tm format
       , %e
       , $b_date  # iso/string format
       , $e_date
       );
    ###
    ### $b_date: Default is replaced if there is a command line option
    ###
    if( exists $Opt{b} ) {
        $Log->info("db_param:        begin: ", $Opt{b}, " (-b date)");
        %b = iso2tm($Opt{b}); # forces 00:00:00, if not present
        $b_date = tm2iso(%b);

        # offset: does not apply to command line option
        $has_offset = 0;
    }
    else {
        $b_date = shift;
        if( defined $b_date ) {
            $Log->info("db_param:        begin: ", $b_date, " (last execution date)");
            $has_offset = 1;
        }
        else {
            $Log->error ("db_param: begin date NOT DEFINED.");
            $Log->error ("db_param:     use -b and -e option");
            $Log->error ("db_param: or create a record in 'ctr_cfg' table");
            $Log->logdie("db_param: cannot proceed without BEGIN DATE");
        }
    }

    ###
    ### $e_date: Default is now()
    ###
    if( exists $Opt{e} ) {
        $Log->info("db_param:          end: ", $Opt{e}, " (-e date) ");

        %e = iso2tm($Opt{e});
        $e{ms}   = '999999'; # $e{ms}  ||'999999' ;
        $e{sec}  = '59'    ; # $e{sec} ||'59'     ;
        $e{min}  = '59'    ; # $e{min} ||'59'     ;
        $e{hour} = '23'    ; # $e{hour}||'23'     ;
        $e_date = tm2iso(%e);
    }
    else {
        $e_date = now_iso();
        $Log->info("db_param:          end: ", $e_date, " (default)");
    }

    if( $has_offset ) {

        ###
        ### offset
        ###
        $b_date = off_set( $Cons_Attr{offset_b}, $b_date );
        $e_date = off_set( $Cons_Attr{offset_e}, $e_date );
        $Log->info("db_param: offset begin: ", $b_date, " (",$Cons_Attr{offset_b}, ")" );
        $Log->info("db_param: offset   end: ", $e_date, " (",$Cons_Attr{offset_e}, ")" );


        ###
        ### Trunc: adjusts for SQL BIND.
        ###     %sql_atrib  (defined by init_sql())
        ###         {trunc}:     must be 'hh', 'dd' , 'mm'
        $b_date = trunc_iso( $Cons_Attr{trunc}, $b_date );
        $e_date = trunc_iso( $Cons_Attr{trunc}, $e_date );

        $Log->info("db_param: trunc  begin: ", $b_date );
        $Log->info("db_param: trunc    end: ", $e_date );

    }
    else {
        ###
        ### Dates after default and/or offset
        ###
        $Log->debug("db_param:   begin iso: ", $b_date );
        $Log->debug("db_param:     end iso: ", $e_date );
    }

    $b_date = substr( $b_date, 0, length( $Cons_Attr{dt_mask} ) );
    $e_date = substr( $e_date, 0, length( $Cons_Attr{dt_mask} ) );

    $Log->info("db_param:  using begin: ", $b_date );
    $Log->info("db_param:  using   end: ", $e_date );

    return( $b_date, $e_date );
}

sub db_run
{
    my $b_date = shift;
    my $e_date = shift;
    my $sql_ref;

    ###
    ### Begin the work
    ###
    my $b_exec = now_iso();

    # Prepare: ins, upd AND query
    $Sth_i = $Dbh->prepare($Cons_Ins)   or $Log->logdie("db_run: ins: $Dbh->errstr");
    $Log->debug("db_run:   ins:  parse: ok");

    $Sth_u = $Dbh->prepare($Cons_Upd)   or $Log->logdie("db_run: upd: $Dbh->errstr");
    $Log->debug("db_run:   upd:  parse: ok");

    $Sth_q = $Dbh->prepare($Cons_Sel) or $Log->logdie("db_run: sel: $Dbh->errstr");
    $Log->debug("db_run: query:  parse: ok");

    my %attr = ( type => $Cons_Attr{bind_type} ) ;
    $Sth_q->bind_param( 1, $b_date, \%attr );
    $Log->debug("db_run: query: bind 1: ok");

    $Sth_q->bind_param( 2, $e_date, \%attr );
    $Log->debug("db_run: query: bind 2: ok");

    if( $Opt{n} ) { # 'no-execute'' option
        $Log->debug("db_run: goto FINAL");
        goto FINAL;
    }

    # Execute query
    $Sth_q->execute or $Log->logdie("db_run: query->execute: ", $DBI::errstr);
    $Log->debug("db_run: query: execute: ok");

    my $rows = $Sth_q->rows;
    $Log->info("db_run:   rows: ", $rows);

RECORD:
    while ( $sql_ref = $Sth_q->fetchrow_arrayref )
    {
        # Insert XOR Update
        #
        eval { db_insert( $sql_ref ); };
        if( $@ ) {
            eval { $Kount_u += db_update( $sql_ref ) };
            if( $@ ) { $Kount_e++  } # Error with INSERT and/or UPDATE
            else     {#$Kount_u++
                                   } # UPDATE ok
        }
        else  {$Kount_i++ }          # INSERT ok

        # Progress
        if ( ++$Kount % 1_000 == 0)
        {
            my $fmt=" Run: Rec = %d/%d (%d%%) [Ins = %d] [Upd = %d] [Err = %d]";
            $Log->info( sprintf( $fmt
                               , $Kount, $rows, ($Kount/$rows*100)
                               , $Kount_i, $Kount_u, $Kount_e
                               )
                      );
        }
    }

FINAL:
    ###
    ### Final
    ###
    my $e_exec = now_iso();

    return( $rows, $b_exec, $e_exec );

}

sub db_conf {

    my $this_node ;
    my %conf = ();
    my %node = ();

    {
        eval { require "consolid.db.pl" };
        $Log->logdie("db_conf: consolid.db.pl NOT FOUND!") if( $@ ) ;
        %conf = Consolid::DBConf::get_db_conf();
    }


    # Which host configuration?
    if( exists $Opt{h} ) {
        $this_node = $Opt{h};
        $Log->debug("db_conf: requested node: ", $this_node );

        unless( exists $conf{$this_node}->{host} ) {
            $Log->logdie("ERROR: Node ", $this_node, " has no definition!!!")
        };
    }
    else {
        $this_node = hostname();
    }

    # Getting the details
    for my $item qw(host port dbn usr psw) {
        $node{$item} = $conf{$this_node}->{$item} || $conf{DEFAULT}->{$item};
    }
    $Log->info(" -- db_conf:  this host = ", $this_node  );
    $Log->info(" -- db_conf:    db host = ", $node{host} );
    $Log->info(" -- db_conf:       port = ", $node{port} );
    $Log->info(" -- db_conf:     dbname = ", $node{dbn}  );

    return %node;
}

sub db_connect
{
    # Connect
    my %cfg = db_conf();

    $Dbh = DBI->connect( "dbi:Pg:dbname=$cfg{dbn};host=$cfg{host};port=$cfg{port}"
                       , "$cfg{usr}"
                       , "$cfg{psw}"
                       , { PrintError => 0,
                           RaiseError => 1,
                           AutoCommit => 1,
                           pg_server_prepare => 1,
                           pg_error_level    => 0,
                         }
                       )
                     or $Log->logdie("Cannot connect: $DBI::errstr");

    $Log->info("Server Process ", "=" x 15);
    $Log->info("Server Process PID $Dbh->{pg_pid}");
    $Log->info("Server Process ", "=" x 15);

}

sub db_insert
{
    my $ref = shift;

    BIND:
    for ( my $i=0; $i < @{ $ref }; $i++ )
    {
        $Sth_i->bind_param( $i+1, ${ $ref }[$i] )
                or $Log->logdie("db_insert: $DBI::errstr");
    }

    my $rv  = $Sth_i->execute || "Undef_";
    my $err = $Sth_i->err ;
    if ($err)
    {
        # DUP_VAL_ON_INDEX (SQLstate 23505) is expected. Others are logged.
        if ($Dbh->state == 23505)
        {
            warn( "dup val" ); # expected, really.
        }
        else
        {
            $Log->warn("db_insert: Pg ErrorCode:", $Dbh->state);
            $Log->warn("db_insert: ", $Dbh->errstr);
            warn("db_insert: ", $Dbh->errstr);
        }
    }

}

sub db_update
{
    my $ref = shift;

    BIND:
    for ( my $i=0; $i < @{ $ref }; $i++ )
    {
        $Sth_u->bind_param( $i+1, ${ $ref }[$i] )
                or $Log->logdie("db_insert: $DBI::errstr");
    }

    $Sth_u->execute;
    if( $Sth_u->err )
    {
        $Log->warn("db_update: Pg ErrorCode:", $Dbh->state);
        $Log->warn("db_update: ", $Dbh->errstr);
        warn("db_update: ", $Dbh->errstr);
    }
    return $Sth_u->rows;
}

sub db_final
{
    my $code = shift || 0;

    $Log->info(        "===--- db_final:" );
    $Log->info(        "===--- db_final:  Records  Inserted   Updated    Errors " );
    $Log->info(sprintf("===--- db_final:%9d %9d %9d %9d  ", $Kount, $Kount_i, $Kount_u, $Kount_e) );
    $Log->info(        "===--- db_final:" );
    $Log->info(        "===--- db_final:  ",$code);

   #$Dbh->commit or warn "$DBI::errstr";
    $Dbh->disconnect
            or $Log->warn("Disconnect: $DBI::errstr");

}

sub init_sql
{
    ###
    ### inside $Cons_File is defined 'init_string()'
    ### SQL's come from here:
    ###   @_: 0 - $query
    ###       1 - $ins
    ###       2 - $upd
    ###       3 - %sql_atrib....
    ###
    {
        eval { require $Cons_File };
        $Log->logdie("init_sql: Script file invalid! [$Cons_File]") if( $@ ) ;

        my @var = Consolid::Definitions::init_string();

        ($Cons_Sel, $Cons_Ins, $Cons_Upd, %Cons_Attr) = @var; # Perl magic!

        $Log->logdie('init_sql: query  is UNDEFINED!') unless defined $Cons_Sel;
        $Log->logdie('init_sql: insert is UNDEFINED!') unless defined $Cons_Ins;
        $Log->logdie('init_sql: update is UNDEFINED!') unless defined $Cons_Upd;

        $Cons_Sel =~ s/QUERY /QUERY $Script [$Cons_File]\n    / ;
        $Cons_Ins =~ s/INS /INS $Script [$Cons_File]\n    / ;
        $Cons_Upd =~ s/UPD /UPD $Script [$Cons_File]\n    / ;
      # $Log->debug("\n", "_" x 40, "\n", $query, "_" x 40);
    }

    ###
    ### Check: global %Cons_Attr
    ###
    my @must_have = qw(trunc offset_b offset_e bind_type dt_mask);
    my $quit=0;

    # Show:
    for my $atr (sort keys %Cons_Attr) {
        $Log->debug( sprintf("------- atr: %10s: %s", $atr, $Cons_Attr{$atr} ));
    }
    # Verify:
    for my $must (@must_have) {
        if( ! defined( $Cons_Attr{$must})) {
            $Log->warn("------- atr: \$Cons_Attr{$must} NOT DEFINED in $Cons_File");
            $quit = 1;
        }
    }
    $Log->logdie("------ atr: QUIT") if $quit;

}

sub get_last_exec
{
    my $file_name = shift;
    my $l_exec;
    my $id;

    ###
    ### last execution date, as recorded in the database
    ###
    my $sql = q{
       SELECT last_exec
            , prc_id as cfg_id
         FROM ctr_last_exec
        WHERE file_name = $1
    };
    my $sth  = $Dbh->prepare( $sql );

    $sth->bind_param( 1, $file_name , SQL_VARCHAR   );
    $sth->execute() or $Log->logdie("get_last_exec: Error ", $DBI::errstr);

    ( $l_exec, $id ) = ( $sth->fetchrow_array );
    $sth->finish;

    if ( defined $l_exec ) {
        $Log->debug( 'get_last_exec: last_exec: ', $l_exec );
        $Log->debug( 'get_last_exec:    cfg_id: ', $id );
        return( $l_exec, $id);
    }
    else {
        $Log->info( 'get_last_exec: data NOT FOUND for ', $file_name );
        return;
    }

}

sub put_last_exec
{
    my %var = @_;
    my $last;

    return unless( defined($var{cfg_id}) ); # no id to save, so returns;

    my $sql = q{
      INSERT INTO ctr_proc_exec
                ( ctr_proc_id   -- 1
                , b_date        -- 2
                , e_date        -- 3
                , b_exec        -- 4
                , e_exec        -- 5
                , last_exec     -- 6
                , qtd_rows      -- 7
                , qtd_ins       -- 8
                , qtd_upd       -- 9
                )
         VALUES ( $1, $2,$3,$4,$5,  $6,  $7,$8,$9 )
        };
    my $sth = $Dbh->prepare( $sql );
    $sth->bind_param( 1, $var{cfg_id} , SQL_INTEGER   );
    $sth->bind_param( 2, $var{b_date} , SQL_VARCHAR   );
    $sth->bind_param( 3, $var{e_date} , SQL_VARCHAR   );
    $sth->bind_param( 4, $var{b_exec} , SQL_TIMESTAMP );
    $sth->bind_param( 5, $var{e_exec} , SQL_TIMESTAMP );

    # execution "by-hand" will not have a last_exec date
    if( defined $Opt{b} && defined $Opt{e} ) { $last = undef;       }
    else                                     { $last = now_iso();   }
    $sth->bind_param( 6, $last   , SQL_TIMESTAMP );

    $sth->bind_param( 7, $Kount  , SQL_INTEGER   );
    $sth->bind_param( 8, $Kount_i, SQL_INTEGER   );
    $sth->bind_param( 9, $Kount_u, SQL_INTEGER   );

    $sth->execute() or $Log->logdie("put_last_exec: Error ", $DBI::errstr);

    $Log->debug('put_last_exec:      rows = ', $Kount  );
    $Log->debug('put_last_exec:    b_exec = ', $var{b_exec} );
    $Log->debug('put_last_exec:    e_exec = ', $var{e_exec} );
    $Log->info (' put_last_exec: last_exec = ', $last ||'');

    $sth->finish;
}

sub HELP_MESSAGE
{
    print <<"    HELP";


    Usage: $0 -f <script> [-b begindate -e enddate] [-h hostconfig]

    for more information try:
    \$ perldoc $0


    HELP
    exit 0;
}

sub init_signal
{
    $SIG{INT} = 'IGNORE';

    foreach my $signal qw(QUIT ABRT KILL TERM)
    {
        $Log->debug("init_signal: Registering: ", $signal);
        $SIG{$signal} = sub {
            $Log->warn("Signal $signal: finishing.");
            db_final( $signal );
        };
    }

}

sub off_set
{
    my $interval = shift;
    my $iso      = shift;
    my %seconds  = (
            'sec'     => 1,
            'min'    => 60,
            'h'    => 3600, # hour
            'd'   => 86400, # day
            'w'  => 604800, # week
            'm' => 2592000, # month
                  );

    # offset: in seconds
    my ($sig, $val, $unit) = ( $interval =~ /([+-]?)(\d+)([hmd])/i );

    if( ! defined($val) || ! defined($unit) ) {
        $Log->logdie("off_set: Cannot parse interval: ", $interval)
    }
    if( $sig  ) { $sig .=  '1'; }
    else        { $sig  = '-1'; } # default

    my $offset = $val * $seconds{$unit} * $sig;

    $Log->debug(' offset: interval: [', $interval  ,']');
    $Log->debug(' offset:      $sig....: [', $sig  ,']');
    $Log->debug(' offset:      $val....: [', $val  ,']');
    $Log->debug(' offset:      $unit...: [', $unit ,']');
    $Log->debug(' offset:      $offset.: [', $offset ,']');

    ########
    # ep is 'epoch'
    #
    # iso -> tm -> epoch
    my %dt = iso2tm($iso);
    my $ep = timelocal( $dt{sec},  $dt{min},   $dt{hour}
                      , $dt{mday}, $dt{mon}-1, $dt{year}-1900
                      );
    # interval
    my $new_ep  = $ep + $offset;

    # epoch -> tm -> iso
    ($dt{sec},  $dt{min}, $dt{hour},
     $dt{mday}, $dt{mon}, $dt{year}) = (CORE::localtime( $new_ep ))[0..5];
    $dt{year}+=1900; $dt{mon}++;
    my $new_iso = tm2iso( %dt ); #print "dt_month $dt{mday} \n";
    #
    ########

    return $new_iso;


#$time = timegm($seconds, $minutes, $hours, $day, $month-1, $year-1900);

}

sub iso2tm
{
    my $iso = shift; #print"\n\n  == iso = $iso \n\n";
    my ($year,$mon,$mday) = ( $iso =~ /(\d+)-(\d+)-*(\d+)*/ );
    my ($hour,$min,$sec ) = ( $iso =~ / (\d+)*:*(\d+)*:*(\d+)*/ );
    my ($ms)              = ( $iso =~ /\d+\.(\d+)*/ );
    my %timetm = ( ms   => $ms  ||'0',
                   sec  => $sec ||'00',
                   min  => $min ||'00',
                   hour => $hour||'00',
                   mday => $mday||'01',
                   mon  => $mon ,
                   year => $year,
                 ); #print "$_ : $timetm{$_} \n" for keys %timetm;
    if(  ! defined $year
      || ! defined $mon
      || ! defined $mday )
    {
        $Log->logdie("ERROR: invalid date: [", $iso, "]")
    }
    return %timetm;
}

sub tm2iso
{
    my %dt = @_;
    my $iso = sprintf("%d-%02d-%02d %02d:%02d:%02d",$dt{year},$dt{mon},$dt{mday}||'01'
                                                   ,$dt{hour}||'00'
                                                   ,$dt{min} ||'00'
                                                   ,$dt{sec} ||'00'
                                                   )
                        or $Log->logdie("ERROR: invalid date. ");
    $iso .= "." . $dt{ms} if $dt{ms};
    return $iso;

}

sub now_iso
{
    my ($sec,$min,$hour,$mday,$mon,$year) = (CORE::localtime())[0..5];
    $year+=1900; $mon++;
    my $iso = sprintf("%d-%02d-%02d %02d:%02d:%02d",$year,$mon,$mday
                                                   ,$hour,$min,$sec  );
    return $iso;
}

sub now_tm
{
    #   0,   1,    2,    3,  4,     5,     6,    7,         8
    # sec, min, hour, mday, mon, year, wday, yday, and isdst.
    my ($sec,$min,$hour,$mday,$mon,$year) = (CORE::localtime())[0..5];
    $year+=1900; $mon++;

    my %timetm = ( sec  => $sec,
                   min  => $min,
                   hour => $hour,
                   mday => $mday,
                   mon  => $mon,
                   year => $year,
                 );
    return %timetm;
}

sub trunc_iso
{
    my $tp  = shift;
    my $iso = shift;
    my $res = '';

    my %dt = iso2tm( $iso );
    if    ( $tp eq 'hh' ) {
        $res = sprintf("%d-%02d-%02d %02d:00:00",$dt{year},$dt{mon},$dt{mday},$dt{hour});
    }
    elsif ( $tp eq 'dd' ) {
        $res = sprintf("%d-%02d-%02d 00:00:00"  ,$dt{year},$dt{mon},$dt{mday});
    }
    elsif ( $tp eq 'mm' ) {
        $res = sprintf("%d-%02d-01 00:00:00"    ,$dt{year},$dt{mon} );
    }
    return $res;
}

sub trunc_tm
{
    my $tp  = shift;
    my $ref = shift;

    if    ( $tp eq 'hh' ) {
        $ref->ms   = '';
        $ref->sec  = '00';
        $ref->min  = '00';
    }
    elsif ( $tp eq 'dd' ) {
        $ref->ms   = '';
        $ref->sec  = '00';
        $ref->min  = '00';
        $ref->hour = '00';
    }
    elsif ( $tp eq 'mm' ) {
        $ref->ms   = '';
        $ref->sec  = '00';
        $ref->min  = '00';
        $ref->hour = '00';
        $ref->day  = '01';
    }
}

__END__

=head1 NAME

consolid.pl - estrutura generica de consolidacao de tabelas
              em agrupamentos por dia, mes e ano.

=head1 USAGE

consolid.pl -f <config_file> [-b <begin_date> -e <end_date>]
           [-h <host_config>]

onde:

    <config_file>   arquivo de definicao dos SQL's.

    <begin_date>    data inicial
                    formato 'YYYY-MM-DD' ou 'YYYY-MM-DD HH24:MI:SS'
                    Se nao informado usa a ultima data de execucao
                    gravada na tabela de CONTROLE do banco de dados.

    <end_date>      data final
                    formato 'YYYY-MM-DD' ou 'YYYY-MM-DD HH24:MI:SS.SSSSSS'
                    Se nao informado considera 'now()' como data final.

    <host_config>   usa configuracao host/database definida no arquivo
                    consolid.db.pl

=head1 DEPENDS

    consolid.l4pl.conf

        Arquivo com as configuracoes para o modulo Log4Perl


    consolid.db.conf

        Arquivo com as configuracoes de acesso 'as bases de dados

=head1 EXAMPLES

    $ ./consolid.pl -f transact_hh.pl

    Consolida os detalhes definidos em "transact_hh.pl" desde o momento
    corrente até "now()". Exemplo:

    hora de execucao        hh                      dd          mm
    2005-06-01 10:20:15     2005-06-01 10:00:00    2005-06-01   2005-06
    2005-06-10 13:45:50     2005-06-10 13:00:00    2005-06-10   2005-06


    $ ./consolid.pl -f transact_dd.pl -b '2005-06-01'

    Consolida os detalhes definidos em "transact_hh.pl" a partir de
    01/jun/2006 até "now()".


    $ ./consolid.pl -f transact_dd.pl \
                    -b '2005-06-01' -e '2005-06-10 23:59:59.999999'

    Consolida os detalhes definidos em "transact_hh.pl" a partir de 01/jun/2006
    a a 10/jun/2006.

=head1 AUTHOR

Marcus Vinicius Ferreira    Jul/2005

=cut
