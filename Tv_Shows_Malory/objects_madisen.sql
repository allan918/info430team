-- 1) stored procedure: new episode EDITED 

ALTER PROCEDURE newEpisode
@EpName VARCHAR(30), 
@EpOverview VARCHAR(30), 
@EpRunTime int,
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


-- 2) stored procedure: new language
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
    INSERT INTO tblLANGUAGE (LanguageID, LanguageCode, LanguageName)
    VALUES (@LID, @LangCode, @LangName)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1
GO 

-- 3) business rule: users from Spain can only use Hulu or Netflix
CREATE FUNCTION fn_OnlyHuluOrNetflixInSpain()
RETURNS INT 
AS
BEGIN 
DECLARE @Ret INT = 0

IF EXISTS (SELECT * FROM tblCUSTOMER C
            JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID 
            JOIN tblDOWNLOAD_EPISODE DE ON M.MembershipID = DE.MembershipID
            JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
            JOIN tblPLATFORM P ON PE.PlatformID = P.PlatformID
            WHERE C.Country = 'Spain' AND (P.PlatformName = 'Hulu' OR P.PlatformName = 'Netflix'))
    BEGIN 
    SET @Ret = 1
    END 
RETURN @Ret
END
GO 

ALTER TABLE tblPLATFORM 
ADD CONSTRAINT CK_OnlyHuluOrNetflixInSpain
CHECK (dbo.fn_OnlyHuluOrNetflixInSpain() = 0) 

GO 

-- 4) business rule: users from Germany can only use platforms if they became a member before 2015
CREATE FUNCTION fn_Germany2015Membership()
RETURNS INT 
AS
BEGIN 
DECLARE @Ret INT = 0

IF EXISTS (SELECT * FROM tblCUSTOMER C
            JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID 
            JOIN tblDOWNLOAD_EPISODE DE ON M.MembershipID = DE.MembershipID
            JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
            JOIN tblPLATFORM P ON PE.PlatformID = P.PlatformID
            WHERE C.Country = 'Germany' AND M.BeginDate < '01-01-2015')
    BEGIN 
    SET @Ret = 1
    END 
RETURN @Ret
END
GO 

ALTER TABLE tblPLATFORM 
ADD CONSTRAINT CK_Germany2015Membership
CHECK (dbo.fn_Germany2015Membership() = 0) 

GO 