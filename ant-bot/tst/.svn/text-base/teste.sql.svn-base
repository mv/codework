-- $Id: teste.sql 6 2006-09-10 15:35:16Z marcus $
--
-- teste.sql
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


conn scott/tiger@&&TNS

    prompt  1 tns      &&1
    prompt  2 usr      &&2
    prompt  3 cd_mun   &&3
    prompt  4 cd_uf    &&4
    prompt  5 cnc      &&5
    prompt  6 est      &&6
    prompt  7 srv      &&7

--
-- Fim
--
prompt "Fim..."

    exit
