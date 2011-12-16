# Modulos de conexao ao DB
use strict;
use DBI;

# Variaveis locais
my ($dname);
my ($ename);
my ($job);
my ($sal);
my ($comm);

# Formatos de output

format ADDRESS_LABEL =
============================================
  @<<<<<<<<
$dname
  @<<<<<<<<<<<<<<<<<<      @>>>>>>>>>>>>>>>>
$ename,$job
  Salary @#########.##   Comission @#####.##
$sal,$comm
=============================================
-----------< cut here >--------------------------------------
.

format SPOOL =
@<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<< @>>>>>>>>>>>>>> @#######.## @######.##
$dname,$ename,$job,$sal,$comm
.

format CSV =
'@<<<<<<<<<<<<<<<<<','@<<<<<<<<<<<<<<<','@>>>>>>>>>>>>>>','@#######.##','@######.##'
$dname,$ename,$job,$sal,$comm
.


# Conexao com o banco
my $dbh = DBI->connect( 'dbi:Oracle:spcad',
                        'scott',
                        'tiger',
                        { RaiseError => 1, AutoCommit => 0 }
                      ) || die "Database connection not made: $DBI::errstr";

# Preparando comando SQL
my $sql = qq{  SELECT dname,ename,job,sal,comm
                 FROM emp
                    , dept
                WHERE emp.deptno = dept.deptno  };    # Prepare and execute SELECT
my $sth = $dbh->prepare($sql);
$sth->execute();

my($tname);                               # Declare columns
$sth->bind_columns( undef, \$dname, \$ename, \$job, \$sal, \$comm );


# Preparando arquivos
open(ADDRESS_LABEL,">labels.txt")
    ||die "Cannot open: labels.txt";

open(SPOOL,">spool.txt")
    ||die "Cannot open: spool.txt";
    print SPOOL "Dname              Ename            Job             Salary      Commission\n";
    print SPOOL "------------------ ---------------- --------------- ----------- ----------\n";


open(CSV,">emp_csv.txt")
    ||die "Cannot open: emp_csv.txt";

# Gerando arquivos
while( $sth->fetch() ) {
    # fetch já povoa variáveis, portanto basta usá-las
    write (ADDRESS_LABEL);
    write (SPOOL);
    write (CSV);
}

# Close cursor
$sth->finish();

# Fim do programa
$dbh->disconnect;
close(ADRESS_LABEL);
close(SPOOL);
close(CSV);
