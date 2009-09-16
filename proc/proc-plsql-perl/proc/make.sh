proc iname=tab2csv.pc oname=tab2csv.c
gcc tab2csv.c -o tab2csv \
              -I/u01/app/oracle/product/8.1.7/precomp/public \
              -L/u01/app/oracle/product/8.1.7/lib \
              -lclntsh
