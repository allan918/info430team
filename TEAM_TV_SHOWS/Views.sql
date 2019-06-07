USE Group13_TV_SHOWS
GO 

/*Malory's Code*/

-- View 1
-- Find all the customers from (United Kingdom) that watched (Friends) on netflix
CREATE VIEW [UnitedKingdomCustomers] AS 
SELECT C.CustomerID, CustFname, CustLname
FROM tblCUSTOMER C 
JOIN tblMEMBERSHIP M ON C.CustomerID = M.CustomerID
JOIN tblDOWNLOAD_EPISODE DE ON M.MembershipID = DE.MembershipID
JOIN tblPLATFORM_EPISODE PE ON DE.PlatformEpisodeID = PE.PlatformEpisodeID
JOIN tblPLATFORM P ON PE.PlatformID = P.PlatformID
JOIN tblEPISODE E ON PE.EpisodeID = E.EpisodeID
JOIN tblSERIES S ON E.SeriesID = S.SeriesID
WHERE C.Country = 'United Kingdom' AND S.SeriesName = 'Friends'
AND P.PlatformName = 'Netflix'
GO

--View 2
-- Find all episodes in (Comedy) in (English) with (Matthew Perry)
CREATE VIEW [ActorInComediesInEnglish] AS 
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
GO 

/*Madisen's Code*/

--view: find all episodes in action with James Bond 
CREATE VIEW [JamesBondEpisodeNames] AS 
SELECT EpisodeName
FROM tblPERSON P
JOIN tblPERSON_CREDIT_EPISODE PCE ON P.PersonID = PCE.PersonID
JOIN tblEPISODE E ON PCE.EpisodeID = E.EpisodeID
WHERE P.PersonFName = 'James' AND P.PersonLname = 'Bond'
GO

--view: find customers who are 20 and watch romance shows that have Blake Lively in it 
CREATE VIEW [BlakeLivelyFans] AS
SELECT P.PersonID, PersonFname, PersonLname 
FROM tblPERSON P
JOIN tblPERSON_CREDIT_EPISODE PCE ON P.PersonID = PCE.PersonID
JOIN tblEPISODE E ON PCE.EpisodeID = E.EpisodeID
JOIN tblEPISODE_GENRE EG ON E.EpisodeID = EG.EpisodeID
JOIN tblGENRE G ON EG.GenreID = G.GenreID
WHERE P.PersonFName = 'Blake' AND P.PersonLname = 'Lively'
AND G.GenreName = 'Romance'
GO 

/*Ria's Code*/

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
CREATE VIEW [TheRockOnNetflix2] AS 
SELECT P.PersonID, P.PersonFname, P.PersonLname 
FROM tblPERSON P
JOIN tblPERSON_CREDIT_EPISODE PCE ON P.PersonID = PCE.PersonID
JOIN tblEPISODE E ON PCE.EpisodeID = E.EpisodeID
JOIN tblPLATFORM_EPISODE PE ON E.EpisodeID = PE.EpisodeID
JOIN tblPLATFORM PL ON PE.PlatformID = PL.PlatformID
WHERE P.PersonFName = 'The' AND P.PersonLname = 'Perry'
AND PL.PlatformName = 'Netflix'
GO 

/*Xiefi's Code*/

--Find ranking of count episodes of each language(Xifei Done)
Create View [Rank_Language_Episodes]
as
Select Rank() over (Order by Count(*)) as [Rank], l.LanguageName from tblLANGUAGE as l Join tblSERIES as s on s.LanguageID = l.LanguageID
join tblEPISODE as e on e.SeriesID = s.SeriesID
Group by LanguageName
GO 

--Find dense ranking of show by their sum runtime 
Create --drop
View [dense_ranking_runtime_show]
as
Select DENSE_RANK() over (Order by Sum( 
( DATEPART(hh, e.EpisodeRuntime ) * 3600 ) +
       ( DATEPART(mi, e.EpisodeRuntime ) * 60 ) +
         DATEPART(ss, e.EpisodeRuntime )
)) as Ranking, t.SeriesName from tblSERIES as t
join tblEPISODE as e on t.SeriesID = e.SeriesID
group by t.SeriesID, t.SeriesName