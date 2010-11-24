
sqlplus_cmd() {
sqlplus -s -L $CONNECT <<SQL

    WHENEVER SQLERROR EXIT FAILURE
    set echo on
    set feedback on
    set time off
    set timing off
    set serveroutput on size 1000000

    ------
    ------ SQL here!
    ------
    DELETE scott.emp
     WHERE empno > 1400
         ;
    ROLLBACK;
    ------
    ------
    ------

SQL
}

