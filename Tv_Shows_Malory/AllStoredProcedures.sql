-- fixed new episode Madisen 1
ALTER PROCEDURE newEpisode
@EpName VARCHAR(30), 
@EpOverview VARCHAR(30), 
@EpRunTime INT,
@BroadDate DATE, 
@SerName VARCHAR(50)
AS 

IF @EpName IS NULL OR @EpOverview IS NULL OR @EpRunTime IS NULL OR @SerName IS NULL
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('One or more of your parameters is null', 11, 1)
    RETURN 
    END

DECLARE @SID INT 

-- get seriesID
EXECUTE GetSeriesID
@SeriesName = @SerName, 
@SeriesID = @SID OUTPUT 

IF @SID IS NULL 
    BEGIN  
    PRINT 'SID cannot be null'
    RAISERROR ('SID is null', 11, 1)
    RETURN 
    END


BEGIN TRAN G1
    INSERT INTO tblEPISODE (SeriesID, EpisodeName, EpisodeOverview, EpisodeRuntime, BroadcastDate)
    VALUES (@SID, @EpName, @EpOverview, @EpRunTime, @BroadDate)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1

GO 

-- new cust Malory 1
CREATE PROCEDURE newCustomer 
@CustomerFname VARCHAR(30), 
@CustomerLname VARCHAR(30), 
@CustomerDOB DATE, 
@Address VARCHAR(50), 
@State VARCHAR(50),
@City VARCHAR(50),
@PostalCode CHAR(9), 
@Country VARCHAR(50)
AS
IF @CustomerFname IS NULL OR @CustomerLname IS NULL OR @CustomerDOB IS NULL 
    OR @Address IS NULL OR @State IS NULL OR @City IS NULL OR @PostalCode IS NULL OR @Country IS NULL
    BEGIN 
    PRINT 'paramaters can''t be NULL' 
    RAISERROR ('One or more Paramater is Null', 11, 1)
    RETURN 
    END
BEGIN TRAN G1 
    INSERT INTO tblCUSTOMER (CustFname, CustLname, CustDOB, [Address], [State], City, PostalCode, Country)
    VALUES (@CustomerFname, @CustomerLname, @CustomerDOB, @Address, @State, @City, @PostalCode, @Country)
    IF @@ERROR <> 0 
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1
GO 

--stored procedure num 2 ria 2
CREATE PROCEDURE newSurvey 
@SurvvDate DATE 
AS 

IF @SurvvDate IS NULL 
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('one or more of your parameters are null', 11, 1)
    RETURN 
    END


BEGIN TRAN G1
    INSERT INTO tblSURVEY (SurveyDate)
    VALUES (@SurvvDate)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1

GO 

-- Inserting new membership Malory 2
CREATE PROC newMembership 
@CFname VARCHAR(30), 
@CLname VARCHAR(30), 
@CDOB DATE, 
@MemName VARCHAR(50), 
@MemDescr VARCHAR(150), 
@Price NUMERIC(8,2),
@BeginDate DATE, 
@EndDate DATE
AS 

IF @CFname IS NULL OR @CLname IS NULL OR @CDOB IS NULL OR @MemName IS NULL OR 
@MemDescr IS NULL OR @Price IS NULL OR @BeginDate IS NULL OR @EndDate IS NULL 
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('one or more of your parameters are null', 11, 1)
    RETURN 
    END

DECLARE @CID INT 

EXECUTE getCustID 
@CustFname = @CFname, 
@CustLname = @CLname, 
@CustDOB = @CDOB, 
@CustID = @CID OUTPUT 

IF @CID IS NULL 
    BEGIN  
    PRINT 'CID cannot be null'
    RAISERROR ('CID is null', 11, 1)
    RETURN 
    END

BEGIN TRAN G1
    INSERT INTO tblMEMBERSHIP (CustomerID, MembershipName, MembershipDescr, MembershipPrice, BeginDate, EndDate)
    VALUES (@CID, @MemName, @MemDescr, @Price, @BeginDate, @EndDate)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1

GO 


--Insert into lang Madisen 2
ALTER PROCEDURE newLanguage
@LangCode VARCHAR(5),
@LangName VARCHAR(50)
AS 

IF @LangCode IS NULL OR @LangName IS NULL
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('One or more of your parameters is null', 11, 1)
    RETURN 
    END

BEGIN TRAN G1
    INSERT INTO tblLANGUAGE (LanguageCode, LanguageName)
    VALUES (@LangCode, @LangName)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1
GO 

--stored procedure num 1 ria edited

ALTER PROCEDURE uspnewseries
@SerName VARCHAR(50),
@SerPopularity INT,
@SerTotal INT,
@SerOverview VARCHAR(50),
@SerBeginDate INT, 
@LangName VARCHAR(50)
AS 

IF @SerName IS NULL OR @SerPopularity IS NULL OR @SerTotal IS NULL OR 
@SerOverview IS NULL OR @SerBeginDate IS NULL OR @LangName IS NULL 
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('one or more of your parameters are null', 11, 1)
    RETURN 
    END
DECLARE @LID INT 

EXECUTE GetLanguageID
@LanguageName = @LangName,
@LanguageID  = @LID OUTPUT 

IF @LID IS NULL 
    BEGIN  
    PRINT 'LID cannot be null'
    RAISERROR ('LID is null', 11, 1)
    RETURN 
    END

BEGIN TRAN G1
    INSERT INTO tblSERIES (LanguageID, SeriesName, SeriesOverview, SeriesPopularity, SeasonTotal, SeriesBeginDate)
    VALUES (@LID, @SerName, @SerOverview, @SerPopularity, @SerTotal, @SerBeginDate)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1

GO 

