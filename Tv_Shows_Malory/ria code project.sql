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
@SerName VARCHAR(50),
@SerPopularity INT,
@SerTotal INT,
@SerOverview VARCHAR(50),
@SerBeginDate INT, 
@SerEndDate INT,
@LangCode VARCHAR(5),
@LangName VARCHAR(50)
AS 

IF @SerName IS NULL OR @SerPopularity IS NULL OR @SerTotal IS NULL OR 
@SerOverview IS NULL OR @SerBeginDate IS NULL OR @LangCode IS NULL OR @LangName IS NULL 
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('one or more of your parameters are null', 11, 1)
    RETURN 
    END

DECLARE @LID INT 

EXECUTE GetLanguageID
@LanguageCode = @LangCode,
@LanguageName = @LangName,
@LanguageID  = @LID OUTPUT 

IF @LID IS NULL 
    BEGIN  
    PRINT 'LID cannot be null'
    RAISERROR ('LID is null', 11, 1)
    RETURN 
    END

BEGIN TRAN G1
    INSERT INTO tblSERIES (LanguageID, SeriesName, SeriesOverview, SeriesPopularity, SeasonTotal, SeriesBeginDate, SeriesEndDate)
    VALUES (@LID, @SerName, @SerOverview, @SerPopularity, @SerTotal, @SerBeginDate, @SerEndDate)
    IF @@ERROR <> 0
        ROLLBACK TRAN G1
    ELSE 
        COMMIT TRAN G1

GO 

--stored procedure num 2 ria
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

--computed column num 1 ria
--NUMBER OF CUSTOMERS WHO WATCH Parks and Rec in the comedy genre

CREATE FUNCTION fn_NumOfCustomersThatLikeToLaugh(@CustomerID INT)
RETURNS INT 
AS 
BEGIN 
    DECLARE @Ret INT = (
        SELECT SUM(C.CustomerID)
        FROM tblCUSTOMER C 
            JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID
            JOIN  tblDOWNLOAD_EPISODE DE ON  M.MembershipID = DE.MembershipID
            JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
            JOIN tblEpisode E ON PE.EpisodeID = E.EpisodeID
            JOIN tblEPISODE_GENRE EG ON E.EpisodeID = EG.EpisodeID
            JOIN tblGENRE G ON EG.GenreID = G.GenreID
        WHERE E.[EpisodeName] = 'Parks and Rec' AND G.GenreName = 'Comedy')
        RETURN @Ret
END 
GO 
ALTER TABLE tblCUSTOMER
ADD TotalFunnyPeople AS (dbo.fn_NumOfCustomersThatLikeToLaugh(CustomerID))
GO 

--computed column num 2 ria
--Number of memberships that have involved the use of both Netflix and Hulu

CREATE FUNCTION fn_NumOfMemsThatThinkNetAndHuluIsCool(@MembershipID INT)
RETURNS INT 
AS 
BEGIN 
    DECLARE @Ret INT = (
        SELECT SUM(M.MembershipID)
        FROM tblMEMBERSHIP M
            JOIN  tblDOWNLOAD_EPISODE DE ON  M.MembershipID = DE.MembershipID
            JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
            JOIN tblPLATFORM P ON PE.PlatformID = P.PlatformID
        WHERE P.[PlatformName] = 'Netflix' AND P.PlatformName = 'Hulu')
        RETURN @Ret
END 
GO 
ALTER TABLE tblCUSTOMER
ADD TotalPopularPlatformMems AS (dbo.fn_NumOfMemsThatThinkNetAndHuluIsCool(CustomerID))
GO 