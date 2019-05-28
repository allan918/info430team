USE TV_SHOWS 
GO 
/*1) Stored procedure (DONE)
2) Check constraint (NEED TO DO)
3) Computed column (NEED TO DO)
4) Views (NEED TO DO)

As stated in lecture, grading will be based on the student's ability to leverage complex skills presented in lecture and should include the following where appropriate:
* explicit transactions
* Complexity as appropriate: multiple JOINs, GROUP BY, ORDER BY, TOP, RANK, CROSS APPLY
* error-handling
* passing of appropriate  parameters (name values and/or output parameters)
* subqueries
* variables*/

-- 1) GetEpisodeID 
CREATE PROCEDURE GetEpisodeID 
@EpisodeName VARCHAR(100), 
@EpisodeOverview VARCHAR(500), 
@EpisodeRuntime TIME, 
@BroadcastDate DATE,
@EpisodeID INT OUTPUT
AS
SET @EpisodeID = (SELECT EpisodeID FROM tblEPISODE WHERE EpisodeName = @EpisodeName AND 
                EpisodeOverview = @EpisodeOverview AND EpisodeRuntime = @EpisodeRuntime
                AND BroadcastDate = @BroadcastDate)
GO 

-- 2) GetMembershipID
CREATE PROCEDURE GetMembershipID 
@MembershipName VARCHAR(50), 
@MembershipDescr VARCHAR(150), 
@BeginDate DATE, 
@EndDate DATE, 
@MembershipID INT OUTPUT 
AS 
SET @MembershipID = (SELECT MembershipID FROM tblMEMBERSHIP WHERE MembershipName = @MembershipName
                    AND MembershipDescr = @MembershipDescr AND BeginDate = @BeginDate AND EndDate = @EndDate)
GO 

--3) NewCustomer 
CREATE PROCEDURE newCustomer 
@CustomerFname VARCHAR(30), 
@CustomerLname VARCHAR(30), 
@CustomerDOB DATE, 
@Address VARCHAR(50), 
@State VARCHAR(50),
@City VARCHAR(50),
@PostalCode CHAR(9)
AS
--DECLARE @CustomerID INT 
IF @CustomerFname IS NULL OR @CustomerLname IS NULL OR @CustomerDOB IS NULL 
    OR @Address IS NULL OR @State IS NULL OR @City IS NULL OR @PostalCode IS NULL
    BEGIN 
    PRINT 'paramaters can''t be NULL' 
    RAISERROR ('One or more Paramater is Null', 11, 1)
    RETURN 
    END
BEGIN TRAN G1 
    INSERT INTO tblCUSTOMER (CustFname, CustLname, CustDOB, [Address], [State], City, PostalCode)
    VALUES (@CustomerFname, @CustomerLname, @CustomerDOB, @Address, @State, @City, @PostalCode)
    IF @@ERROR <> 0 
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1
GO 

--4) Can only watch Netflix if country 
--is not the US

CREATE FUNCTION fn_OnlyNetflixOutsideOfUS()
RETURNS INT 
AS
BEGIN 
DECLARE @Ret INT = 0

IF EXISTS (SELECT * FROM tblCUSTOMER C
            JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID 
            JOIN tblDOWNLOAD_EPISODE DE ON M.MembershipID = DE.MembershipID
            JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
            JOIN tblPLATFORM P ON PE.PlatformID = P.PlatformID
            WHERE C.Country != 'United States' AND P.PlatformName = 'Netflix')
    BEGIN 
    SET @Ret = 1
    END 
RETURN @Ret
END
GO 

ALTER TABLE tblPLATFORM 
ADD CONSTRAINT CK_OnlyNetflixOutsideOfUS
CHECK (dbo.fn_OnlyNetflixOutsideOfUS() = 0) 