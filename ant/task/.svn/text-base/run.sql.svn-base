-- $Id: run.sql 6 2006-09-10 15:35:16Z marcus $
--
-- Generic run.sql
--
-- &&1 : tns to connect
-- &&2 : schema name
-- &&3 : cd municipio
-- &&4 : cd uf
-- &&5 : cnc
-- &&6 : est
-- &&7 : service_name/global_name

DEFINE tns=&&1
DEFINE usr=&&2
DEFINE cd_mun=&&3
DEFINE cd_uf=&&4
DEFINE cnc=&&5
DEFINE est=&&6
DEFINE srv=&&7

set timing on
set verify off
set feedback on
set trimspool on

--WHENEVER OSERROR  EXIT FAILURE
--WHENEVER SQLERROR EXIT WARNING


conn system/manager@&&TNS

    prompt "Tarefas SYSTEM"
    DROP PUBLIC SYNONYM cd_fx_etaria              ;
    DROP PUBLIC SYNONYM fx_etaria_proced          ;

    CREATE PUBLIC SYNONYM proc_realizados           FOR "&&USR".proc_realizados     ;
    CREATE PUBLIC SYNONYM proc_realizados_ups       FOR "&&USR".proc_realizados_ups ;

conn scott/tiger@&&TNS

    prompt "Tarefas F01"
    @C:\usr\work\cns\db\plsql\cd_fx_etaria.fnc.sql
    @C:\usr\work\cns\db\plsql\fx_etaria_proced.fnc.sql

    GRANT EXECUTE ON cd_fx_etaria       TO rl_cns_tudo;
    GRANT EXECUTE ON fx_etaria_proced   TO rl_cns_tudo;

    GRANT EXECUTE ON cd_fx_etaria       TO "&&USR" WITH GRANT OPTION;
    GRANT EXECUTE ON fx_etaria_proced   TO "&&USR" WITH GRANT OPTION;

conn "&&USR"/"&&USR"@&&TNS

    prompt "Tarefas &&USR"
    @C:\usr\work\cns\db\sql_mun\vw\proc_realizados.vw.sql
    @C:\usr\work\cns\db\sql_mun\vw\proc_realizados_ups.vw.sql

    GRANT SELECT ON proc_realizados         TO rl_cns_tudo;
    GRANT SELECT ON proc_realizados_ups     TO rl_cns_tudo;

--
-- Fim
--
prompt "Fim..."

    exit
