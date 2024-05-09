-- MySQL은 사용자와 Database를 구분하는 DBMS
SHOW DATABASES;

-- 데이터베이스 사용 선언
USE SAKILA;

-- 데이터베이스 내에 어떤 테이블이 있는가?
SHOW TABLES;

-- 테이블 구조 확인
DESCRIBE ACTOR;

-- 간단한 쿼리 실행
SELECT VERSION(), CURRENT_DATE;
SELECT VERSION(), CURRENT_DATE FROM DUAL; 

-- 특정 테이블 데이터 조회
SELECT * FROM ACTOR;

-- 데이터베이스 생성
-- webdb 데이터베이스 생성
CREATE DATABASE webdb;
-- 시스템 설정에 좌우되는 경우 많음
DROP DATABASE webdb;
-- 문자셋, 정렬 방식을 명시적으로 지정하는 것이 좋다.
CREATE DATABASE WEBDB CHARSET UTF8MB4
	COLLATE utf8mb4_unicode_ci;
SHOW DATABASES;

-- 사용자 만들기
CREATE USER 'dev' @'localhost' IDENTIFIED BY 'dev';
-- 사용자 비밀번호 변경
-- ALTER USER 'dev'@'localhost' IDENTIFIED BY 'new_password';

-- 사용자 삭제alter
-- DROP USER 'dev'@'localhost';

-- 권한 부여
-- GRANT 권한목록 ON 객체 TO '계정'@'접속호스트';
-- 권한 회수
-- REVOKE 권한목록 ON 객체 FROM '계정'@'접속호스트';

-- 'dev'@'localhost'에게 webdb 데이터베이스의 모든 객체에 대한 모든 권한 허용
GRANT ALL privileges ON WEBDB.* TO 'div'@'localhost';
-- ALL privileges = select, insert, delete ,update
-- 모든 권한 해제
-- REVOKE ALL PRILVILEGES ON WEBDB.* FROM 'div'@'localhost';

USE WEBDB;

create table author(
	author_id int primary key,
    AUTHOR_NAME VARCHAR(50) NOT NULL,
    AUTHOR_DESC VARCHAR(500)
);
SELECT * FROM AUTHOR;
SHOW TABLES;
DESC AUTHOR;

-- 테이블 생성 정보
-- 어떻게 테이블을 만들었는지
SHOW CREATE TABLE AUTHOR;

-- book 테이블 생성
CREATE TABLE BOOK (
	book_id int primary key,
    title varchar(100) NOT NULL,
    pubs varchar(100),
    pub_date datetime,
    author_id int,
    CONSTRAINT book_fk FOREIGN KEY (author_id)
    REFERENCES author (author_id)
);
SELECT * FROM BOOK;
SHOW TABLES;
DESC BOOK;	

-- INSERT : 새로운 레코드 삽입
-- 묵시적 방법 : 컬럼 목록 제공하지 않는다 -> 선언된 컬럼의 순서대로
INSERT INTO AUTHOR VALUES (1, '박경리','토지 작가');
-- 명시적 방법 : 컬럼 목록 제공, 컬럼 목록의 숫자, 순서, 타입이
-- => 값 목록의 숫자, 순서, 타입과 일치해야 함
INSERT INTO AUTHOR (AUTHOR_ID, AUTHOR_NAME)
VALUES (2,'김영하');

SELECT * FROM AUTHOR;

-- MySQL은 기본적으로 자동 커밋이 활성화.
-- autocommit 비활성화 => autocommit 옵션을 0으로 설정.
SET AUTOCOMMIT = 0;

-- MySQL은 명시적 트랜잭션을 수행
START TRANSACTION;
SELECT * FROM AUTHOR;

UPDATE AUTHOR SET AUTHOR_DESC = '알쓸신잡 출연'; -- WHERE절이 없으면 전체 레코드 변경
-- MySQL에서 막아놓은 것을 볼 수 있다.

UPDATE AUTHOR SET AUTHOR_DESC = '알쓸신잡 출연'
WHERE AUTHOR_ID = 2;
SELECT * FROM AUTHOR;

COMMIT;

-- AUTO_INCREMENT
-- 연속된 순차정보, 주로 PK속성에 사용

-- AUTHOR 테이블의 PK에 AUTO_INCREMENT 속성 부여
ALTER TABLE AUTHOR MODIFY AUTHOR_ID INT AUTO_INCREMENT PRIMARY KEY;

-- 1. 외래 키 정보 확인
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE;

SELECT constraint_name FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME='BOOK';
-- 2. 외래 키 삭제 : book 테이블의 FK (fk_book)
ALTER TABLE book DROP FOREIGN KEY fk_book;

-- 3. author의 PK에 AUTO_INCREMENT 속성 부여

-- 4. BOOK의 AUTHOR_ID에 FOREIGN KEY 다시 연결 



