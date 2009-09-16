use strict;
use DBI;

# Trata os parametros
#if ( $ARGV[0] == "" ) {
#    print "\n  Usage: perl tab2csv.pl <table_name> \n";
#    print "argv $ARGV[0]";
#    exit 1;
#}

#Abrindo arquivo
open(CSV, ">$ARGV[0].csv" )||
   die "Sorry, I couldn't create $ARGV[0]\n";

# Conexao com o banco
my $dbh = DBI->connect( 'dbi:Oracle:spcad',
                        'scott',
                        'tiger',
                        { RaiseError => 1, AutoCommit => 0 }
                      ) || die "Database connection not made: $DBI::errstr";

# Preparando comando SQL
my $sql = qq{ SELECT CHR(39)||empno     ||CHR(39) \
              ||','|| CHR(39)||ename    ||CHR(39) \
              ||','|| CHR(39)||job      ||CHR(39) \
              ||','|| CHR(39)||mgr      ||CHR(39) \
              ||','|| CHR(39)||hiredate ||CHR(39) \
              ||','|| CHR(39)||sal      ||CHR(39) \
              ||','|| CHR(39)||comm     ||CHR(39) \
              ||','|| CHR(39)||deptno   ||CHR(39) \
               FROM $ARGV[0]  };    # Prepare and execute SELECT
my $sth = $dbh->prepare($sql);
$sth->execute();

my($tname);                               # Declare columns
$sth->bind_columns(undef, \$tname);

#Abrindo arquivo

# Gerando arquivo
while( $sth->fetch() ) {
    print CSV "$tname\n";

}
$sth->finish();                           # Close cursor

# Fim do programa
$dbh->disconnect;
close(CSV);
