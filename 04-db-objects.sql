--------------
-- DB OBJECTS
--------------

-- SYSTEM으로 진행
-- VIEW 생성을 위한 SYSTEM 권한
GRANT CREATE VIEW TO himedia;

GRANT SELECT ON hr.EMPLOYEES TO himedia;
GRANT SELECT ON HR.DEPARTMENTS TO himedia;

-- himedia
-- Simple View
-- 단일 테이블 혹은 단일 뷰를 베이스로 한 함수, 연산식을 포함하지 않는 View

-- emp123
DESC EMP123;

-- EMP123 테이블을 기반, DEPARTMENT_ID = 10 부서 소속 사원만 조회하는 View
CREATE OR REPLACE VIEW EMP10
    AS SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
    FROM EMP123
    WHERE DEPARTMENT_ID = 10;

-- 일반 테이블처럼 활용할 수 있음
SELECT * FROM EMP10;
DESC EMP10;

SELECT FIRST_NAME ||' '||LAST_NAME 이름, SALARY FROM EMP10;

-- Simple View 는 제약 사항에 걸리지 않는다면 INSERT, UPDATE, DELETE를 할 수 있다.
UPDATE EMP10 SET SALARY = SALARY * 2;
SELECT * FROM EMP10;

ROLLBACK;

-- 가급적 VIEW는 조회용으로만 활용하자
-- WITH READ ONLY
CREATE OR REPLACE VIEW EMP10
    AS SELECT EMPLOYEE_ID, FIRST_NAME,LAST_NAME, SALARY
        FROM EMP123
        WHERE DEPARTMENT_ID = 10
    WITH READ ONLY;

UPDATE EMP10 SET SALARY = SALARY * 2; -- DML 작업 수행X , 오류 발생

-- Complex View
-- 한 개 혹은 여러개의 테이블, view에 join,함수, 연산식 등을 활용한 view
-- 특별한 경우가 아니면 INSERT,UPDATE, DELETE 작업 수행 불가.
CREATE OR REPLACE VIEW EMP_DETAIL
    (EMPLOYEE_ID, EMPLOYEE_NAME, MANAGER_NAME, DEPARTMENT_NAME)
AS SELECT
        E.EMPLOYEE_ID,
        E.FIRST_NAME||' '||E.LAST_NAME,
        M.FIRST_NAME||' '||M.LAST_NAME,
        DEPARTMENT_NAME
    FROM HR.EMPLOYEES E JOIN HR.EMPLOYEES M
    ON E.MANAGER_ID = M.EMPLOYEE_ID JOIN HR.DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;


DESC EMP_DETAIL;

SELECT * FROM EMP_DETAIL;

-- VIEW를 위한 딕셔너리 : VIEWS
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_OBJECTS;  -- View 포함 모든 DB객체들의 정보

-- VIEW를 삭제해도 기반 테이블 데이터는 삭제되지 않음
DROP VIEW EMP_DETAIL;
SELECT * FROM USER_VIEWS;


--------------
-- INDEX
--------------

-- hr.EMPLOYEES 테이블 복사 => S.EMP 테이블 생성
CREATE TABLE S_EMP
AS SELECT * FROM HR.EMPLOYEES;

DESC S_EMP;
SELECT * FROM S_EMP;

-- S_EMP 테이블의  EMPLOYEE_ID 에 USIQUE INDEX를 걸어봄
CREATE UNIQUE INDEX S_EMP_ID_pk
ON s_EMP (EMPLOYEE_ID);

-- 사용자가 가지고 있는 인덱스 확인
SELECT * FROM USER_INDEXES;
-- 어느 인덱스가 어느 컬럼에 걸려있는지 확인
SELECT * FROM USER_IND_COLUMNS;

-- 어느 인덱스 어느 컬럼에 걸려 있는지 JOIN해서 알아봄
SELECT t.INDEX_NAME,t.TABLE_NAME ,c.COLUMN_NAME, c.COLUMN_POSITION
FROM USER_INDEXES t JOIN USER_IND_COLUMNS c
ON t.INDEX_NAME = c.INDEX_NAME
WHERE t.TABLE_NAME = 'S_EMP';


------------------
-- SEQUENCE
------------------

SELECT * FROM AUTHOR;

-- 새로운 레코드를 추가. 겹치지 않는 유일한 PK가 필요
INSERT INTO AUTHOR (AUTHOR_ID, AUTHOR_NAME)
VALUES (
    (SELECT MAX(AUTHOR_ID)+1 FROM AUTHOR),'이문열');

SELECT * FROM AUTHOR;
ROLLBACK;
DELETE FROM AUTHOR;
COMMIT;
-- 순차 객체 SEQUENCE
CREATE SEQUENCE SEQ_AUTHOR_ID
    START WITH 4
    INCREMENT BY 1
    MAXVALUE 1000000;
    
-- PK는 SEQUENCE 객체로부터 생성
INSERT INTO AUTHOR(AUTHOR_ID,AUTHOR_NAME,AUTHOR_DESC)
VALUES (SEQ_AUTHOR_ID.NEXTVAL,'스티븐 킹','쇼생크 탈출');

INSERT INTO AUTHOR(author_id, author_name, author_desc) 
VALUES (seq_author_id.NEXTVAL,?,?);
SELECT * FROM AUTHOR;

SELECT SEQ_AUTHOR_ID.CURRVAL FROM DUAL;

-- 새 시퀀스 생성
CREATE SEQUENCE MY_SEQ
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 10;
    
SELECT MY_SEQ.NEXTVAL FROM DUAL; -- 시작값 1. 다음 시퀀스 추출 가상 컬럼
SELECT MY_SEQ.CURRVAL FROM DUAL; -- 현재값 1. 시퀀스 현재 상태

-- 시퀀스 수정
ALTER SEQUENCE MY_SEQ
    INCREMENT BY 2
    MAXVALUE 1000000;
    
SELECT MY_SEQ.CURRVAL FROM DUAL;
SELECT MY_SEQ.NEXTVAL FROM DUAL; -- 2만큼 증가

-- 시퀀스를 위한 딕셔너리
SELECT * FROM USER_SEQUENCES;
SELECT * FROM USER_OBJECTS
WHERE OBJECT_TYPE='SEQUENCE';

-- 시퀀스 삭제
DROP SEQUENCE MY_SEQ;
SELECT * FROM USER_SEQUENCES;

-- BOOK 테이블 PK의 현재 값 확인
SELECT * FROM BOOK;
SELECT MAX(BOOK_ID) FROM BOOK;

CREATE SEQUENCE SEQ_BOOK_ID_
    START WITH 3
    INCREMENT BY 1
    MAXVALUE 1000000
    NOCACHE;

SELECT * FROM USER_SEQUENCES;

DESC AUTHOR;

-- LIST
SELECT AUTHOR_ID, AUTHOR_NAME, AUTHOR_DESC FROM AUTHOR;





