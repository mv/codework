
-- dbext:type=DBI:driver=mysql:user=root:passwd=r00t:conn_parms=database=mktplace_core;host=localhost;port=3306'
-- dbext:type=MYSQL:user=root:passwd=@askb:dbname=mktplace_core:host=localhost:port=3306:extra=-t'

select make
     , model
     , count(1) as qtd
  from mktplace_core.versions
 group by make
     , model
  ;


