-- business rule ria
--Can not watch horror movie 
--if younger than 16
CREATE FUNCTION fn_ageappropriatehorror()
RETURNS INT 
AS
BEGIN 
DECLARE @Ret INT = 0

IF EXISTS (SELECT * FROM tblPERSON P
            JOIN tblPERSON_CREDIT_EPISODE PC ON P.PersonID = PC.PersonID
            JOIN tblEPISODE EP ON PC.EpisodeID = EP.EpisodeID
            JOIN tblEPISODE_GENRE EG ON EP.EpisodeID = EG.EpisodeID
            JOIN tblGENRE G ON EG.GenreID = G.GenreID
            WHERE P.PersonDOB > (SELECT (GETDATE() - (365.25 * 16))) AND G.GenreDescr = 'Horror'
)
    BEGIN 
    SET @Ret = 1
    END 
RETURN @Ret
END
GO 

ALTER TABLE tblGENRE 
ADD CONSTRAINT CK_ageappropriatehorror
CHECK (dbo.fn_ageappropriatehorror() = 0) 

GO 

--business rule two ria 
--not working

CREATE FUNCTION fn_ageappropriatmembership()
RETURNS INT 
AS
BEGIN 
DECLARE @Ret INT = 0

IF EXISTS (SELECT * FROM tblPERSON P
            JOIN tblPERSON_CREDIT_EPISODE PC ON P.PersonID = PC.PersonID
            JOIN tblEPISODE EP ON PC.EpisodeID = EP.EpisodeID
            JOIN tblEPISODE_GENRE EG ON EP.EpisodeID = EG.EpisodeID
            JOIN tblGENRE G ON EG.GenreID = G.GenreID
            WHERE P.PersonDOB < (SELECT (GETDATE() - (365.25 * 13))) AND G.GenreDescr = 'Horror'
)
    BEGIN 
    SET @Ret = 1
    END 
RETURN @Ret
END
GO 

ALTER TABLE tblMEMBERSHIP
ADD CONSTRAINT CK_ageappropriatemembership
CHECK (dbo.fn_ageappropriatemembership() = 0) 

GO 

-- view number one ria 
-- find all the shows in Spanish 
CREATE VIEW [SpanishShowsAreCoolestShows] AS 
SELECT EP.EpisodeID, EP.EpisodeName
FROM tblEPISODE EP
JOIN tblSERIES S ON EP.SeriesID = S.SeriesID
JOIN tblLANGUAGE L ON S.LanguageID = L.LanguageID
WHERE L.LanguageName = 'Spanish' 
GO

--View 2
-- Find all episodes (The Rock) is in on (Netflix)
-- not sure how to get the collective episodes 
CREATE VIEW [TheRockOnNetflix] AS 
SELECT P.PersonID, PersonFname, PersonLname 
FROM tblPERSON P
JOIN tblPERSON_CREDIT_EPISODE PCE ON P.PersonID = PCE.PersonID
JOIN tblEPISODE E ON PCE.EpisodeID = E.EpisodeID
JOIN tblPLATFORM_EPISODE PE ON E.EpisodeID = PE.EpisodeID
JOIN tblPLATFORM PL ON PE.PlatformID = PL.PlatformID
WHERE P.PersonFName = 'The' AND P.PersonLname = 'Rock' AND .PersonLname = 'Perry'
AND PL.PlatformName = 'Netflix'

GO 

--stored procedure num 1 ria
CREATE PROCEDURE newseries
@EpName VARCHAR(30), 
@EpOverview VARCHAR(30), 
@EpRunTime DATE,
@BroadDate DATE, 
@SerName VARCHAR(50),
@SerPopularity INT,
@SerTotal INT,
@SerOverview VARCHAR(50),
@SerBeginDate DATE, 
@SerEndDate DATE
AS 

IF @EpName IS NULL OR @EpOverview IS NULL OR @EpRunTime IS NULL OR @SerName IS NULL OR @SerPopularity IS NULL OR @SerTotal IS NULL OR 
@SerOverview IS NULL OR @SerBeginDate IS NULL OR @SerEndDate IS NULL 
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('one or more of your parameters are null', 11, 1)
    RETURN 
    END

DECLARE @EID INT 

EXECUTE GetEpisodeID
@@EpisodeName = @EpName, 
@EpisodeOverview = @EpOverview, 
@EpisodeRuntime = @EpRunTime, 
@BroadcastDate = @BroadDate,
@EpisodeID = @EID OUTPUT 

IF @EID IS NULL 
    BEGIN  
    PRINT 'EID cannot be null'
    RAISERROR ('EID is null', 11, 1)
    RETURN 
    END

BEGIN TRAN G1
    INSERT INTO tblSERIES (EpisodeID, SeriesName, SeriesOverview, SeriesPopularity, SeasonTotal, SeriesBeginDate, SeriesEndDate)
    VALUES (@EID, @SerName, @SerOverview, @SerPopularity, @SerTotal, @SerBeginDate, @SerEndDate)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1

GO 

--stored procedure num 2 ria
CREATE PROCEDURE newSurvey 
@SurvDate DATE, 
@MemName VARCHAR(50), 
@MemDescr VARCHAR(150), 
@Price NUMERIC(8,2),
@MemBeginDate DATE, 
@MemEndDate DATE
AS 

IF @SurvDate IS NULL OR @MemName IS NULL OR @MemDescr IS NULL OR @Price IS NULL 
OR @BeginDate IS NULL OR @EndDate IS NULL 
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('one or more of your parameters are null', 11, 1)
    RETURN 
    END

DECLARE @MID INT 

EXECUTE GetMembershipID 
@MembershipName = @MemName, 
@MembershipDescr = @MemDescr, 
@BeginDate = @MemBeginDate, 
@EndDate = @MemEndDate, 
@MembershipID = @MID 

IF @MID IS NULL 
    BEGIN  
    PRINT 'MID cannot be null'
    RAISERROR ('MID is null', 11, 1)
    RETURN 
    END

BEGIN TRAN G1
    INSERT INTO tblSURVEY (MembershipID, MembershipName, MembershipDescr, MembershipPrice, BeginDate, EndDate)
    VALUES (@CID, @MemName, @MemDescr, @Price, @BeginDate, @EndDate)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1

GO 