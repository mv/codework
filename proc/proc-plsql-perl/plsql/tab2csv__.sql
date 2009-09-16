CREATE OR REPLACE PROCEDURE tab2csv  ( pi_table_name IN VARCHAR2 DEFAULT NULL) IS
-- _____________________________________________________
--
-- $Id: tab2csv__.sql 6 2006-09-10 15:35:16Z marcus $
--
-- tab2csv: export a table in csv format
--
-- Marcus Vinicius Ferreira   Abr/2002
-- _____________________________________________________
--
    --
    -- File Handles
    fh_csv      UTL_FILE.FILE_TYPE; -- table log
    line        VARCHAR2(1022);
    --
    -- Work dir
    --
    table_name      VARCHAR2(255);
    dir_name        VARCHAR2(255) := '/tmp'; -- verify UTL_FILE_DIR and adapt
    --
    -- Dynamic SQL
    --
    TYPE  t_cursor IS REF CURSOR;
    c_emp t_cursor;
    v_sql VARCHAR2(255);
    --
    ---------------------------------
    -- parameters: parameter logic
    --
    BEGIN
        -- Handle parameter
        IF pi_table_name IS NULL
        THEN
            DBMS_OUTPUT.PUT_LINE('-- ');
            DBMS_OUTPUT.PUT_LINE('-- Usage:');
            DBMS_OUTPUT.PUT_LINE('--    tab2csv ( <table name> [, <work dir> ] )');
            DBMS_OUTPUT.PUT_LINE('-- ');
            RETURN;
        ELSE
            table_name := LOWER(pi_table_name);
        END IF;
        --
    -- open_files: create table specific files
        fh_csv := UTL_FILE.FOPEN( dir_name , table_name||'.dat', 'W');

    -- Gerando SQL
    v_sql := 'SELECT CHR(39)||empno       ||CHR(39)'||
             '||'',''|| CHR(39)||ename    ||CHR(39)'||
             '||'',''|| CHR(39)||job      ||CHR(39)'||
             '||'',''|| CHR(39)||mgr      ||CHR(39)'||
             '||'',''|| CHR(39)||hiredate ||CHR(39)'||
             '||'',''|| CHR(39)||sal      ||CHR(39)'||
             '||'',''|| CHR(39)||comm     ||CHR(39)'||
             '||'',''|| CHR(39)||deptno   ||CHR(39)'||
             ' FROM '||table_name);

    OPEN c_emp FOR v_sql;
    LOOP
        FETCH c_emp INTO line;
        EXIT WHEN c_emp%NOTFOUND;
        UTL_FILE.PUT_LINE(fh_csv, line);
    END LOOP;
    --
    UTL_FILE.FCLOSE(fh_csv);
    --
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!'||SQLERRM);
END;
/

-- @C:\work\ferremv\tab2csv\plsql\tab2csv.sql