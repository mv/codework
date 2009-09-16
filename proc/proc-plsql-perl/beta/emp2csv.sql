CREATE OR REPLACE PROCEDURE emp2csv (p_nm_tab IN VARCHAR2 DEFAULT NULL
                                    ,p_nm_arq IN VARCHAR2 DEFAULT NULL) IS
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
    nm_tab := NVL(p_nm_tab, 'emp');
    nm_arq := NVL(p_nm_arq, 'emp.dat');

    -- Abre o arquivo
    fh := UTL_FILE.FOPEN('/tmp', p_nm_arq,'w');

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
    --DBMS_OUTPUT.PUT_LINE('cmd '||CHR(10)||substrcmd);

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
