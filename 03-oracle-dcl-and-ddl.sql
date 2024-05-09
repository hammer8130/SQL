--------------------------------------------------------------
-- DCL and DDL
--------------------------------------------------------------
-- 사용자 생성
-- CREATE USER 권한이 있어야 한다.
-- system 계정으로 수행
connect system/manager;
show user;
-- himedia라는 이름의 계정을 만들고 비밀번호 himedia로 설정
-- CREATE USER himedia IDENTIFIED BY himedia;
-- ㄴOracle 18버전부터 Container Database 개념이 도입되어서 실행이 안됨
-- 방법 1. 사용자 계정 C##
CREATE USER C##himedia IDENTIFIED BY himedia;

-- 비밀번호 변경 : ALTER USER
ALTER USER C##himedia IDENTIFIED BY new_password;

-- 계정 삭제 : DROP USER
DROP USER C##himedia CASCADE; -- CASCADE : 폭포수 or 연결된 것을 의미함

-- 연습이니까 하는 것, 원래는 X
-- 계정 생성 방법 2. CD 기능 무력화
-- 연습상태, 방법 2를 사용자 생성 (추천하지 않음)
ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER himedia IDENTIFIED BY himedia;

-- GRANT 시스템권한목록 TO 사용자|역할|PUBLIC [WITH ADMIN OPTION] -> 시스템 권한 부여
-- REVOKE 회수할권한 FROM 사용자|역할|PUBLIC

-- GRANT 객체개별권한|ALL ON 객체명 TO 사용자|역할|PUBLIC [WITH ADMIN OPTION]
-- REVOKE 회수할권한 ON 객체명 FROM 사용자|역할|PUBLIC

-- 아직 접속 불가능하다
-- 데이터베이스 접속, 테이블 생성 데이터베이스 객체 작업을 수행 -> COMMIT, RESOURCE ROLE
GRANT CONNECT, RESOURCE TO himedia;
-- cmd : sqlplus himedia/himedia
CREATE TABLE test(a NUMBER);
-- DESC test;   -- 테이블 test의 구조 보기

-- himedia 사용자로 진행
-- 데이터 추가
DESCRIBE test;
INSERT INTO test VALUES (2024); 
-- USERS (테이블 스페이스에 대한 권한이 없다)
-- 18 버전이상. 오라클에 접근 권한 얻어와야 한다.
-- SYSTEM 계정으로 수정
ALTER USER himedia DEFAULT TABLESPACE USERS
    QUOTA unlimited on USERS;
-- 다시 사용자 계정으로
INSERT INTO test VALUES(2024);
SELECT * FROM test;

SELECT * FROM USER_USERS;  -- 현재 로그인한 사용자 정보
SELECT * FROM ALL_USERS;   -- 모든 사용자 정보

-- DBA 전용 (sysdba로 로그인 해야 확인 가능)
-- sqlplus sys/oracle as sysdba => sysdba로 접속 가능
SELECT * FROM DBA_USERS;

-- HR 스키마의 employee 테이블 조회 권한을 himedia에게 부여하고자 한다.
-- HR 스키마의 owner = HR => HR로 접속
GRANT SELECT ON employees TO HIMEDIA;

-- himedia 권한
-- 그대로 조회하게 된다면 himedia의 employees를 조회하므로 오류.
SELECT * FROM hr.EMPLOYEES; -- hr.EMPLOYEES만 select 할 수 있는 권한.
SELECT * FROM hr.DEPARTMENTS;  -- 오류

-- 현재 사용자에게 부여된 ROLE의 확인
SELECT * FROM USER_ROLE_PRIVS;

-- connect와 resource 역할은 어떤 권한으로 구성되어 있는가?
-- sysdba로 진행
-- cmd
-- sqlplus sys/oracle as sysdba -- 전체 데이터 계정인 sysdba 계정으로 접속
-- DESC role_sys_privs;

-- CONNECT role에는 어떤 권한이 포함되어 있는가?
-- SELECT PRIVILEGE FROM role_sys_privs WHERE role = 'CONNECT';
-- ==> SET CONTAINER , CREATE SESSION 권한
-- RESOURCE role에는 어떤 권한이 포함되어 있는가?
-- SELECT PRIVILEGE FROM ROLE_SYS_PRIVS WHERE ROLE='RESOURCE';

----------------
-- DDL
----------------

-- 스키마 내의 모든 테이블을 확인
SELECT * FROM TABS; -- tabs:  테이블 정보 dictionary
-- 테이블 생성
CREATE TABLE BOOK (
    book_id NUMBER(5),
    title VARCHAR2(50),
    author VARCHAR2(10),
    pub_date DATE DEFAULT SYSDATE
);
DESC BOOK;

-- Subquery를 이용한 테이블 생성
SELECT * FROM hr.EMPLOYEES;

-- hr.EMPLOYEES 테이블에서 JOB_ID가 IT관련된 직원들의 목록을 대상으로 새 테이블 생성
SELECT * FROM hr.EMPLOYEES
WHERE JOB_ID LIKE 'IT%';

CREATE TABLE EMP_IT AS (
    SELECT * FROM hr.EMPLOYEES
    WHERE JOB_ID LIKE 'IT%'
);
-- Subquery를 이용해서 생성한 table은 NOT NULL조건인 것만 물려받는다.

DESC EMP_IT;

DROP TABLE EMP_IT;

DESC BOOK;

-- Author 테이블 생성
CREATE TABLE AUTHOR (
    author_id NUMBER(10),
    author_name VARCHAR2(100) NOT NULL, 
    author_desc VARCHAR2(500),
    PRIMARY KEY (author_id)
);
DESC AUTHOR;




-- BOOK 테이블의 AUTHOR 컬럼 삭제
-- 나중에 AUTHOR_ID 컬럼 추가 -> AUTHOR,AUTHOR_ID와 참조 연결할 예정
DESC BOOK;
ALTER TABLE BOOK DROP COLUMN author;
DESC BOOK;

-- BOOK 테이블에 AUTHOR_ID 컬럼 추가
-- AUTHOR, AUTHOR_ID를 참조하는 컬럼
ALTER TABLE BOOK ADD (author_id NUMBER(10));
DESC BOOK;
DESC AUTHOR;

-- BOOK 테이블의 BOOK_ID도 AUTHOR 테이블의 PK와 같은 데이터 타입으로 변경
ALTER TABLE BOOK MODIFY (BOOK_ID NUMBER(10));
-- BOOK 테이블의 BOOK_ID 컬럼에 PK 제약조건 부여
ALTER TABLE BOOK ADD CONSTRAINT pk_book_id PRIMARY KEY (book_id);
DESC BOOK;

-- book 테이블에 author_id 컬럼 (PK) 을 author 테이블의 author_id로 fk 연결
ALTER TABLE BOOK ADD CONSTRAINT FK_AUTHOR_ID 
    FOREIGN KEY (AUTHOR_ID)
    REFERENCES AUTHOR(AUTHOR_ID); -- FK를 참조하고자 하는 테이블
DESC BOOK;

-- DICTIONARY
-- USER_ : 현재 로그인된 사용자에게 허용된 뷰
-- ALL_ : 모든 사용자 뷰
-- DBA_ : DBA 허용된 뷰

-- 모든 딕셔너리 확인
SELECT * FROM DICTIONARY;

-- 사용자 스키마 객체 : USER_OBJECT
SELECT * FROM USER_OBJECTS;
-- 사용자 스키마의 이름과 타입 정보 출력
SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS;

-- 제약 조건의 확인
SELECT * FROM USER_CONSTRAINTS;
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE,SEARCH_CONDITION, TABLE_NAME
FROM USER_CONSTRAINTS;

-- BOOK 테이블에 적용된 제약조건의 확인
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'BOOK';

-- INSERT : 테이블에 새 레코드(튜플) 추가
-- 제공된 컬럼 목록의 순서와 타입, 값목록의 순서와 타입이 일치해야 함.
-- 컬럼 목록을 제공하지 않으면, 테이블 생성시 정의된 컬럼의 순서의 타입을 따른다.

-- 컬럼 목록이 제시되지 않았을 때
INSERT INTO author VALUES (1,'박경리','토지 작가');

-- 컬럼 목록을 제시했을 때,
--  제시한 컬럼의 순서와 타입대로 값 목록을 제공해야 한다.
INSERT INTO author (author_id, author_name) VALUES(2,'김영하');

-- 컬럼 목록을 제시했을 때,
-- 테이블 생성시 정의된 컬럼의 순서와 상관없이 데이터 제공 가능
INSERT INTO AUTHOR (AUTHOR_NAME,AUTHOR_ID,AUTHOR_DESC)
VALUES ('정우찬',3,'본인');

ROLLBACK; -- 트랜잭션 취소 ( 반영 취소 )

INSERT INTO author VALUES (1,'박경리','토지 작가');
INSERT INTO AUTHOR (AUTHOR_ID, AUTHOR_NAME) VALUES(2,'김영하');
INSERT INTO AUTHOR (AUTHOR_NAME,AUTHOR_ID,AUTHOR_DESC)
VALUES ('정우찬',3,'본인');

COMMIT; -- 변경사항 반영


-- UPDATE
-- 특정 레코드의 컬럼 값을 변경한다.
-- WHERE 절이 없으면 모든 레코드가 변경, 가급적 WHERE절로 변경하고자 하는 레코드를 지정 요망.
UPDATE AUTHOR SET AUTHOR_DESC = '알쓸신잡 출연';
SELECT * FROM AUTHOR; -- 모든 행 다 바뀐다.
ROLLBACK;

UPDATE AUTHOR SET AUTHOR_DESC = '알쓸신잡 출연'
WHERE AUTHOR_ID = '2';
SELECT * FROM AUTHOR;

-- DELETE
-- 테이블로부터 특정 레코드를 삭제
-- WHERE 절이 없으면 모든 레코드 삭제 (주의)

-- 연습
-- hr.employees 테이블을 기반으로 department_id 10,20,30인 직원들만 새테이블 emp123으로 생성
CREATE TABLE emp123 AS
    (SELECT * FROM HR.EMPLOYEES
    WHERE DEPARTMENT_ID IN (10,20,30)
    );
DESC EMP123;

SELECT FIRST_NAME,SALARY,DEPARTMENT_ID FROM EMP123;

-- 부서가 30인 직원들의 급여를 10% 인상
UPDATE EMP123 SET SALARY = SALARY+SALARY * 0.1
WHERE DEPARTMENT_ID = 30;

SELECT FIRST_NAME, SALARY, DEPARTMENT_ID FROM EMP123
WHERE DEPARTMENT_ID = 30;

-- JOB_ID MK_로 시작하는 직원들 삭제
DELETE FROM EMP123
WHERE JOB_ID LIKE 'MK_%';

SELECT FIRST_NAME, SALARY,DEPARTMENT_ID FROM EMP123;

DELETE FROM EMP123;
SELECT * FROM EMP123;

ROLLBACK;

------------
-- TRANSACTION
------------

-- 트랜젝션 테스트 테이블
CREATE TABLE t_test(
    log_test VARCHAR2(100)
);

-- 첫 번째 DML이 수행된 시점에서 Transaction
INSERT INTO t_test VALUES('트랜젝션 시작');
SELECT * FROM t_test;
INSERT INTO T_TEST VALUES('데이터 INSERT');
SELECT * FROM T_TEST;

SAVEPOINT spl;

INSERT INTO T_TEST VALUES('데이터2 INSERT');
SELECT * FROM T_TEST;

SAVEPOINT sp2;
UPDATE T_TEST SET LOG_TEST = '업데이트';

SELECT * FROM T_TEST;

ROLLBACK TO sp2;
SELECT *FROM T_TEST;

INSERT INTO T_TEST VALUES('데이터3 INSERT');
SELECT * FROM T_TEST;

-- 반영: COMMIT or 취소: ROLLBACK
-- 명시적으로 Transaction 종료
COMMIT;
ROLLBACK;
SELECT * FROM T_TEST;


CREATE OR REPLACE VIEW emp_80
AS SELECT employee_id, first_name, last_name, manager_id, salary
FROM employees
WHERE department_id = 80
WITH READ ONLY;

SELECT * FROM EMP_80;






