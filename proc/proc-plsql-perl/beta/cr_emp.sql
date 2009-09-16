CREATE TABLE EMP1
(empno      NUMBER(4) NOT NULL
,ename      VARCHAR2(10)
,job        VARCHAR2(9)
,mgr        NUMBER(4)
,hiredate   DATE
,sal        NUMBER(7, 2)
,comm       NUMBER(7, 2)
,deptno     NUMBER(2)
)
   PCTUSED 0
   PCTFREE 5
   STORAGE(INITIAL 512k
           NEXT     1M
           PCTINCREASE 0)
/

CREATE TABLE EMP2
(empno      NUMBER(4) NOT NULL
,ename      VARCHAR2(10)
,job        VARCHAR2(9)
,mgr        NUMBER(4)
,hiredate   DATE
,sal        NUMBER(7, 2)
,comm       NUMBER(7, 2)
,deptno     NUMBER(2)
)
   PCTUSED 0
   PCTFREE 5
   STORAGE(INITIAL 24M
           NEXT     1M
           PCTINCREASE 0)
/

CREATE TABLE EMP3
(empno      NUMBER(4) NOT NULL
,ename      VARCHAR2(10)
,job        VARCHAR2(9)
,mgr        NUMBER(4)
,hiredate   DATE
,sal        NUMBER(7, 2)
,comm       NUMBER(7, 2)
,deptno     NUMBER(2)
)
   PCTUSED 0
   PCTFREE 5
   STORAGE(INITIAL 240M
           NEXT      1M
           PCTINCREASE 0)
/
