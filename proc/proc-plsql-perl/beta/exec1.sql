sqlplus -s scott/tiger@spcad << SQL

exec emp2csv('emp1.dat')
SQL
