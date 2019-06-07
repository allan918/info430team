USE Group13_TV_SHOWS
GO 

/*Malory's Code*/

-- business rule 1
--Can only watch Netflix if country is not the US
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
GO 

-- business rule 2
-- If you are from Florida you cannot watch a horror movie unless you are  18 or older
CREATE FUNCTION fn_NonHorroMoviesUnder18inFLorida()
RETURNS INT 
AS 
BEGIN 
DECLARE @Ret INT = 0
IF EXISTS (SELECT * FROM tblCUSTOMER C 
            JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID
            JOIN tblDOWNLOAD_EPISODE DE ON M.MembershipID = DE.MembershipID
            JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
            JOIN tblEPISODE E ON PE.EpisodeID = E.EpisodeID
            JOIN tblEPISODE_GENRE EG ON E.EpisodeID = EG.EpisodeID
            JOIN tblGENRE G ON EG.GenreID = G.GenreID
            WHERE C.[State] = 'FL' AND C.CustDOB = (SELECT GETDATE() - (365.25 * 18))
            AND G.GenreName = 'Horror')
            BEGIN 
            SET @Ret = 1
            END 
    RETURN @Ret
END 
GO 
ALTER TABLE tblDOWNLOAD_EPISODE 
ADD CONSTRAINT CK_NoHorrorMoviesInFloridaUnder18
CHECK (dbo.fn_NonHorroMoviesUnder18inFLorida() = 0) 
GO 

/*Madisen's code*/

--business rule: users from Spain can only use Hulu or Netflix
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

-- business rule: users from Germany can only use platforms if they became a member before 2015
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

/*Ria's code*/

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
            WHERE P.PersonDOB > (SELECT (GETDATE() - (365.25 * 16))) AND G.GenreDescr = 'Horror')
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
            JOIN tblEPISODE_GENRE EG ON EP.EpisodeID = EG.EpisodeID
            JOIN tblGENRE G ON EG.GenreID = G.GenreID
            WHERE P.PersonDOB < (SELECT (GETDATE() - (365.25 * 13))) AND G.GenreDescr = 'Horror')
    BEGIN 
    SET @Ret = 1
    END 
RETURN @Ret
END
GO 
ALTER TABLE tblMEMBERSHIP
ADD CONSTRAINT CK_ageappropriatemembership
CHECK (dbo.fn_ageappropriatmembership() = 0) 
GO 

/*Xiefi's Code*/

--If you were between the age 18 and 25 then you are not permitted to download a movie between 0 to 4am
CREATE function No_15_25_downlaod_movie_past_12()
returns int
AS
BEGIN
DECLARE @Ret INT = 0
if exists (select * from tblCUSTOMER as c join tblMEMBERSHIP as m on c.CustomerID = m.CustomerID
join tblDOWNLOAD_EPISODE as de on de.MembershipID = m.MembershipID
Where (datediff(year, GETDATE(), c.CustDOB) between 18 and 25) and (cast(de.DownloadDateTime as time) between '0:00' and '4:00'))
BEGIN
SET @Ret = 1
END
RETURN @Ret
END
GO
Alter table tblDOWNLOAD_EPISODE
add
constraint No_15_25_downlaod_movie_past_mid
check (dbo.No_15_25_downlaod_movie_past_12() = 0)
Go

-- If you are from washington state and have a membership record less than a year, you cannot answer survey question
Create function No_WA_Survey_Membership_less_than_1()
returns int 
as
begin 
declare @Ret int = 0
if exists (
select * from tblCUSTOMER as c
join tblMEMBERSHIP as m
on m.CustomerID = c.CustomerID
where c.State = 'WA' and (datediff(year, m.EndDate, m.BeginDate) < 1) )
BEGIN
SET @Ret = 1
END
RETURN @Ret
END
GO
Alter table tblCUSTOMER_SURVEY_RESPONSE
Add constraint No_WA_Survey_Membership_less_than_1_year
check (dbo.No_WA_Survey_Membership_less_than_1() = 0)
Go
