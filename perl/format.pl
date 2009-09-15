
# Formatos de output

format SPOOL =
@<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<< @>>>>>>>>>>>>>> @#######.## @######.##
$dname,$ename,$job,$sal,$comm
.



# Preparando arquivos
open(SPOOL,">spool.txt")
    ||die "Cannot open: spool.txt";
    print SPOOL "Dname              Ename            Job             Salary      Commission\n";
    print SPOOL "------------------ ---------------- --------------- ----------- ----------\n";


open(SOURCE,"<source.txt")
    ||die "Cannot open: 1.txt";

# Gerando arquivos
while( <SOURCE> ) {
    chomp;
    ($dname, $ename, $job, $sal, $comm) = split;

    write (SPOOL);
}
close(SPOOL);
close(SOURCE);
