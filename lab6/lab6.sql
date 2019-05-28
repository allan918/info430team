-- run the script below first but repalce with respective netID alias

/*
RESTORE DATABASE May15_Lab_madireyn FROM DISK = 'c:\sql\May15_Lab.bak'
WITH
MOVE 'Hiccup_gthay' to 'c:\sql\May15_Lab_madireyn.mdf',
MOVE 'Hiccup_gthay_log' to 'c:\sql\May15_Lab_madireyn.ldf'
*/

-- create procedure
CREATE PROCEDURE usp_OrderWrapper
@Run INT
    AS
    DECLARE 
    @F varchar(30), --first name
    @L varchar(30), -- last name
    @D datetime, -- date
    @P varchar(100), -- product name
    @Q int, --quantity
    @OD datetime, --order date
    @Rand numeric(16,16),
    @CustCount int = (SELECT COUNT(*) FROM tblCUSTOMER),
    @ProdCount int = (SELECT COUNT(8) FROM tblPRODUCT),
    @CustID int,
    @ProdID int

    WHILE @Run > 0
    BEGIN
    -- set rand variable
    Set @Rand = (SELECT RAND()) -- use this value to find everything else we need

    -- see how you can use rand variable to find customer and product id
    -- set customer and product id
    -- using custID and prodID, fill the other values
    -- can't fill quantity and datetime, but fill this in other ways
    -- set the quantity by using a case statement???
    SET @CustID = (Select @Rand * @CustCount + 1)
    SET @ProdID = (Select @Rand * @ProdCount + 1)

    Set @F = (SELECT CustFname FROM tblCustomer WHERE )
    Set @L = (SELECT CustLname FROM tblCustomer WHERE )
    Set @D = (SELECT GETDATE()
    Set @P = (SELECT ProductName from tblPRODUCT WHERE )
    Set @Q = (SELECT ) -- don't know how to determine quantity
    


    -- call stored procedure in DB




