
conn wlr/wlr@devfs

set pagesize 0
set trimspool on

COLUMN dt FORMAT A10
COLUMN patch_name FORMAT A20

select TO_CHAR(trunc(creation_date), 'YYYY-MM-DD') as dt, patch_name
  from patches t
 where creation_date > to_date('2007-04-21','yyyy-mm-dd')


spool lst.txt
/
spool off


