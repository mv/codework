CREATE OR REPLACE PROCEDURE tab2csv (p_nm_tab IN VARCHAR2 DEFAULT NULL) IS
    --
    fh    UTL_FILE.FILE_TYPE;
    line  VARCHAR2(2000);
    --
    cmd   VARCHAR2(500);
    TYPE  tp_cursor IS REF CURSOR;
    c_emp tp_cursor;
    --
    nm_tab VARCHAR2(255);
    nm_arq VARCHAR2(255);
    --
BEGIN
    -- Parametros
    IF p_nm_tab IS NULL
    THEN
        DBMS_OUTPUT.PUT_LINE('-- ');
        DBMS_OUTPUT.PUT_LINE('-- Usage:');
        DBMS_OUTPUT.PUT_LINE('--    tab2csv ( <table name> )');
        DBMS_OUTPUT.PUT_LINE('-- ');
        RETURN;
    END IF;

    -- Abre o arquivo
    fh := UTL_FILE.FOPEN('/tmp', p_nm_tab||'.csv','w');

    -- Define cmd
    cmd := 'SELECT CHR(39)|| empno     ||CHR(39)' ||CHR(10);
    cmd :=  cmd||'||'||CHR(39)||','||CHR(39)||'||CHR(39)|| ename     ||CHR(39)'||CHR(10);
    cmd :=  cmd||'||'||CHR(39)||','||CHR(39)||'||CHR(39)|| job       ||CHR(39)'||CHR(10);
    cmd :=  cmd||'||'||CHR(39)||','||CHR(39)||'||CHR(39)|| mgr       ||CHR(39)'||CHR(10);
    cmd :=  cmd||'||'||CHR(39)||','||CHR(39)||'||CHR(39)|| hiredate  ||CHR(39)'||CHR(10);
    cmd :=  cmd||'||'||CHR(39)||','||CHR(39)||'||CHR(39)|| sal       ||CHR(39)'||CHR(10);
    cmd :=  cmd||'||'||CHR(39)||','||CHR(39)||'||CHR(39)|| comm      ||CHR(39)'||CHR(10);
    cmd :=  cmd||'||'||CHR(39)||','||CHR(39)||'||CHR(39)|| deptno    ||CHR(39) cmd'||CHR(10);
    cmd :=  cmd|| '  FROM '||p_nm_tab;

    --
    OPEN c_emp FOR cmd;
    LOOP
        FETCH c_emp INTO line;
        EXIT WHEN c_emp%NOTFOUND;

        -- Gera o arquivo
        UTL_FILE.PUT_LINE(fh, line);

    END LOOP;

    -- Fim do Processo
    UTL_FILE.FCLOSE(fh);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro! '||SQLERRM);
        UTL_FILE.FCLOSE(fh);
END;
/
-- @C:\work\ferremv\tab2csv\plsql\tab2csv.sql
