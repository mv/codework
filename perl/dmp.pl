#!/usr/bin/perl
#
# $Id: dump_table.pl 64 2004-11-02 20:36:46Z marcus $
# $Revision: 1.5 $  $Author: marcus $
#
# dump_results()

use strict;
use DBI;

usage() unless @ARGV;

# Params
my $sid =    $ARGV[0] ;
my $tab = lc($ARGV[1]) ;
my $usr =    $ARGV[2] || "UXML";
my $psw =    $ARGV[3] || $usr  ;

# Variables
my $dbh;
my @columns;
my (@col_id, @col_pk, @col_nvl);

conn_db( $usr, $psw, $sid );

# The work to be done.....
@columns = get_columns( $usr, $tab );
upd_tab_plsql( $usr, $tab);
make_trigger ( $usr, $tab);

# end
$dbh->disconnect;
exit 0;

sub usage()
{
    die <<"    USAGE";

    Usage: $0 SID tab_name user [<password>]

        SID:        Database/tns_alias
        tab_name:   table name
        user:       username
        <password>: password

        Generates
            tab_name.ctl        loads table
            tab_name.pl         spools table
            tab_name_ins.sql    INSERT/SELECT on table
            tab_name_ins_pl.sql INSERT/SELECT using PL/SQL block.


    USAGE
}

sub conn_db()
{
    print "\n\n    $usr\@$sid Connecting.... ";

    # error Checking
    my %attr = ( PrintError => 1
               , RaiseError => 1
               );
    # Connect
    $dbh = DBI->connect("dbi:Oracle:$sid","$usr"
                                         ,"$psw"
                                         , \%attr
                                        )
                or die "\nCannot connect : ", $DBI::errstr, "\n" ;

    print "ok\n\n";
}

sub get_columns()
{
    # Table columns in a list

    my $owner = shift;
    my $tab   = shift;
    my $sth;
    my @cols;
    my ($colname, $colid, $colpk, $colnvl);
    my $sql = <<"    SQL";
    /* $0 */
    SELECT LOWER(col.column_name) col_name
         , col.column_id          col_id
         , pk.constraint_type     col_pk
         , DECODE(col.data_type, 'NUMBER', '1234567'
                               , 'DATE'  , 'SYSDATE'
                               , CHR(39)||'ABCDE'||CHR(39)
                               )  col_nvl
      FROM all_tab_columns   col
         , (SELECT cc.table_name
                 , cc.column_name
                 , co.constraint_type
              FROM all_cons_columns  cc
                 , all_constraints   co
             WHERE 1=1
               AND cc.owner           = :1
               AND cc.table_name      = :2
               AND cc.owner           = co.owner
               AND cc.table_name      = co.table_name
               AND co.constraint_type = 'P'
               AND co.constraint_name = cc.constraint_name ) pk
     WHERE col.owner           = :1
       AND col.table_name      = :2
       AND col.table_name      = pk.table_name  (+)
       AND col.column_name     = pk.column_name (+)
     ORDER BY col.column_id
    SQL

    # fetching it
    $sth=$dbh->prepare ($sql);
    $sth->bind_param( 1, uc($owner) );
    $sth->bind_param( 2, uc($tab)   );
    $sth->execute;

    while ( ($colname, $colid, $colpk, $colnvl) = $sth->fetchrow_array )
    {
        push @cols   , $colname; # local
        push @col_id , $colid;   # global
        push @col_pk , $colpk;   # global
        push @col_nvl, $colnvl;  # global
    }

    die "No columns found for $owner.$tab .\n\n" unless defined @cols;
    die "No pk defined for $owner.$tab . \n\n"   unless defined @col_pk;

    return @cols;
}

sub upd_tab_perl()
{
    # gen: perl code to make a upd table from a csv file

    my $owner = shift;
    my $tab   = shift;

    my ($ins, $upd);
    my ($list1, $list2, @list1, @list2, @list_bind);

    # insert
    $list1 =       join ( "\n" . " " x 14 . ", "  , @columns );
    $list2 = ":" . join ( "\n" . " " x 14 . ", :" , @col_id );
    $ins = << "    INS";
    INSERT INTO $owner.$tab
              ( $list1
              )
       VALUES ( $list2
              )
    INS
    #print "ins \n$ins \n";

    # update
    for ( my $i=0; $i <= scalar(@columns)-1; $i++ )
    {
        # WHERE and SET
        if ( $col_pk[$i] eq 'P' )
        {
            push @list2, $columns[$i] . " " x (25 - length($columns[$i])) . " = :". $col_id[$i];
        }
        else
        {
            push @list1, $columns[$i] . " " x (25 - length($columns[$i])) . " = :". $col_id[$i];
        };

        # bind_param
        push @list_bind, $col_id[$i] . ", \$v_" . $columns[$i] ;
    }
    $list1 = join( "\n" . " " x 13 . ", "  , @list1 );
    $list2 = join( "\n" . " " x 11 . "AND ", @list2 );
    my $upd = << "    UPD";
    BEGIN
        UPDATE $owner.$tab
           SET $list1
         WHERE $list2
             ;
    EXCEPTION
        WHEN balance.record_exists THEN NULL;
    END;
    UPD
    #print "upd \n$upd \n";

    # list of local variables
    my $list_var = "( \$v_" . join( "\n    , \$v_", @columns);

    # list of bind_param
    my $list_bind1 = "\$st1->bind_param( " . join( ");\n    \$st1->bind_param( ", @list_bind) . ");";
    my $list_bind2 = "\$st2->bind_param( " . join( ");\n        \$st2->bind_param( ", @list_bind) . ");";


    my $code = <<"    TEMPLATE";
    CODE #!/usr/local/bin/perl
    CODE #
    CODE # Generated by: $0
    CODE #
    CODE # upd_table()
    CODE
    CODE use DBI;
    CODE
    CODE # \$|=1; # file autoflush
    CODE
    CODE # Params
    CODE my \$user = "$usr";
    CODE my \$psw  = "$psw";
    CODE my \$sid  = "$sid";
    CODE my \$arq  = "$tab.csv";
    CODE my \$log  = "$tab.log";
    CODE my \$bad  = "$tab.bad";
    CODE my \$out  = "$tab.out";
    CODE
    CODE my (\$kount, \$rc, \$ke, \$ki, \$ku, \$now);
    CODE
    CODE my \$ins  = << "INS";
    CODE $ins
    CODE INS
    CODE
    CODE my \$upd  = << "UPD";
    CODE $upd
    CODE UPD
    CODE
    CODE # db session properties
    CODE my \%attr =  ( PrintError => 0
    CODE             , RaiseError => 0
    CODE             , AutoCommit => 0
    CODE             );
    CODE # Connect
    CODE my \$dbh = DBI->connect ( "dbi:Oracle:\$sid"
    CODE                        , "\$user"
    CODE                        , "\$psw"
    CODE                        , \\%attr
    CODE                        )
    CODE             or die "Cannot connect : ", \$DBI::errstr, "\\n" ;
    CODE
    CODE
    CODE my \$sth = \$dbh->do("alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss'");
    CODE    \$sth = \$dbh->do("dbms_reputil.replication_off");
    CODE    \$sth = \$dbh->do("begin dbms_application_info.set_module('perl: \$0 '); end;");
    CODE
    CODE my \$st1 = \$dbh->prepare( \$ins );
    CODE my \$st2 = \$dbh->prepare( \$upd );
    CODE
    CODE
    CODE # File to process
    CODE open FILE, "<\$arq"
    CODE     or die "Cannot open csv file: \$!\\n";
    CODE
    CODE # Outputs
    CODE open LOG, ">\$log"
    CODE     or die "Cannot open log file: \$!\\n";
    CODE
    CODE open BAD, ">\$bad"
    CODE     or die "Cannot open bad file: \$!\\n";
    CODE
    CODE open OUT, ">\$out"
    CODE     or die "Cannot open out file: \$!\\n";
    CODE
    CODE
    CODE # Processing lines
    CODE (\$kount, \$ke, \$ki, \$ku) = (0,0,0,0);
    CODE \$now = localtime;
    CODE print OUT "-" x 40, "\\n";
    CODE print OUT "\$0 : \$now - RowCount \$kount\\n";
    CODE
    CODE while ( \$line = <FILE> )
    CODE {
    CODE     \$kount++;
    CODE     \$line = substr( \$line, 1, length(\$line)-3); # trimming double quotes
    CODE
    CODE     $list_var
    CODE     ) = split( /\\|;\\|/, \$line);
    CODE
    CODE     \$sth = \$dbh->do("DBMS_APPLICATION_INFO.SET_ACTION('Progress: '||TO_CHAR(\$kount ,'999g999g999g990') )");
    CODE
    CODE     $list_bind1
    CODE     \$st1->execute();
    CODE
    CODE
    CODE     if ( \$DBI::err )
    CODE     {
    CODE         $list_bind2
    CODE         \$st2->execute();
    CODE
    CODE         if ( \$DBI::err )
    CODE         {
    CODE             \$ke++;
    CODE             print LOG "\$ke (\$kount) :\$DBI::errstr \\n";
    CODE             print BAD '"', \$line, '"', "\\n";
    CODE         }
    CODE         else
    CODE         {
    CODE             \$ku++;
    CODE         }
    CODE     }
    CODE     else
    CODE     {
    CODE         \$ki++;
    CODE     }
    CODE
    CODE     # Commit rate
    CODE     if ( (\$ki+\$ku) % 5000 == 0)
    CODE     {
    CODE         \$rc = \$dbh->commit;
    CODE         \$now = localtime;
    CODE         print OUT "\$0 : \$now - RowCount \$kount : ins=\$ki upd=\$ku\\n";
    CODE     }
    CODE
    CODE     # Log rate
    CODE     if ( \$kount % 1000 == 0)
    CODE     {
    CODE         \$now = localtime;
    CODE         print OUT "\$0 : \$now - RowCount \$kount \\n";
    CODE     }
    CODE }
    CODE
    CODE # end
    CODE \$rc = \$dbh->commit;
    CODE \$dbh->disconnect;
    CODE \$now = localtime;
    CODE print OUT "\$0 : \$now - RowCount \$kount : ins=\$ki upd=\$ku\\n";
    CODE print OUT "\$0 : END\\n", "-" x 40, "\\n";
    CODE
    CODE close FILE
    CODE     or die "Cannot close result file: \$! \\n";
    CODE
    CODE close LOG
    CODE     or die "Cannot close log file: \$! \\n";
    CODE
    CODE close BAD
    CODE     or die "Cannot close bad file: \$! \\n";
    CODE
    TEMPLATE

    open FILE, ">${tab}.upd.pl"
        or die "Cannot open ${tab}.upd.pl : $! \n";

    print FILE fmt($code);

    close FILE
        or die "Cannot close ${tab}.upd.pl : $! \n";

}

sub upd_tab_plsql()
{
    # gen: plsql code to make a upd table from a csv file

    my $owner = shift;
    my $tab   = shift;

    my ($ins, $upd, $elements);
    my ($list1, $list2, @list1, @list2, @list_field);

    # insert
    $list1 =         join ( "\n" . " " x 14 . ", "    , @columns );
    $list2 = "r1." . join ( "\n" . " " x 14 . ", r1." , @columns );
    $ins = << "    INS";
    INSERT INTO $owner.$tab
              ( $list1
              )
       VALUES ( $list2
              );
    INS
    #print "ins \n$ins \n";

    $elements = scalar(@columns);
    # update
    for ( my $i=0; $i <= $elements - 1; $i++ )
    {
        # WHERE and SET
        if ( $col_pk[$i] eq 'P' )
        {
            push @list2, $columns[$i] . " " x (25 - length($columns[$i])) . " = r1.". $columns[$i];
        }
        else
        {
            push @list1, $columns[$i] . " " x (25 - length($columns[$i])) . " = r1.". $columns[$i];
        };

        # bind_param
        push @list_field, "r1." . $columns[$i] . " " x (30 - length($columns[$i])) . ":= get_field( " . $col_id[$i] . " );" ;
    }
    $list1 = join( "\n" . " " x 13 . ", "  , @list1 );
    $list2 = join( "\n" . " " x 11 . "AND ", @list2 );
    #print "upd \n$upd \n";


    # list of bind_param
    my $list_field = join( "\n" . " " x 8 , @list_field) ;


    my $code = <<"    TEMPLATE";
    CODE DECLARE
    CODE     --
    CODE     -- Generated by: ./dump_table.pl
    CODE     --
    CODE     --
    CODE     r1              ${tab}%ROWTYPE;
    CODE     elements        PLS_INTEGER := $elements;
    CODE     line            VARCHAR2(32000);
    CODE     fh              UTL_FILE.FILE_TYPE;
    CODE     dirname         VARCHAR2(255) := '/var/oracle/log';
    CODE     filename        VARCHAR2(255) := '$tab.csv';
    CODE     logname         VARCHAR2(255) := '$tab.log';
    CODE     --
    CODE     separator       CHAR(1):=';';
    CODE     encloser        CHAR(1):='|';
    CODE     len PLS_INTEGER := 0;
    CODE     pos PLS_INTEGER := 0;
    CODE     col VARCHAR2(4000);
    CODE     --
    CODE     kount   PLS_INTEGER := 0;
    CODE     k_ins  PLS_INTEGER := 0;
    CODE     k_upd  PLS_INTEGER := 0;
    CODE     --
    CODE     TYPE offset IS RECORD
    CODE         ( beg   PLS_INTEGER
    CODE         , len   PLS_INTEGER
    CODE         );
    CODE     TYPE     ta_offset IS TABLE OF offset INDEX BY BINARY_INTEGER;
    CODE     a_offset ta_offset;
    CODE     --
    CODE     PROCEDURE get_offset IS
    CODE     BEGIN
    CODE         --
    CODE         line := TRIM ( TRAILING separator FROM line );
    CODE         -- from right to left.......
    CODE         len := length( line );
    CODE         FOR i IN REVERSE 2..elements
    CODE         LOOP
    CODE             pos := INSTR(line, encloser||separator||encloser, 1, i-1);
    CODE             a_offset(i).beg := pos + 2;
    CODE             a_offset(i).len := len - pos;
    CODE             --
    CODE             --
    CODE             len := pos -1;
    CODE          -- l4pl.debug( i || ': '||a_offset(i).beg||' '||a_offset(i).len||' - '||len);
    CODE             --
    CODE         END LOOP;
    CODE         --
    CODE         a_offset(1).beg := 1;
    CODE         a_offset(1).len := len+1;
    CODE      -- l4pl.debug( '1 : '||a_offset(1).beg||' '||a_offset(1).len||' - '||len);
    CODE         --
    CODE     END get_offset;
    CODE     --
    CODE     FUNCTION get_field( fld IN NUMBER) RETURN VARCHAR2 IS
    CODE     BEGIN
    CODE         col := TRIM( encloser FROM SUBSTR(line, a_offset(fld).beg, a_offset(fld).len) );
    CODE      -- l4pl.debug('Field '||fld||':'||col);
    CODE         RETURN(col);
    CODE     END get_field;
    CODE     --
    CODE     PROCEDURE ins IS
    CODE     BEGIN
    CODE     $ins
    CODE     END ins;
    CODE     --
    CODE     -----
    CODE     --
    CODE     PROCEDURE upd IS
    CODE     BEGIN
    CODE         UPDATE $owner.$tab
    CODE            SET $list1
    CODE          WHERE $list2
    CODE              ;
    CODE     END upd;
    CODE     --
    CODE BEGIN
    CODE     --
    CODE     l4pl.new_log( dirname, logname, 4 );
    CODE     l4pl.log('Start...');
    CODE     --
    CODE     BEGIN
    CODE         fh := UTL_FILE.FOPEN( dirname, filename, 'R');
    CODE     EXCEPTION
    CODE         WHEN UTL_FILE.INVALID_PATH THEN
    CODE             l4pl.error('invalid_path');
    CODE         WHEN UTL_FILE.INVALID_MODE THEN
    CODE             l4pl.error('invalid_mode');
    CODE         WHEN UTL_FILE.INVALID_OPERATION THEN
    CODE             l4pl.error('invalid_operation');
    CODE     END;
    CODE     --
    CODE     DBMS_REPUTIL.REPLICATION_OFF;
    CODE     DBMS_APPLICATION_INFO.SET_MODULE( 'upd_from_file: [$tab]' , 'START');
    CODE     DBMS_SESSION.SET_NLS('nls_date_format','"DD/MM/YYYY HH24:MI:SS"');
    CODE     --
    CODE     LOOP
    CODE         --
    CODE         BEGIN
    CODE             UTL_FILE.GET_LINE( fh, line );
    CODE             kount := kount +1;
    CODE         EXCEPTION
    CODE             WHEN NO_DATA_FOUND THEN
    CODE                 EXIT; --LOOP
    CODE             WHEN utl_file.write_error THEN
    CODE                 l4pl.error('write_error');
    CODE                 EXIT; --LOOP
    CODE             WHEN utl_file.internal_error THEN
    CODE                 l4pl.error('internal_error');
    CODE                 EXIT; --LOOP
    CODE             WHEN OTHERS THEN
    CODE                 l4pl.error('Get_line '||SQLERRM);
    CODE                 EXIT;
    CODE         END;
    CODE         --
    CODE         get_offset;
    CODE         --
    CODE         $list_field
    CODE         --
    CODE         BEGIN
    CODE             ins;
    CODE             k_ins := k_ins + 1;
    CODE         EXCEPTION
    CODE             WHEN DUP_VAL_ON_INDEX THEN
    CODE                 BEGIN
    CODE                     upd;
    CODE                     k_upd := k_upd + 1;
    CODE                 EXCEPTION
    CODE                     WHEN balance.record_exists THEN NULL;
    CODE                     WHEN OTHERS THEN l4pl.error('UPD '||SQLERRM);
    CODE                 END;
    CODE                 --
    CODE             WHEN OTHERS THEN
    CODE                 l4pl.error('UPD '||kount||': '||SQLERRM);
    CODE                 NULL;
    CODE         END;
    CODE         --
    CODE         IF  MOD( k_ins + k_upd, 5000 ) = 0
    CODE         AND    ( k_ins + k_upd ) > 0
    CODE         THEN
    CODE             COMMIT;
    CODE             l4pl.log(' ins='||k_ins||' upd='||k_upd);
    CODE         END IF;
    CODE         --
    CODE         IF MOD( kount, 1000 ) = 0
    CODE         THEN
    CODE             COMMIT;
    CODE             l4pl.log(' Row Count '||TO_CHAR(kount ,'999g999g999g990'));
    CODE         END IF;
    CODE         --
    CODE         DBMS_APPLICATION_INFO.SET_ACTION ( 'Progress: '||TO_CHAR(kount ,'999g999g999g990') );
    CODE         --
    CODE     END LOOP;
    CODE     --
    CODE     COMMIT;
    CODE     l4pl.log('Final - Rows = '||TO_CHAR(kount ,'9g999g999g990')||' ( ins='||k_ins||' upd='||k_upd||' )');
    CODE     DBMS_APPLICATION_INFO.SET_ACTION ( 'Final: '||TO_CHAR(kount ,'999g999g999g990'));
    CODE     --
    CODE     UTL_FILE.FCLOSE(fh);
    CODE     l4pl.end_log;
    CODE     --
    CODE END;
    CODE /
    CODE
    TEMPLATE

    open FILE, ">${tab}.upd.prc.sql"
        or die "Cannot open ${tab}.upd.prc.sql : $! \n";

    print FILE fmt($code);

    close FILE
        or die "Cannot close ${tab}.upd.prc.sql : $! \n";

}

sub make_trigger()
{
    #### Trigger for update (replication)
    #my $list1 =         join ( "\n         , "                 , @columns );
    #my $list2 =         join ( "\n                      , "    , @columns );
    #my $list3 = "r1." . join ( "\n                      , r1." , @columns );

    my $owner = shift;
    my $tab   = shift;
    my ($colname, $colnvl);
    my $trigger = "tbu_repl_" . substr( $tab, 0, 21 ) ;

    my $now = localtime ;
    my $condition = "";
    my $separator = "IF  ";
    my $new = "\:NEW." ;
    my $old = "\:OLD." ;
    my $largest = 0;
    my $elements = 0;

    # max column size
    foreach $colname (@columns)
    {
        $largest = length ( $colname ) if length( $colname ) > $largest ;
        $elements++;
    }
    my $mask = "A" . $largest;

    # condition text
    for (my $i=0; $i<$elements; $i++)
    {
        $colname = $columns[$i];
        $colnvl  = $col_nvl[$i];
        $condition .= $separator
                    . "NVL(" . $new . pack( $mask, $colname ) . ", $colnvl )"
                    . " = "
                    . "NVL(" . $old . pack( $mask, $colname ) . ", $colnvl )"
                    ;
        $separator = "\n    AND ";
    }

    my $code = <<"    TRIGGER" ;
    CODE CREATE OR REPLACE TRIGGER $owner.$trigger
    CODE     BEFORE UPDATE
    CODE         ON $tab
    CODE        FOR EACH ROW
    CODE BEGIN
    CODE     -- \$Id\$
    CODE     -- Generated by $0 ( $now )
    CODE     -- Criado:
    CODE     --      Marcus Vinicius Ferreira    Fev/2005
    CODE     --
    CODE     -- OBS: updates onde TODOS os valores antes e depois SAO IGUAIS
    CODE     --      sao ignorados para diminuir "overhead" na replicacao
    CODE     --
    CODE     $condition
    CODE     THEN
    CODE         RAISE balance.record_exists;
    CODE     END IF;
    CODE     --
    CODE END;
    CODE /
    CODE
    CODE show err
    CODE
    TRIGGER

    open FILE, "> ${tab}.repl.trg.sql"
        or die "Cannot open ${tab}.repl.trg.sql : $! \n";

    print FILE fmt($code);

    close FILE
        or die "Cannot close ${tab}.repl.trg.sql : $! \n";
}

sub fmt()
{
    my $code = shift;
    $code =~ s/^\s*CODE //gm;   # CODE followed by content
    $code =~ s/^\s*CODE\n/\n/gm; # CODE alone in one line (i.e., empty line)
    return $code;
}

__END__
