--Câu 1:
CREATE DATABASE SalesManagement
GO

USE SalesManagement
GO

--Câu 2:
if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BILL') and o.name = 'FK_BILL_ODER_CUSTOMER')
alter table BILL
   drop constraint FK_BILL_ODER_CUSTOMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BILL_DETAILS') and o.name = 'FK_BILL_DET_PAY_CUSTOMER')
alter table BILL_DETAILS
   drop constraint FK_BILL_DET_PAY_CUSTOMER
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('COMMODITY') and o.name = 'FK_COMMODIT_HAVE_BILL_DET')
alter table COMMODITY
   drop constraint FK_COMMODIT_HAVE_BILL_DET
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CUSTOMER') and o.name = 'FK_CUSTOMER_COMPANY_C_COMPANY')
alter table CUSTOMER
   drop constraint FK_CUSTOMER_COMPANY_C_COMPANY
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('BILL')
            and   name  = 'ODER_FK'
            and   indid > 0
            and   indid < 255)
   drop index BILL.ODER_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BILL')
            and   type = 'U')
   drop table BILL
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('BILL_DETAILS')
            and   name  = 'PAY_FK'
            and   indid > 0
            and   indid < 255)
   drop index BILL_DETAILS.PAY_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BILL_DETAILS')
            and   type = 'U')
   drop table BILL_DETAILS
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('COMMODITY')
            and   name  = 'HAVE_FK'
            and   indid > 0
            and   indid < 255)
   drop index COMMODITY.HAVE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('COMMODITY')
            and   type = 'U')
   drop table COMMODITY
go

if exists (select 1
            from  sysobjects
           where  id = object_id('COMPANY')
            and   type = 'U')
   drop table COMPANY
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CUSTOMER')
            and   name  = 'COMPANY_CUS_FK'
            and   indid > 0
            and   indid < 255)
   drop index CUSTOMER.COMPANY_CUS_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CUSTOMER')
            and   type = 'U')
   drop table CUSTOMER
go

/*==============================================================*/
/* Table: BILL                                                  */
/*==============================================================*/
create table BILL (
   CODE_BILL            char(10)             not null,
   CODE_CUS             char(10)             not null,
   DELIVERY_DATE        datetime             null,
   ORDER_DATE           datetime             null,
   DELIVERY_ADDRESS     varchar(150)         null,
   constraint PK_BILL primary key (CODE_BILL)
)
go

/*==============================================================*/
/* Index: ODER_FK                                               */
/*==============================================================*/




create nonclustered index ODER_FK on BILL (CODE_CUS ASC)
go

/*==============================================================*/
/* Table: BILL_DETAILS                                          */
/*==============================================================*/
create table BILL_DETAILS (
   CODE_BILL_DETAILS    char(10)             not null,
   CODE_CUS             char(10)             not null,
   AMOUNT               int                  null,
   PRICE                decimal              null,
   constraint PK_BILL_DETAILS primary key (CODE_BILL_DETAILS)
)
go

/*==============================================================*/
/* Index: PAY_FK                                                */
/*==============================================================*/




create nonclustered index PAY_FK on BILL_DETAILS (CODE_CUS ASC)
go

/*==============================================================*/
/* Table: COMMODITY                                             */
/*==============================================================*/
create table COMMODITY (
   CODE_COMMODITY       char(10)             not null,
   CODE_BILL_DETAILS    char(10)             not null,
   NAME                 varchar(50)          null,
   DATE_OF_MANUFACTURE  datetime             null,
   EXPIRY_DATE          datetime             null,
   constraint PK_COMMODITY primary key (CODE_COMMODITY)
)
go

/*==============================================================*/
/* Index: HAVE_FK                                               */
/*==============================================================*/




create nonclustered index HAVE_FK on COMMODITY (CODE_BILL_DETAILS ASC)
go

/*==============================================================*/
/* Table: COMPANY                                               */
/*==============================================================*/
create table COMPANY (
   CODE_COMPANY         char(10)             not null,
   NAME                 varchar(50)          null,
   PHONE                char(11)             null,
   ADDRESS              varchar(150)         null,
   EMAIL                varchar(150)         null,
   constraint PK_COMPANY primary key (CODE_COMPANY)
)
go

/*==============================================================*/
/* Table: CUSTOMER                                              */
/*==============================================================*/
create table CUSTOMER (
   CODE_CUS             char(10)             not null,
   CODE_COMPANY         char(10)             not null,
   NAME                 varchar(50)          null,
   PHONE                char(11)             null,
   ADDRESS              varchar(150)         null,
   EMAIL                varchar(150)         null,
   constraint PK_CUSTOMER primary key (CODE_CUS)
)
go

/*==============================================================*/
/* Index: COMPANY_CUS_FK                                        */
/*==============================================================*/




create nonclustered index COMPANY_CUS_FK on CUSTOMER (CODE_COMPANY ASC)
go

alter table BILL
   add constraint FK_BILL_ODER_CUSTOMER foreign key (CODE_CUS)
      references CUSTOMER (CODE_CUS)
go

alter table BILL_DETAILS
   add constraint FK_BILL_DET_PAY_CUSTOMER foreign key (CODE_CUS)
      references CUSTOMER (CODE_CUS)
go

alter table COMMODITY
   add constraint FK_COMMODIT_HAVE_BILL_DET foreign key (CODE_BILL_DETAILS)
      references BILL_DETAILS (CODE_BILL_DETAILS)
go

alter table CUSTOMER
   add constraint FK_CUSTOMER_COMPANY_C_COMPANY foreign key (CODE_COMPANY)
      references COMPANY (CODE_COMPANY)
go

--Câu 3:

INSERT INTO COMPANY (CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('c1','product 1','0848741399','Vinh Long','huykhangvo02092000@gmail.com')
INSERT INTO COMPANY (CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('c2','product 2','0848741399','Vinh Long','huykhangvo02092000@gmail.com')
INSERT INTO COMPANY (CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('c3','product 3','0848741399','Vinh Long','huykhangvo02092000@gmail.com')
INSERT INTO COMPANY (CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('c4','product 4','0848741399','Vinh Long','huykhangvo02092000@gmail.com')
INSERT INTO COMPANY (CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('c5','product 5','0848741399','Vinh Long','huykhangvo02092000@gmail.com')
SELECT * FROM COMPANY

INSERT INTO CUSTOMER (CODE_CUS, CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('cus1','c1','Nguyen Van A','0848741391','Ha Noi','nguyenvana@gmail.com')
INSERT INTO CUSTOMER (CODE_CUS, CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('cus2','c2','Nguyen Van B','0848741392','Vinh Long','nguyenvanb@gmail.com')
INSERT INTO CUSTOMER (CODE_CUS, CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('cus3','c3','Nguyen Van C','0848741393','Can Tho','nguyenvanc@gmail.com')
INSERT INTO CUSTOMER (CODE_CUS, CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('cus4','c4','Nguyen Van D','0848741394','Vinh Long','nguyenvand@gmail.com')
INSERT INTO CUSTOMER (CODE_CUS, CODE_COMPANY, NAME, PHONE, ADDRESS, EMAIL) VALUES ('cus5','c5','Nguyen Van D','0848741394','Vinh Long','nguyenvand@gmail.com')
SELECT * FROM CUSTOMER

INSERT INTO BILL (CODE_BILL, CODE_CUS, DELIVERY_DATE, ORDER_DATE, DELIVERY_ADDRESS) VALUES ('b1','cus1','2022-12-21','2022-12-21','Vinh Long')
INSERT INTO BILL (CODE_BILL, CODE_CUS, DELIVERY_DATE, ORDER_DATE, DELIVERY_ADDRESS) VALUES ('b2','cus2','2022-12-21','2022-12-21','Vinh Long')
INSERT INTO BILL (CODE_BILL, CODE_CUS, DELIVERY_DATE, ORDER_DATE, DELIVERY_ADDRESS) VALUES ('b3','cus3','2022-12-21','2022-12-21','Vinh Long')
INSERT INTO BILL (CODE_BILL, CODE_CUS, DELIVERY_DATE, ORDER_DATE, DELIVERY_ADDRESS) VALUES ('b4','cus4','2022-12-21','2022-12-21','Vinh Long')
SELECT * FROM BILL

INSERT INTO BILL_DETAILS (CODE_BILL_DETAILS, CODE_CUS, AMOUNT, PRICE) VALUES ('bd1','cus1','10','100000')
INSERT INTO BILL_DETAILS (CODE_BILL_DETAILS, CODE_CUS, AMOUNT, PRICE) VALUES ('bd2','cus2','12','120000')
INSERT INTO BILL_DETAILS (CODE_BILL_DETAILS, CODE_CUS, AMOUNT, PRICE) VALUES ('bd3','cus3','14','140000')
INSERT INTO BILL_DETAILS (CODE_BILL_DETAILS, CODE_CUS, AMOUNT, PRICE) VALUES ('bd4','cus4','16','160000')
SELECT * FROM BILL_DETAILS

INSERT INTO COMMODITY (CODE_COMMODITY, CODE_BILL_DETAILS, NAME, DATE_OF_MANUFACTURE, EXPIRY_DATE) VALUES ('cm1','bd1','Bia 333','2022-12-21','2050-12-21')
INSERT INTO COMMODITY (CODE_COMMODITY, CODE_BILL_DETAILS, NAME, DATE_OF_MANUFACTURE, EXPIRY_DATE) VALUES ('cm2','bd2','Bia Tiger','2022-12-21','2050-12-21')
INSERT INTO COMMODITY (CODE_COMMODITY, CODE_BILL_DETAILS, NAME, DATE_OF_MANUFACTURE, EXPIRY_DATE) VALUES ('cm3','bd3','Bia Heniken','2022-12-21','2050-12-21')
INSERT INTO COMMODITY (CODE_COMMODITY, CODE_BILL_DETAILS, NAME, DATE_OF_MANUFACTURE, EXPIRY_DATE) VALUES ('cm4','bd4','Bia SaiGon','2022-12-21','2050-12-21')
SELECT * FROM COMMODITY


--Câu 4:
SELECT * FROM CUSTOMER WHERE [ADDRESS] = 'Vinh Long'

-- Câu 5:

Create view CUSTOMER_ODER
	as
	SELECT CUSTOMER.CODE_CUS,CUSTOMER.NAME, COUNT(BILL.CODE_BILL) AS COUNT_ODER FROM CUSTOMER,BILL GROUP BY CUSTOMER.CODE_CUS,CUSTOMER.NAME

	SELECT * FROM CUSTOMER_ODER

-- Câu 6:

Create proc insert_bill (@CODE_BILL char(10),
   @CODE_CUS char(10),
   @DELIVERY_DATE datetime,
   @ORDER_DATE datetime,
   @DELIVERY_ADDRESS varchar(150)
   )
AS
	if not exists(SELECT CODE_CUS FROM BILL WHERE CODE_CUS = @CODE_CUS)
		INSERT INTO BILL (CODE_BILL, CODE_CUS, DELIVERY_DATE, ORDER_DATE, DELIVERY_ADDRESS) 
		VALUES (@CODE_BILL,@CODE_CUS,@DELIVERY_DATE,@ORDER_DATE,@DELIVERY_ADDRESS)
	else print(N'Đã trùng mã CODE_CUS')

	Exec insert_bill 'b5','cus5','2022-12-21','2022-12-21','Vinh Long'
	SELECT * FROM BILL