CREATE OR REPLACE PROCEDURE tab2csv  ( pi_table_name IN VARCHAR2 DEFAULT NULL
                                     , pi_dir_name   IN VARCHAR2 DEFAULT NULL) IS
-- _____________________________________________________
--
-- $Id: tab2csv.sql 6 2006-09-10 15:35:16Z marcus $
--
-- tab2csv: export a table in csv format
--
-- Marcus Vinicius Ferreira   Abr/2002
-- _____________________________________________________
--
--   Main idea:
--      body
--        +- parameters
--        +- open_files
--        +- get_table_name
--        +- get_table_desc
--        +- exp_table
--        |    +- exp_line
--        +- time_measure
--        +- close_files
--
    --
    -- File Handles
    fh          UTL_FILE.FILE_TYPE; -- process log
    fh_log      UTL_FILE.FILE_TYPE; -- table log
    fh_dat      UTL_FILE.FILE_TYPE; -- table in csv format
    --
    -- Work dir
    --
    table_name      VARCHAR2(255);
    dir_name        VARCHAR2(255) := '/tmp/tab2csv'; -- verify UTL_FILE_DIR and adapt
    --
    -- Line control
    --
    n_count_line    NUMBER := 0;
    vc_line         VARCHAR2(2000);
    --
    -- Dynamic SQL
    --
    exp_sql         VARCHAR2(2000):=' ';
    --
    PROCEDURE p (line IN VARCHAR2) IS
    ---------------------------------
    -- p: print log information
    --
    BEGIN
        UTL_FILE.PUT_LINE(fh, TO_CHAR(SYSDATE,'dd/mm/yyyy hh24:mi:ss')||' - '||line);
    EXCEPTION
        WHEN OTHERS THEN
            UTL_FILE.FCLOSE(fh);
            RAISE_APPLICATION_ERROR(-20002,'Error p: '||SQLERRM);
    END p;
    --
    FUNCTION q (value IN VARCHAR2) RETURN VARCHAR2 IS
    ---------------------------------
    -- q: quote a string
    --
    BEGIN
        RETURN( CHR(39)||value||CHR(39) );
    EXCEPTION
        WHEN OTHERS THEN
            UTL_FILE.FCLOSE(fh);
            RAISE_APPLICATION_ERROR(-20003,'Error q: '||SQLERRM);
    END q;
    --
    PROCEDURE parameters IS
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
        IF pi_dir_name IS NOT NULL
        THEN
           dir_name := pi_dir_name;
        END IF;
        --
        p('Files: '||dir_name||'/'||table_name||'.*');
        --
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Erro parameters: '||SQLERRM);
    END parameters;
    --
    PROCEDURE open_files IS
    ---------------------------------
    -- open_files: create table specific files
    --
    BEGIN
        p('Opening Files');
        fh_dat := UTL_FILE.FOPEN( dir_name , table_name||'.dat', 'W');
        fh_log := UTL_FILE.FOPEN( dir_name , table_name||'.log', 'W');
        p('Opening Files: done.');
    EXCEPTION
        WHEN utl_file.invalid_path THEN
            RAISE_APPLICATION_ERROR(-20011, 'Erro abrindo arquivo: invalid_path ');
        WHEN utl_file.invalid_mode THEN
            RAISE_APPLICATION_ERROR(-20012, 'Erro abrindo arquivo: invalid_mode ');
        WHEN utl_file.invalid_operation THEN
            RAISE_APPLICATION_ERROR(-20013, 'Erro abrindo arquivo: invalid_operation ');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20014, 'Erro abrindo arquivo: '||SQLERRM);
    END open_files;
    --
    PROCEDURE close_files IS
    ---------------------------------
    -- close_files: close table specific files
    --
    BEGIN
        UTL_FILE.FCLOSE(fh_dat);
        UTL_FILE.FCLOSE(fh_log);
        p('Files Closed.');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20021, 'Erro fechando arquivos: '||SQLERRM);
    END close_files;
    --
    PROCEDURE get_table_name IS
    BEGIN
        NULL;
    END get_table_name;
    --
    PROCEDURE get_table_desc IS
    ---------------------------------
    -- get_table_desc: finds table description/structure
    --                 and builds sql string to be executed
    -- OBS: nu, dt, vc : conversion and quoting for each specific datatype
    --
        CURSOR c_desc (p_table_name IN VARCHAR2) IS
        SELECT owner
             , table_name
             , column_name
             , data_type
          FROM all_tab_columns
         WHERE table_name = UPPER(p_table_name)
      ORDER BY column_id;
      --
      sep  VARCHAR2(050):='  ';  -- separator: null for just the 1st iteration
      col  VARCHAR2(200);
      odq  VARCHAR2(50) := 'CHR(34)||';  -- open double quotes
      cdq  VARCHAR2(50) := '||CHR(34)';  -- close double quotes
      --
    BEGIN
        NULL;
        p('Table description...');
        FOR r1 IN c_desc (table_name)
        LOOP
            IF r1.data_type NOT IN ('DATE','NUMBER','VARCHAR2','CHAR')
            THEN
                p('    Datatype '||r1.data_type||' will not be handled.');
                p('    Aborting.');
                RAISE_APPLICATION_ERROR(-20031,'Datatype will not be handled');
            END IF;
            --
            IF r1.data_type = 'NUMBER'
            THEN
                col := sep|| odq ||'TO_CHAR('||r1.column_name||')' ||cdq   || CHR(10);
            ELSIF r1.data_type = 'DATE'
            THEN
                col := sep|| odq ||'TO_CHAR('||r1.column_name||','
                          || q('dd/mm/yyyy hh24:mi:ss'  )||')'     ||cdq   || CHR(10);
            ELSE
                col := sep|| odq ||r1.column_name                  ||cdq   || CHR(10);
            END IF;
            --
            exp_sql := exp_sql || col ;
            sep     := '|| '|| q(',')||' || '; -- next iteration will be formally separated
            --
        END LOOP;
        --
        exp_sql := 'SELECT '||exp_sql||' reg FROM '||table_name;
        p('SQL to be executed : ');
        p( CHR(10)||exp_sql );
        --
    END get_table_desc;
    --
    PROCEDURE exp_table IS
    BEGIN
        NULL;
    END exp_table;
    --
    PROCEDURE exp_line IS
    BEGIN
        NULL;
    END exp_line;
    --
BEGIN
    -- Main body
    fh     := UTL_FILE.FOPEN( '/tmp'   , 'tab2csv.log'     , 'A');
    p('Begin');
    p('=========================');
    --
    ----
    --
    parameters;
    open_files;

    get_table_desc;

    close_files;
    --
    ----
    --
    p('End  ');
    p('=========================');
    p('________________________________________________');
    p('');
    UTL_FILE.FCLOSE(fh);
    --
EXCEPTION
    WHEN OTHERS THEN
        p('Error!'||SQLERRM);
        close_files;
        UTL_FILE.FCLOSE(fh);
END;
/
