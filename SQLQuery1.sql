-- before we can start step 1
CREATE DATABASE Group13_Lab04
USE Group13_Lab04

CREATE TABLE tblPRODUCT (ProductID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
						ProductName VARCHAR(50) NOT NULL,
						Price NUMERIC NOT NULL, 
						ProductDescr VARCHAR(100))
GO

CREATE TABLE tblCUSTOMER (CustID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
						Fname VARCHAR(30) NOT NULL, 
						Lname VARCHAR(30) NOT NULL, 
						BirthDate DATE NOT NULL, 
						StreetAdress VARCHAR(75) NOT NULL, 
						City VARCHAR(50) NOT NULL, 
						[State] VARCHAR(50) NOT NULL, 
						Zip VARCHAR(20))
GO

CREATE TABLE tblORDER (OrderID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
						OrderDate DATE, 
						CustID INT FOREIGN KEY REFERENCES tblCUSTOMER (CustID) NOT NULL, 
						OrderTotal NUMERIC NOT NULL)
GO 

CREATE TABLE tblLINE_ITEM (OrderProductID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
							OrderID INT FOREIGN KEY REFERENCES tblORDER (OrderID) NOT NULL,
							ProductID INT FOREIGN KEY REFERENCES tblPRODUCT (ProductID) NOT NULL, 
							Qty INT NOT NULL, 
							PriceExtended NUMERIC) 
GO 

CREATE TABLE tblCART (CartID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
					CustID INT FOREIGN KEY REFERENCES tblCUSTOMER (CustID) NOT NULL,
					ProductID INT FOREIGN KEY REFERENCES tblPRODUCT (ProductID) NOT NULL, 
					Quantity INT NOT NULL) 
GO



--Based on the diagram presented in class, write the SQL code to conduct the following:

--1) Populate tblCART with a stored procedure; parameters are going to be CustFname, CustLname, CustBirthDate, ProductName, Quantity and Date.
-- Creating sproc for populating the customer table 
ALTER PROC uspNewCust
   @CustFName VARCHAR(30),
   @CustLName VARCHAR(30),
   @CustBirthDate DATE,
   @Address VARCHAR(75), 
   @City VARCHAR(50), 
   @State VARCHAR(50),
   @Zip VARCHAR(20)
AS
INSERT INTO tblCUSTOMER (Fname, Lname, BirthDate, StreetAdress, City, [State], Zip) 
VALUES (
 @CustLName,
@CustFName,
 @CustBirthDate, 
  @Address,
 @City,
 @State,
 @Zip
)
GO

SELECT * FROM tblCUSTOMER
-- populating the customer table 
EXECUTE uspNewCust 
   @CustFName = 'Jamie',
   @CustLName = 'Johnson',
   @CustBirthDate = '06/01/1999',
    @Address = '7876 7th Ave NE', 
   @City = 'Maple Valley', 
   @State = 'Washington',
   @Zip = '98038'
   GO

-- Creating the sproc for populating the product table 
CREATE PROCEDURE uspNewProduct 
@ProdName VARCHAR(50), 
@ProdDescr VARCHAR(100), 
@Price NUMERIC 
AS 
INSERT INTO tblPRODUCT (ProductName, ProductDescr, Price)
VALUES (@ProdName, @ProdDescr, @Price)
GO 
-- populating the product table 
EXECUTE uspNewProduct
@ProdName = 'Pancakes', 
@ProdDescr = 'Fluffy cake-like breakfast food', 
@Price = 4.00


(not sure what to do with parameters i.e. set them by selecting from tblCUSTOMER, tblPRODUCT, and tblLINE_ITEM?)

2) Write two stored procedures to get the required foreign key values in tblORDER (CustID and ProdID)
/* GET CUSTID SPROC */
CREATE PROCEDURE usp_GetCustID
@Fname VARCHAR(30), 
@Lname VARCHAR(30),
@DOB DATE, 
@CustomerID INT OUTPUT
AS 

SET @CustomerID = (SELECT CustID FROM tblCUSTOMER WHERE Fname = @Fname AND Lname = @Lname AND BirthDate = @DOB) 
GO 

Create proc get_id(
@ProductName varchar(30), 
@ProductID int out)
as 
Set @ProductID = (select ProductID FROM tblPRODUCT
				WHERE ProductName = @ProductName)
Go



alter proc insert_Cart
(@CustFname varchar(30),
 @CustLname varchar(30),
 @CustBirthDate date,
 @ProductName varchar(30),
 @Quantity int,
 @Date date
)
as
declare @CustID int,
@ProductID int,
@Qty int,
@GetCustID int,
@GetProdID int

Exec get_id @ProductName = @ProductName, @ProductID = @GetProdID out


if @GetProdID is null
begin
print 'cannot get product id' 
raiserror('emmm',11,1)
return
end

Exec usp_GetCustID 
@Fname       = 	@CustFname
,@Lname 		 = 	@CustLname
,@DOB 		 = 	@CustBirthDate
,@CustomerID  = @GetCustID out


if @GetCustID is null
begin
print 'cannot get cust id' 
raiserror('emmm',11,1)
return
end

insert into tblCART(CustID, ProductID ,Quantity)
values(@getCustID, @getProdID, @Quantity)
Go

-- populating cart 
Execute insert_Cart
@CustFname = 'Bond',
@CustLname = 'James',
@CustBirthDate ='11/12/1976',
@ProductName = 'Water', 
@Quantity = 2, 
@Date = '04/25/2019'

CREATE TABLE [dbo].[tempTable] 
PK_ID INT IDENTITY(1,1) PRIMARY KEY, 
[Customer] [nvarchar](100) NULL, 
[Product] [nvarchar](100) NULL,
[Date_Birth] [datetime] NULL) 
ON [PRIMARY]


CREATE PROCEDURE uspProcessCart
@CustFName VARCHAR(30), 
@CustLName VARCHAR(30), 
@CustDOB DATE, 
@ProdName VARCHAR(50), 
@Q INT, 
AS 
DECLARE @C_ID INT, @P_ID

SET @C_ID = @CustID 
SET @P_ID = @ProdID
-- Truncate table tblTemp
DECLARE @Run INT 
SET @Run = (SELECT COUNT(*) FROM tblCART)
WHILE @Run > 0 

IF @Run = @C_ID
-- if check for equality of customerIDs + aggregate accordingly
-- move the row from cart to the temp table 
INSERT INTO tempTable (CustID, ProductID, Qty) 
VALUES (@C_ID, @P_ID, @Q)
ELSE 
@Run = @Run - 1

END


GO


SELECT CustomerID, ProductID, Quantity INTO  #tblTEMP WHERE 
DROP tblTEMP
			
Product name 
GO 



EXECUTE uspProcessCart 
@CustomerID =  @CustID, 
@ProductID = @PID, 
@Qty = @Q



INSERT INTO tblTemp(CustID, ProdID, Quantity)
SELECT CustID, ProdID, Quantity
FROM tblCART

CREATE FUNCTION fn_Calculate_OrderTotal(@OrderID) 
RETURNS Numeric(10,2) 
AS 
BEGIN 
	Declare @Ret Numeric(10,2) = (SELECT ?? FROM tblPRODUCT P 
JOIN tblLINE_ITEM LI on P.ProductID = LI.ProductID
JOIN tblORDER O ON LI.OrderID = O.OrderID
WHERE O.OrderID = @OrderID) 
Return @Ret
END
GO   


CREATE FUNCTION fn_Calculate_lineItem_Total(@OrderProductID INT)
Returns numeric(10,2) --what we want to return  (Data type)
As
Begin 
	Declare @Ret Numeric(10,2) = (select P.Price * LI.Qty 
			from tblPRODUCT P JOIN tblLINT_ITEM LI ON P.ProductID - LI.ProductID							
WHERE LI.OrderProductID = @LineItemID) 
	Return @Ret
END


GO 

Alter table tblLINE_ITEM
ADD Line_Extended_Price as (dbo.fn_Calculate_lineItem_Total(OrderProductID))



----



CREATE TABLE tblLINE_ITEM (OrderProductID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
                            OrderID INT FOREIGN KEY REFERENCES tblORDER (OrderID) NOT NULL,
                            ProductID INT FOREIGN KEY REFERENCES tblPRODUCT (ProductID) NOT NULL,
                            Qty INT NOT NULL,
                            PriceExtended NUMERIC)