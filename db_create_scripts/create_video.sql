create table TITLE
(
    TITLE_ID     NUMBER(10)    not null
        constraint TITLE_ID_PK
            primary key,
    TITLE        VARCHAR2(60)  not null
        constraint TITLE_NN
            check ("TITLE" IS NOT NULL),
    DESCRIPTION  VARCHAR2(400) not null
        constraint TITLE_DESC_NN
            check ("DESCRIPTION" IS NOT NULL),
    RATING       VARCHAR2(4)
        constraint TITLE_RATING_CK
            check (rating IN ('G', 'PG', 'R', 'NC17', 'NR')),
    CATEGORY     VARCHAR2(20) default 'DRAMA'
        constraint TITLE_CATEG_CK
            check (category IN ('DRAMA', 'COMEDY', 'ACTION', 'CHILD', 'SCIFI', 'DOCUMENTARY')),
    RELEASE_DATE DATE
)
/

INSERT INTO TITLE (TITLE_ID, TITLE, DESCRIPTION, RATING, CATEGORY, RELEASE_DATE) VALUES (92, 'Willie and Christmas Too', 'All of Willie''s friends made a Christmas list for Santa, but Willie has yet
   to create his own wish list.', 'G', 'CHILD', DATE '1995-10-05');
INSERT INTO TITLE (TITLE_ID, TITLE, DESCRIPTION, RATING, CATEGORY, RELEASE_DATE) VALUES (93, 'Alien Again', 'Another installment of science fiction
  history. Can the heroine save the planet from the alien life
  form?', 'R', 'SCIFI', DATE '1995-05-19');
INSERT INTO TITLE (TITLE_ID, TITLE, DESCRIPTION, RATING, CATEGORY, RELEASE_DATE) VALUES (94, 'The Glob', 'A meteor crashes near a small American town and unleashes carnivorous goo
   in this classic.', 'NR', 'SCIFI', DATE '1995-08-12');
INSERT INTO TITLE (TITLE_ID, TITLE, DESCRIPTION, RATING, CATEGORY, RELEASE_DATE) VALUES (95, 'My Day Off', 'With a little luck and a lot
   of ingenuity, a teenager skips school for a day in NewYork.', 'PG', 'COMEDY', DATE '1995-07-12');
INSERT INTO TITLE (TITLE_ID, TITLE, DESCRIPTION, RATING, CATEGORY, RELEASE_DATE) VALUES (96, 'Miracles on Ice', 'A six-year-old has doubts about Santa Claus. But she discovers
    that miracles really do exist.', 'PG', 'DRAMA', DATE '1995-09-12');
INSERT INTO TITLE (TITLE_ID, TITLE, DESCRIPTION, RATING, CATEGORY, RELEASE_DATE) VALUES (97, 'Soda Gang', 'After discovering a cached of
   drugs, a young couple find themselves pitted against a vicious
   gang.', 'NR', 'ACTION', DATE '1995-06-01');
INSERT INTO TITLE (TITLE_ID, TITLE, DESCRIPTION, RATING, CATEGORY, RELEASE_DATE) VALUES (98, 'Interstellar Wars', 'Futuristic
	interstellar action movie.  Can the rebels save the humans from
	the evil Empire?', 'PG', 'SCIFI', DATE '1977-07-07');
create table TITLE_COPY
(
    COPY_ID  NUMBER(10)   not null,
    TITLE_ID NUMBER(10)   not null
        constraint COPY_TITLE_ID_FK
            references TITLE,
    STATUS   VARCHAR2(15) not null
        constraint COPY_STATUS_CK
            check (status IN ('AVAILABLE', 'DESTROYED', 'RENTED', 'RESERVED'))
        constraint COPY_STATUS_NN
            check ("STATUS" IS NOT NULL),
    constraint COPY_TITLE_ID_PK
        primary key (COPY_ID, TITLE_ID)
)
/

INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (1, 92, 'RENTED');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (2, 92, 'AVAILABLE');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (1, 93, 'AVAILABLE');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (2, 93, 'AVAILABLE');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (1, 94, 'AVAILABLE');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (1, 95, 'AVAILABLE');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (2, 95, 'RENTED');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (3, 95, 'RENTED');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (1, 96, 'AVAILABLE');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (1, 97, 'AVAILABLE');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (1, 98, 'RENTED');
INSERT INTO TITLE_COPY (COPY_ID, TITLE_ID, STATUS) VALUES (2, 98, 'RENTED');
create table MEMBER
(
    MEMBER_ID  NUMBER(10)           not null
        constraint MEMBER_ID_PK
            primary key,
    LAST_NAME  VARCHAR2(25)         not null
        constraint MEMBER_LAST_NN
            check ("LAST_NAME" IS NOT NULL),
    FIRST_NAME VARCHAR2(25),
    ADDRESS    VARCHAR2(100),
    CITY       VARCHAR2(30),
    PHONE      VARCHAR2(25),
    JOIN_DATE  DATE default SYSDATE not null
        constraint JOIN_DATE_NN
            check ("JOIN_DATE" IS NOT NULL)
)
/

INSERT INTO MEMBER (MEMBER_ID, LAST_NAME, FIRST_NAME, ADDRESS, CITY, PHONE, JOIN_DATE) VALUES (101, 'Velasquez', 'Carmen', '283 King Street', 'Seattle', '587-99-6666', DATE '1990-03-03');
INSERT INTO MEMBER (MEMBER_ID, LAST_NAME, FIRST_NAME, ADDRESS, CITY, PHONE, JOIN_DATE) VALUES (102, 'Ngao', 'LaDoris', '5 Modrany', 'Bratislava', '586-355-8882', DATE '1990-03-08');
INSERT INTO MEMBER (MEMBER_ID, LAST_NAME, FIRST_NAME, ADDRESS, CITY, PHONE, JOIN_DATE) VALUES (103, 'Nagayama', 'Midori', '68 Via Centrale', 'Sao Paolo', '254-852-5764', DATE '1991-06-17');
INSERT INTO MEMBER (MEMBER_ID, LAST_NAME, FIRST_NAME, ADDRESS, CITY, PHONE, JOIN_DATE) VALUES (104, 'Quick-To-See', 'Mark', '6921 King Way', 'Lagos', '63-559-777', DATE '1990-04-07');
INSERT INTO MEMBER (MEMBER_ID, LAST_NAME, FIRST_NAME, ADDRESS, CITY, PHONE, JOIN_DATE) VALUES (105, 'Ropeburn', 'Audry', '86 Chu Street', 'Hong Kong', '41-559-87', DATE '1990-03-04');
INSERT INTO MEMBER (MEMBER_ID, LAST_NAME, FIRST_NAME, ADDRESS, CITY, PHONE, JOIN_DATE) VALUES (106, 'Urguhart', 'Molly', '3035 Laurier Blvd.', 'Quebec', '418-542-9988', DATE '1991-01-18');
INSERT INTO MEMBER (MEMBER_ID, LAST_NAME, FIRST_NAME, ADDRESS, CITY, PHONE, JOIN_DATE) VALUES (107, 'Menchu', 'Roberta', 'Boulevard de Waterloo 41', 'Brussels', '322-504-2228', DATE '1990-05-14');
INSERT INTO MEMBER (MEMBER_ID, LAST_NAME, FIRST_NAME, ADDRESS, CITY, PHONE, JOIN_DATE) VALUES (108, 'Biri', 'Ben', '398 High St.', 'Columbus', '614-455-9863', DATE '1990-04-07');
INSERT INTO MEMBER (MEMBER_ID, LAST_NAME, FIRST_NAME, ADDRESS, CITY, PHONE, JOIN_DATE) VALUES (109, 'Catchpole', 'Antoinette', '88 Alfred St.', 'Brisbane', '616-399-1411', DATE '1992-02-09');
create table RENTAL
(
    BOOK_DATE    DATE default SYSDATE not null,
    COPY_ID      NUMBER(10)           not null,
    MEMBER_ID    NUMBER(10)           not null
        constraint RENTAL_MBR_ID_FK
            references MEMBER,
    TITLE_ID     NUMBER(10)           not null,
    ACT_RET_DATE DATE,
    EXP_RET_DATE DATE default SYSDATE + 2,
    constraint RENTAL_ID_PK
        primary key (BOOK_DATE, COPY_ID, TITLE_ID, MEMBER_ID),
    constraint RENTAL_COPY_TITLE_ID_FK
        foreign key (COPY_ID, TITLE_ID) references TITLE_COPY
)
/

INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-05 10:47:53', 2, 101, 93, null, TIMESTAMP '2023-10-07 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-04 10:47:53', 3, 102, 95, null, TIMESTAMP '2023-10-06 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-03 10:47:53', 1, 101, 98, null, TIMESTAMP '2023-10-05 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-02 10:47:53', 1, 106, 97, TIMESTAMP '2023-10-04 10:47:53', TIMESTAMP '2023-10-04 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-03 10:47:53', 1, 101, 92, TIMESTAMP '2023-10-04 10:47:53', TIMESTAMP '2023-10-05 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-04 10:47:53', 2, 102, 93, TIMESTAMP '2023-10-05 10:47:53', TIMESTAMP '2023-10-05 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-02 10:47:53', 2, 106, 93, TIMESTAMP '2023-10-04 10:47:53', TIMESTAMP '2023-10-04 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-03 10:47:53', 3, 101, 95, TIMESTAMP '2023-10-04 10:47:53', TIMESTAMP '2023-10-06 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-01 10:47:53', 1, 104, 98, TIMESTAMP '2023-10-03 10:47:53', TIMESTAMP '2023-10-03 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-09-30 10:47:53', 2, 102, 92, TIMESTAMP '2023-10-02 10:47:53', TIMESTAMP '2023-10-02 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-04 10:47:53', 1, 101, 93, null, TIMESTAMP '2023-10-05 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-02 10:47:53', 1, 104, 93, TIMESTAMP '2023-10-04 10:47:53', TIMESTAMP '2023-10-04 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-03 10:47:53', 2, 103, 95, null, TIMESTAMP '2023-10-06 10:47:53');
INSERT INTO RENTAL (BOOK_DATE, COPY_ID, MEMBER_ID, TITLE_ID, ACT_RET_DATE, EXP_RET_DATE) VALUES (TIMESTAMP '2023-10-01 10:47:53', 2, 102, 98, null, TIMESTAMP '2023-10-05 10:47:53');
create table RESERVATION
(
    RES_DATE  DATE       not null,
    MEMBER_ID NUMBER(10) not null
        constraint RESERVATION_MBR_ID_FK
            references MEMBER,
    TITLE_ID  NUMBER(10) not null
        constraint RESERVATION_TITLE_ID_FK
            references TITLE,
    constraint RES_ID_PK
        primary key (RES_DATE, MEMBER_ID, TITLE_ID)
)
/

INSERT INTO RESERVATION (RES_DATE, MEMBER_ID, TITLE_ID) VALUES (TIMESTAMP '2023-10-04 10:47:53', 106, 98);
INSERT INTO RESERVATION (RES_DATE, MEMBER_ID, TITLE_ID) VALUES (TIMESTAMP '2023-10-05 10:47:53', 101, 93);
