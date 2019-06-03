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

CREATE FUNCTION fn_ageappropriatmembership()
RETURNS INT 
AS
BEGIN 
DECLARE @Ret INT = 0

IF EXISTS (SELECT * FROM tblPERSON P
            JOIN tblPERSON_CREDIT_EPISODE PC ON P.PersonID = PC.PersonID
            JOIN tblEPISODE EP ON PC.EpisodeID = EP.EpisodeID
            JOIN tblPLATFORM_EPISODE PE ON EP.EpisodeID = PE.EpisodeID
            JOIN tblDOWNLOAD_EPISODE DE ON PE.PlatformEpisodeID = DE.PlatformEpisodeID
            JOIN tblMEMBERSHIP M ON DE.MembershipID = M.MembershipID
            WHERE P.PersonDOB < (SELECT (GETDATE() - (365.25 * 13))) --AND G.GenreDescr = 'Horror'
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
-- Find all episodes in (Comedy) in (English) with (Matthew Perry)
/*CREATE VIEW [ActorInComediesInEnglish] AS 
SELECT E.EpisodeID, EpisodeName 
FROM tblEPISODE E 
JOIN tblEPISODE_GENRE EG ON E.EpisodeID = EG.EpisodeID
JOIN tblGENRE G ON EG.GenreID = G.GenreID
JOIN tblSERIES S ON E.SeriesID = S.SeriesID
JOIN tblLANGUAGE L ON S.LanguageID = L.LanguageID
JOIN tblPERSON_CREDIT_EPISODE PCE ON E.EpisodeID = PCE.EpisodeID
JOIN tblPERSON P ON PCE.PersonID = P.PersonID
WHERE G.GenreName = 'Comedy' AND P.PersonFname = 'Matthew' AND P.PersonLname = 'Perry'
AND L.LanguageName = 'English'

GO */

--stored procedure num 1 ria
CREATE PROCEDURE newseries
@EpName VARCHAR(30), 
@EpOverview VARCHAR(30), 
@EpRunTime DATE, 
@SerName VARCHAR(50),
@SerOverview VARCHAR(50),
@SerBeginDate DATE, 
@SerEndDate DATE
AS 

IF @EpName IS NULL OR @EpOverview IS NULL OR @EpRunTime IS NULL OR @SerName IS NULL OR 
@SerOverview IS NULL OR @SerBeginDate IS NULL OR @SerEndDate IS NULL 
    BEGIN 
    PRINT 'Parameters cannot be null'
    RAISERROR ('one or more of your parameters are null', 11, 1)
    RETURN 
    END

DECLARE @SID INT 

EXECUTE getSerID 
@SeriesNombre = @CFname, 
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
