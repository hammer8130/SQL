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




