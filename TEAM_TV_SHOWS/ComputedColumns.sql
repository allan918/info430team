
/*Rias code*/
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

/*Xiefes Code*/
--How many episode of shows total for each language
Create Function Calculate_Languege_Episode(@LanguageID int)
returns Int
as 
Begin
Declare @Num int
Set @Num = (Select Count(*) from tblLANGUAGE as l Join tblSERIES as s on s.LanguageID = l.LanguageID
join tblEPISODE as e on e.SeriesID = s.SeriesID
Where l.LanguageID = @LanguageID)
return @Num
end
Go

Alter Table tblLanguage
Add Language_Episodes_Count as (dbo.Calculate_Languege_Episode(LanguageID))
Go
--How many times have customer download from netflix
Create function Calculate_download_netflix(@CustomerID int)
returns integer
as
Begin 
declare @times int
Set @times = (select count(*) from tblCUSTOMER as c join tblMEMBERSHIP as m on m.CustomerID = c.CustomerID
Join tblDOWNLOAD_EPISODE as de on de.MembershipID = m.MembershipID
join tblPLATFORM_EPISODE as pe on pe.PlatformEpisodeID = de.PlatformEpisodeID
join tblPLATFORM  as p on pe.PlatformID = p.PlatformID
Where p.PlatformName = 'Netflix' and C.CustomerID = @CustomerID)  
return @times
end
Go

Alter Table tblCustomer
Add Count_Download_Netflix as (dbo.Calculate_download_netflix(CustomerID))
Go
/*Malorys Code*/
CREATE FUNCTION fn_NumOfCustomersFromTexasWatchNetflix(@CustomerID INT)
RETURNS INT 
AS 
BEGIN 
    DECLARE @Ret INT = (
        SELECT SUM(C.CustomerID)
        FROM tblCUSTOMER C 
            JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID
            JOIN  tblDOWNLOAD_EPISODE DE ON  M.MembershipID = DE.MembershipID
            JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
            JOIN tblPLATFORM P ON PE.PlatformID = P.PlatformID
        WHERE C.[State] = 'Texas' AND P.PlatformName = 'Netflix')
        RETURN @Ret
END 
GO 
ALTER TABLE tblCUSTOMER
ADD TotalTexans AS (dbo.fn_NumOfCustomersFromTexasWatchNetflix(CustomerID))
GO 

CREATE FUNCTION fn_numberOfCustomersWatchGossipGirl(@CustomerID INT) 
RETURNS INT 
AS
BEGIN 
    DECLARE @Ret INT = (
        SELECT SUM(C.CustomerID)
        FROM tblCUSTOMER C
            JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID
            JOIN  tblDOWNLOAD_EPISODE DE ON  M.MembershipID = DE.MembershipID
            JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
            JOIN tblEPISODE E ON PE.EpisodeID = E.EpisodeID
            JOIN tblSERIES S ON E.SeriesID = S.SeriesID
        WHERE S.SeriesName = 'Gosip Girl')
    RETURN @Ret
END 
GO 

ALTER TABLE tblCUSTOMER 
ADD totalCustWatchGosipGirl AS (dbo.fn_numberOfCustomersWatchGossipGirl(CustomerID))
GO 
/*Madisens Code*/
-- 5) computed column: number of memberships that contained customers who were 18 and below
CREATE FUNCTION fn_NumOf18AndUnderMemberships(@CustomerID INT)
RETURNS INT 
AS
BEGIN 
    DECLARE @Ret INT = (
        SELECT SUM(C.CustomerID)
        FROM tblCUSTOMER C 
        JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID
    WHERE C.[CustDOB] <= GetDate() - (365.25*18))
    RETURN @Ret
END
GO

ALTER TABLE tblCUSTOMER 
ADD TotalNumMembers18AndUnder AS (dbo.fn_NumOf18AndUnderMemberships(CustomerID))
GO

-- 6) computed column: number of customers who watch any show to do with horror
ALTER FUNCTION fn_CustomersWhoWatchHorror(@CustomerID INT)

RETURNS INT 
AS 
BEGIN 
    DECLARE @Ret INT = (
        SELECT COUNT(*)
        FROM tblCUSTOMER C 
            JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID
            JOIN  tblDOWNLOAD_EPISODE DE ON  M.MembershipID = DE.MembershipID
            JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
            JOIN tblEpisode E ON PE.EpisodeID = E.EpisodeID
            JOIN tblEPISODE_GENRE EG ON E.EpisodeID = EG.EpisodeID
            JOIN tblGENRE G ON EG.GenreID = G.GenreID
        WHERE G.GenreName = 'Horror')
        RETURN @Ret
END 
GO 
ALTER TABLE tblCUSTOMER
ADD TotalCustomersWhoWatchHorror AS (dbo.fn_CustomersWhoWatchHorror(CustomerID))
GO 