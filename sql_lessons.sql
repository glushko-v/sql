CREATE TABLE SUPPLIERS (
ID NUMBER,
CONSTRAINT SUPPLIER_ID PRIMARY KEY (ID),
COMPANY_NAME NVARCHAR2(50),
CONTACT_NAME NVARCHAR2(50),
CONTACT_TITLE NVARCHAR2(50),
ADRESS NVARCHAR2(50),
CITY NVARCHAR2(50),
REGION NVARCHAR2(50),
POSTAL_CODE NUMBER,
COUNTRY NVARCHAR2(50),
PHONE NUMBER(13),
FAX NUMBER(13),
HOMEPAGE NVARCHAR2(50)
);

CREATE TABLE CATEGORIES(
ID NUMBER,
CONSTRAINT CATEGORY_ID PRIMARY KEY (ID),
DESCRIPTION NVARCHAR2(140),
PICTURE BFILE 
);

CREATE TABLE PRODUCTS (
ID NUMBER,
CONSTRAINT PRODUCT_ID PRIMARY KEY (ID),
PRODUCT_NAME NVARCHAR2(50),
SUPPLIER_ID NUMBER,
CONSTRAINT SUPPLIERS_FK FOREIGN KEY (SUPPLIER_ID) REFERENCES SUPPLIERS(ID),
CATEGORY_ID NUMBER,
CONSTRAINT CATEGORIES_FK FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORIES(ID),
QUANTITY_PER_UNIT NUMBER,
UNIT_PRICE NUMBER,
UNITS_IN_STOCK NUMBER,
UNITS_ON_ORDER NUMBER,
REORDER_LEVEL NUMBER,
DISCONTINUED TIMESTAMP
);

CREATE TABLE CUSTOMERS(
ID NUMBER,
CONSTRAINT CUSTOMER_ID PRIMARY KEY (ID),
COMPANY_NAME NVARCHAR2(50),
CONTACT_NAME NVARCHAR2(50),
CONTACT_TITLE NVARCHAR2(50),
ADDRESS NVARCHAR2(50),
CITY NVARCHAR2(50),
REGION NVARCHAR2(50),
POSTAL_CODE NUMBER,
COUNTRY NVARCHAR2(50),
PHONE NUMBER(13),
FAX NUMBER(13)
);

CREATE TABLE SHIPPERS(
ID NUMBER,
CONSTRAINT SHIPPER_ID PRIMARY KEY (ID),
COMPANY_NAME NVARCHAR2(50),
PHONE NUMBER(13)
);

CREATE TABLE EMPLOYEES (
ID NUMBER,
CONSTRAINT EMPLOYEE_ID PRIMARY KEY (ID),
LAST_NAME NVARCHAR2(50),
FIRST_NAME NVARCHAR2(50),
TITLE NVARCHAR2(50),
TITLE_OF_COURTESY NVARCHAR2(50),
BIRTH_DATE TIMESTAMP,
HIRE_DATE TIMESTAMP,
ADDRESS NVARCHAR2(50),
CITY NVARCHAR2(50),
REGION NVARCHAR2(50),
POSTAL_CODE NUMBER,
COUNTRY NVARCHAR2(50),
HOME_PHONE NUMBER(13),
EXTENSION NUMBER(5),
PHOTO BFILE,
NOTES CLOB,
REPORTS_TO NVARCHAR2(50)
);

CREATE TABLE ORDERS (
ID NUMBER,
CONSTRAINT ORDER_ID PRIMARY KEY(ID),
CUSTOMER_ID NUMBER,
EMPLOYEE_ID NUMBER,
CONSTRAINT CUSTOMERS_FK FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(ID),
CONSTRAINT EMPLOYEES_FK FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(ID),
ORDER_DATE TIMESTAMP,
REQUIRED_DATE TIMESTAMP,
SHIPPED_DATE TIMESTAMP,
SHIP_VIA nvarchar2(50),
FREIGHT NUMBER,
SHIP_NAME NVARCHAR2(50),
SHIP_ADDRESS NVARCHAR2(50),
SHIP_CITY NVARCHAR2(50),
SHIP_REGION NVARCHAR2(50),
SHIP_POSTAL_CODE NUMBER,
SHIP_COUNTRY NVARCHAR2(50)
);

CREATE TABLE ORDER_DETAILS(
ORDER_ID NUMBER,
PRODUCT_ID NUMBER,
UNIT_PRICE NUMBER,
QUANTITY NUMBER,
DISCOUNT NUMBER,
CONSTRAINT ORDERS_FK FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ID),
CONSTRAINT PRODUCTS_FK FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(ID)
);

create table users(
id int,
constraint users_pk primary key(id),
nick varchar2(16),
password varchar2(128),
email varchar2(128),
userDate timestamp,
karma float,
ip varchar2(20)
);

create table forumCategories (
id int,
constraint forumCategories_pk primary key(id),
title varchar2(64),
description clob,
categoryDate timestamp,
ip varchar2(20)
);

create table forumSubcategories(
id int,
constraint forumSubcategories_pk primary key(id),
idCategory int,
constraint forumCategories_fk foreign key(idCategory) references forumCategories(id),
title varchar2(45),
description clob,
subcategoryDate timestamp,
ip varchar2(20)
);


create table forumPosts (
id int,
constraint forumPosts_pk primary key(id),
idSubcategory int,
constraint subcategories_fk foreign key (idSubcategory) references forumSubcategories(id),
idUser int,
constraint users_fk foreign key (idUser) references users(id),
parentPost int,
title varchar2(90),
content clob,
isPoll char(1) default ('n') check (isPoll = 'y' or isPoll = 'n'),
postDate timestamp,
ip varchar2(20)
);

create table forumPollsOptions(
id int,
constraint forumPolls_pk primary key(id),
idPost int,
constraint forumPosts_fk foreign key(idPost) references forumPosts(id),
title varchar2(64),
pollDate timestamp
);

create table forumPollsOptionsVotes(
id int,
constraint forumPollsOptionsVotes_pk primary key (id),
idPollOption int,
constraint forumPollsOptions_fk foreign key (idPollOption) references forumPollsOptions(id),
idUser int,
constraint users_fk1 foreign key (idUser) references users(id),
pollsOptionsDate timestamp,
ip varchar2(20)
);

CREATE TABLE SALESMAN (
ID NUMBER PRIMARY KEY,
NAME NVARCHAR2(50) NOT NULL,
CITY NVARCHAR2(50) NOT NULL,
COMMISSION NUMBER(*,2) DEFAULT '0,1'
);

CREATE TABLE CUSTOMER (
CUSTOMER_ID NUMBER PRIMARY KEY,
CUSTNAME NVARCHAR2(50) NOT NULL,
CITY NVARCHAR2(50) NOT NULL,
SALESMAN_ID NUMBER,
CONSTRAINT SALESMAN_FK FOREIGN KEY (SALESMAN_ID) REFERENCES SALESMAN(ID)
);

SELECT SALESMAN.NAME, CUSTOMER.CUSTNAME
FROM SALESMAN
JOIN CUSTOMER ON SALESMAN.ID = CUSTOMER.SALESMAN_ID;


SELECT SALESMAN.NAME, CUSTOMER.CUSTNAME, SALESMAN.CITY
FROM SALESMAN
JOIN CUSTOMER ON SALESMAN.CITY = CUSTOMER.CITY;

CREATE TABLE DEAL (
CUSTOMER_ID NUMBER,
CONSTRAINT CUSTOMER_FK FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID),
AMOUNT NUMBER NOT NULL,
DEAL_DATE TIMESTAMP
);

select salesman.name, customer.custname
from salesman
join customer on salesman.id = customer.salesman_id;

select salesman.name, salesman.city, customer.custname, customer.city
from salesman
join customer on salesman.city = customer.city;

select salesman.name, salesman.city, customer.custname, customer.city from salesman, customer
where (salesman.id = customer.salesman_id and salesman.city = customer.city);
 
select customer.custname, deal.amount, salesman.name
from customer
join salesman on salesman.id = customer.salesman_id
join deal on deal.customer_id = customer.customer_id where deal.amount > 10000;

select customer.custname, extract (year from deal_date) 
from customer
join deal on deal.customer_id = customer.customer_id 
where deal.deal_date > to_date('2016-12-31 23:59:59', 'yyyy-mm-dd HH24:MI:SS') and 
deal.deal_date < to_date ('2019-01-01 00:00:00', 'yyyy-mm-dd HH24:MI:SS');

select salesman.name as, sum(deal.amount) as "TOTAL AMOUNT" 
from salesman
join customer on customer.salesman_id = salesman.id
join deal on deal.customer_id = customer.customer_id 
where deal.deal_date > to_date('2017-08-01 00:00:00', 'yyyy-mm-dd HH24:MI:SS') and
deal.deal_date < to_date('2017-08-31 23:59:59', 'yyyy-mm-dd HH24:MI:SS') 
group by salesman.name
order by sum(deal.amount) desc;


create view best_sales as
select salesman.name "name", sum(deal.amount) as "amount" 
from salesman
join customer on customer.salesman_id = salesman.id
join deal on deal.customer_id = customer.customer_id 
where deal.deal_date > to_date('2017-08-01 00:00:00', 'yyyy-mm-dd HH24:MI:SS') and
deal.deal_date < to_date('2017-08-31 23:59:59', 'yyyy-mm-dd HH24:MI:SS') 
group by salesman.name;

select max("amount") from best_sales;











































