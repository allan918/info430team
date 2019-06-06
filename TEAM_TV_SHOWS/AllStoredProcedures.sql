USE Group13_TV_SHOWS
GO 
--GetEpisodeID 
CREATE PROCEDURE GetEpisodeID 
@EpisodeName VARCHAR(100), 
@EpisodeID INT OUTPUT
AS
SET @EpisodeID = (SELECT EpisodeID FROM tblEPISODE WHERE EpisodeName = @EpisodeName)
GO 
--GetMembershipID edited 
CREATE PROCEDURE GetMembershipID 
@MembershipName VARCHAR(50), 
@BeginDate DATE,  
@MembershipID INT OUTPUT 
AS 
SET @MembershipID = (SELECT MembershipID FROM tblMEMBERSHIP WHERE MembershipName = @MembershipName AND BeginDate = @BeginDate)
GO 
--GetCustID 
CREATE PROC GetCustID 
@CustFname VARCHAR(30), 
@CustLname VARCHAR(30), 
@CustDOB DATE, 
@CustID INT OUTPUT
AS 
SET @CustID = (Select CustomerID FROM tblCUSTOMER 
WHERE CustFname = @CustFname AND CustLname = @CustLname 
AND CustDOB = @CustDOB)
GO 
-- GetGenreID edited
CREATE PROC GetGenreID
@GenreName VARCHAR(100),
@GenreID INT OUTPUT 
AS
SET @GenreID = (SELECT GenreID FROM tblGENRE
WHERE GenreName = @GenreName)
GO
-- GetLanguageID edited 
CREATE PROC GetLanguageID
@LanguageName VARCHAR(50),
@LanguageID INT OUTPUT
AS
SET @LanguageID = (SELECT LanguageID FROM tblLANGUAGE
WHERE LanguageName = @LanguageName)
GO
-- GetGenderID
CREATE PROC GetGenderID
@GenderName VARCHAR(10),
@GenderID INT OUTPUT
AS
SET @GenderID = (SELECT GenderID FROM tblGender
WHERE GenderName = @GenderName)
GO 
-- GetPersonID edited 
CREATE PROC GetPersonID
@PersonFname VARCHAR(30), 
@PersonLname VARCHAR(30), 
@PersonDOB DATE, 
@PersonID INT OUTPUT
AS
SET @PersonID = (SELECT PersonID FROM tblPERSON
WHERE @PersonFname = PersonFname
AND @PersonLname = PersonLname
AND @PersonDOB = PersonDOB)
GO
-- GetSeriesID EDITED 
CREATE PROC GetSeriesID
@SeriesName VARCHAR(100), 
@SeriesID INT OUTPUT
AS
SET @SeriesID = (SELECT SeriesID FROM tblSERIES
WHERE @SeriesName = SeriesName)
GO
-- Get PlatformID edited 
CREATE PROC GetPlatformID
@PlatformName VARCHAR(50),
@PlatformID INT OUTPUT
AS
SET @PlatformID = (SELECT PlatformID FROM tblPLATFORM
WHERE @PlatformName = PlatformName)
GO

/*Madisen's code*/
-- fixed new episode 1
CREATE PROCEDURE newEpisode
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
--Insert into language 2
CREATE PROCEDURE newLanguage
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

/*Malory's Code*/
-- new customer  1
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
-- Inserting new membership 2
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

/*Ria's Code*/
--stored procedure new series 1 
CREATE PROCEDURE newseries
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
--stored procedure New Survey 2
Alter PROCEDURE newSurvey 
@SurvvDate DATE, 
@SurvName VARCHAR(100) 
AS 
IF @SurvvDate IS NULL OR @SurvName IS NULL
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('one or more of your parameters are null', 11, 1)
    RETURN 
    END
BEGIN TRAN G1
    INSERT INTO tblSURVEY (SurveyName, SurveyDate)
    VALUES (@SurvName, @SurvvDate)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1
GO 

/*Xiefe's Code*/
-- insesrt person credit episode 
Create --drop
proc insertPERSON_CREDIT_EPISODE
@EpisodeName1 VARCHAR(100), 
@PersonFname1 VARCHAR(30), 
@PersonLname1 VARCHAR(30), 
@PersonDOB1 DATE, 
@CreditName1 VARCHAR(50),
@Character1 Varchar(50)
as
if @EpisodeName1 is null or
   @PersonFname1 is null or
   @PersonLname1 is null or
   @PersonDOB1 	is null or
   @CreditName1 is null or
   @Character1 	is null 
   begin
   raiserror('parameter cannot be null', 11, 1)
   return
   end
Declare @EpisodeID int
Declare @PersonID int
Declare @CreditID int 
Exec GetEpisodeID  
@EpisodeName = @EpisodeName1,
@EpisodeID = @EpisodeID out
if @EpisodeID is null
begin
print 'epsiode id cannot be null'
raiserror('episode id is null', 11,1 )
return
end 
Exec GetPersonID 
@PersonFname = @PersonFname1, 
@PersonLname = @PersonLname1,
@PersonDOB = @PersonDOB1 , 
@PersonID = @PersonID out
if @PersonID is null
begin
print 'person id cannot be null'
raiserror('person id is null', 11,1 )
return
end 
Exec [dbo].[getCreditID] 
@CreditName  = @CreditName1, 
@CreditID = @CreditID out
if @CreditID is null
begin
print 'credit id cannot be null'
raiserror('credit id is null', 11,1 )
return
end 
Begin tran G1
insert into tblPERSON_CREDIT_EPISODE(EpisodeID, CreditID , PersonID , [Character])
values(@EpisodeID, @CreditID, @PersonID, @Character1)
if @@error <> 0
rollback tran G1
else
commit tran G1
Go
-- insert episode genre 
Create --drop
proc insert_Episode_genre
@GenreName1 VARCHAR(100),
@EpisodeName1 VARCHAR(100)
as
if @GenreName1 is null or
   @EpisodeName1 is null
begin
print 'parameters cannot be null'
raiserror('parameter is null', 11,1)
return
end
Declare @EpisodeID int
Declare @GenreID int
Exec GetEpisodeID  
@EpisodeName = @EpisodeName1, 
@EpisodeID = @EpisodeID out
if @EpisodeID is null
begin
print 'episode id cannot be null'
raiserror('episode id is null', 11,1 )
return
end 
Exec GetGenreID 
@GenreName = @GenreName1,
@GenreID = @GenreID out
if @GenreID is null
begin
print 'genre id cannot is null'
raiserror('genre id is null', 11,1 )
return
end
Begin tran G1
insert into tblEPISODE_GENRE(EpisodeID, GenreID)
values(@EpisodeID, @GenreID)
if @@Error <> 0
rollback tran G1
Else
commit tran G1
Go
