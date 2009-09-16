DECLARE
    TYPE EmpCurTyp IS REF CURSOR RETURN emp%ROWTYPE; -- strong
    TYPE GenericCurTyp IS REF CURSOR; -- weak
    --
    dept_cv DeptCurTyp;
    --
BEGIN
    OPEN generic_cv FOR exp_sql;
    LOOP
        FETCH emp_cv INTO line;
        EXIT WHEN emp_cv%NOTFOUND; -- exit when last row is fetched
        --
        UTL_FILE.PUT_LINE(fh,line);
        --
    END LOOP;