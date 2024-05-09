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


