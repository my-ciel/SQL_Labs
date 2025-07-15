1. 다음은 웹 사이트의 게시판을 사용하는 회원을 관리하기 위한 회원 테이블 인스턴스입니다.. 회원 테이블 인스턴스를 참고하여 테이블을 생성하시오.
테이블명 : MEMBER

+-------------+------------------+------------------+----------------------+-----------+-----------+
| 열이름      | 데이터타입(길이) | 제약조건         | 제약조건이름         | 기본값    | 설명      |
+-------------+------------------+------------------+----------------------+-----------+-----------+
| MEMBER_ID   | NUMBER(6)        | Primary key      |                      |           | 회원번호  |
| MEMBER_NAME | VARCHAR2(20)     | Not Null         | member_mname_nn      |           | 회원이름  |
| PASSWD      | VARCHAR2(10)     | Not Null         | member_pw_nn         |           | 암호      |
| GENDER      | CHAR(3)          |                  |                      |           | 성별      |
| PHONE_NO    | VARCHAR2(13)     |                  |                      |           | 전화번호  |
| ADDRESS     | VARCHAR2(50)     |                  |                      |           | 주소      |
| JOIN_DATE   | DATE             |                  |                      | SYSDATE   | 가입일    |
| INTEREST    | VARCHAR2(15)     |                  |                      |           | 관심분야  |
+-------------+------------------+------------------+----------------------+-----------+-----------+

CREATE TABLE member
  (member_id NUMBER(6) PRIMARY KEY ,
     member_name VARCHAR2(10) CONSTRAINT member_mname_nn NOT NULL,
     passwd VARCHAR2(15) CONSTRAINT member_pw_nn NOT NULL,
gender CHAR(3), 
phone_no VARCHAR2(13),
     address VARCHAR2(50),
     join_date DATE DEFAULT SYSDATE,
     interest VARCHAR2(15));

2. 다음은 웹 사이트의 게시판을 사용하는 회원을 관리하기 위한 게시판 테이블 인스턴스입니다. 인스턴스를 참고하여 테이블을 생성하시오.

테이블명 : BOARD
+------------+------------------+----------------+-------------------+-----------+--------------------------+
| 열이름     | 데이터타입(길이) | 제약조건       | 제약조건이름       | 기본값    | 설명                    |
+------------+------------------+----------------+-------------------+-----------+--------------------------+
| NO         | NUMBER(4)        | Primary Key    |                   |           | 게시글번호               |
| SUBJECT    | VARCHAR2(200)    | Not Null       | Board_sub_nn      |           | 제목                     |
| CONTENT    | VARCHAR2(2000)   |                |                   |           | 내용                     |
| CRE_DATE   | TIMESTAMP(0)     |                |                   | SYSDATE   | 작성일                   |
| MEMBER_ID  | NUMBER(6)        | Foreign Key    | Board_mid_fk      |           | MEMBER(MEMBER_ID) 참조   |
+------------+------------------+----------------+-------------------+-----------+--------------------------+


CREATE TABLE board 
    (no NUMBER(4) PRIMARY KEY,
     subject VARCHAR2(200) CONSTRAINT board_sub_nn NOT NULL,
     content VARCHAR2(2000),
     cre_date TIMESTAMP(0),
member_id NUMBER(6) CONSTRAINT board_mid_fk REFERENCES member(member_id));

3. 게시판의 NO 열에 사용할 board_no_seq라는 이름의 시퀀스를 생성하시오. 시퀀스의 시작번호와 증분값은 각각 1로 설정하고 NOCACHE, NOCYCLE 속성을 주시오.
CREATE SEQUENCE board_no_seq
INCREMENT BY 1
START WITH 1
NOCACHE
NOCYCLE;

4. 회원 테이블과 게시판 테이블을 참조하여 무결성 제약조건을 위반하지 않는 데이터를 3건씩 입력하시오. 게시판의 번호는 board_no_seq 시퀀스를 사용하여 입력하시오.
  INSERT INTO member
VALUES ('101','송선주','ab2345',’여’, '051-123-1234','부산 수정동',sysdate,'DB');
INSERT INTO member
VALUES ('102','김영진','남','kk234kk','051-321-1234','창원 사림동',sysdate,'internet');
INSERT INTO member
VALUES ('103','전민준','abc123','남','051-345-3456','부산 동삼동',sysdate,'java');
INSERT INTO board
VALUES (board_no_seq.nextval,'배송문의','어제 주문했는데 언제 배송되나요?',SYSDATE,'101');
INSERT INTO board
VALUES (board_no_seq.nextval,'재입고문의','이 상품 재입고 언제 될까요?',SYSDATE,'102');
INSERT INTO board
VALUES (board_no_seq.nextval,'교환원합니다.','다른 색상의 상품으로 교환하고 싶습니다.',SYSDATE,'103');
COMMIT;
5. 회원 테이블에 email 열을 추가하시오. 단, email 열의 데이터 타입은 VARCHAR2(50)이고 UNQUE 제약조건을 함께 정의하시오.
ALTER TABLE member ADD email VARCHAR2(50) UNIQUE;

6. 회원 테이블에 국적을 나타내는 country 열을 추가하시오. 데이터타입은 VARCHAR2(20), 기본값은 'Korea'로 지정하시오. 
ALTER TABLE member ADD country VARCHAR2(20) DEFAULT 'Korea';
SELECT * FROM member;

7. 회원 테이블에서 INTEREST 열을 삭제하시오.
ALTER TABLE member DROP COLUMN interest;
DESC member

8. 회원 테이블의 address 열의 데이터 크기를 100으로 변경하시오.
DESC member;
ALTER TABLE member MODIFY address VARCHAR2(100);
DESC member

9. 게시판 테이블의 member_id 열에 대해 board_mid_ix 라는 이름의 인덱스를 생성하시오.
CREATE INDEX board_mid_ix ON board(member_id);

10. 회원테이블에서 회원아이디, 이름, 전화번호, 주소를 볼 수 있는 member_addr_phone_list_vu라는 이름의 뷰를 생성하시오.
CREATE OR REPLACE VIEW member_addr_phone_list_vu
AS
SELECT member_id, member_name, phone_no, address
FROM member;

11. 게시판글번호, 제목, 회원아이디를 볼 수 있는 board_list_vu라는 이름의 뷰를 생성하시오.
CREATE OR REPLACE VIEW board_list_vu 
AS 
SELECT no, subject, member_id 
FROM board;

12. member_addr_phone_list_vu와 board_list_vu라는 이름의 뷰에 대하여 각각 m과 b라는 이름의 동의어를 생성하시오.
CREATE SYNONYM m FOR member_addr_phone_list_vu;
CREATE SYNONYM b FOR board_list_vu;

13. board_list_vu 라는 뷰에서 작성일(CRE_DATE)가 보이도록 뷰를 수정하시오.
CREATE OR REPLACE VIEW board_list_vu
AS 
SELECT no, subject, user_id, cre_date
FROM board;

14. USER_CONSTRAINTS, USER_INDEXES 및 USER_OBJECTS를 조회하여 MEMBER 테이블 관련 제약조건과 사용자 소유의 객체의 이름, 타입, 상태 등을 조회하시오.
SELECT table_name, constraint_name, constraint_type, search_condition
FROM user_constraints
WHERE table_name = 'MEMBER';

SELECT table_name, index_name
FROM user_indexes
WHERE table_name = 'MEMBER';

SELECT object_name, object_type, status
FROM user_objects
WHERE object_name LIKE 'MEMBER%' OR object_name='M'
ORDER BY 2;

15. member테이블을 삭제하시오. 
DROP TABLE member CASCADE CONSTRAINTS;

16. USER_OBJECTS를 조회하여 사용자 소유의 객체의 이름, 타입, 상태 등을 조회하면서 테이블 삭제의 결과를 정리하시오.
SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'MEMBER';

SELECT table_name, index_name
FROM user_indexes
WHERE table_name = 'MEMBER';

SELECT object_name, object_type, status
FROM user_objects
WHERE object_name LIKE 'MEMBER%' OR object_name='M'
ORDER BY 2;

