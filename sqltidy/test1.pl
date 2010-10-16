#!/u01/perl/bin/perl

use SQL::Beautify ;

my $sql_query= <<SQL;

SELECT to_char( c.dat_inc, 'yyyy-mm' ) as dt , count(1) as qtd , cod_site FROM pwa_adm.conteudo c INNER JOIN pwa_adm.secao s ON c.cod_secao = s.cod_secao WHERE s.cod_site = 6                        AND c.cod_tipo_conteudo IN (1, 2, 3, 4, 5) AND c.dat_inc >=  TO_DATE('01/01/1996 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND c.dat_inc <   TO_DATE('31/01/2011 23:59:59', 'DD/MM/YYYY HH24:MI:SS') GROUP BY cod_site , to_char( c.dat_inc, 'yyyy-mm' ) ORDER BY 1,3 ;

SQL

print "SQL: ",$sql_query, "\n";

my $sql = new SQL::Beautify;
   $sql->query($sql_query);

print "Nice: \n", $sql->beautify, "\n";

