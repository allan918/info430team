CREATE DATABASE TV_SHOWS 
Use TV_SHOWS
CREATE TABLE tblLANGUAGE (LanguageID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                            LanguageCode VARCHAR(5) NOT NULL, 
                            LanguageName VARCHAR(50) NOT NULL)
GO 
Create TABLE tblSERIES (SeriesID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                        LanguageID INT FOREIGN KEY REFERENCES tblLANGUAGE (LanguageID) NOT NULL, 
                        SeriesName VARCHAR(100) NOT NULL, 
                        SeriesOverview VARCHAR(500) NOT NULL, 
                        SeriesPopularity INT NULL, 
                        SeasonTotal INT NOT NULL, 
                        SeriesBeginDate int NOT NULL, 
                        SeriesEndDate int NULL)
GO 
CREATE TABLE tblEPISODE (EpisodeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                        SeriesID INT FOREIGN KEY REFERENCES tblSERIES (SeriesID) NOT NULL, 
                        EpisodeName VARCHAR(100) NOT NULL, 
                        EpisodeOverview VARCHAR(500) NOT NULL, 
                        EpisodeRuntime INT NOT NULL, 
                        BroadcastDate DATE)
GO 
CREATE TABLE tblGENRE (GenreID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                        GenreName VARCHAR(100) NOT NULL,
                        GenreDescr VARCHAR(150) NULL)
GO 
CREATE TABLE tblEPISODE_GENRE (EpisodeGenreID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
                                EpisodeID INT FOREIGN KEY REFERENCES tblEPISODE (EpisodeID) NOT NULL, 
                                GenreID INT FOREIGN KEY REFERENCES tblGENRE (GenreID) NOT NULL)
GO 
CREATE TABLE tblGENDER (GenderID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                        GenderName CHAR(1) NOT NULL)
GO 
CREATE TABLE tblPERSON (PersonID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                        PersonFname VARCHAR(30) NOT NULL, 
                        PersonLname VARCHAR(30) NOT NULL, 
                        PersonDOB DATE NOT NULL, 
                        GenderID INT FOREIGN KEY REFERENCES tblGENDER (GenderID) NOT NULL,
                        PersonBiography VARCHAR(500) NULL, 
                        PersonPopularity INT NULL)
GO 
CREATE TABLE tblCREDIT (CreditID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                        CreditName VARCHAR(50) NOT NULL, 
                        CreditDescr VARCHAR(150) NULL)
GO 
CREATE TABLE tblPERSON_CREDIT_EPISODE (PersonCreditEpisodeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                                    EpisodeID INT FOREIGN KEY REFERENCES tblEPISODE (EpisodeID) NOT NULL, 
                                    CreditID INT FOREIGN KEY REFERENCES tblCREDIT (CreditID) NOT NULL, 
                                    PersonID INT FOREIGN KEY REFERENCES tblPERSON (PersonID) NOT NULL,
                                    [Character] VARCHAR(50) NOT NULL)
GO 
CREATE TABLE tblPLATFORM (PlatformID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                        PlatformName VARCHAR(50) NOT NULL, 
                        PlatformDescr VARCHAR(150) NOT NULL)
GO 
CREATE TABLE tblPLATFORM_EPISODE (PlatformEpisodeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                                PlatformID INT FOREIGN KEY REFERENCES tblPLATFORM (PlatformID) NOT NULL,
                                EpisodeID INT FOREIGN KEY REFERENCES tblEPISODE (EpisodeID) NOT NULL)
GO 
CREATE TABLE tblCUSTOMER (CustomerID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                            CustFname VARCHAR(30) NOT NULL, 
                            CustLname VARCHAR(30) NOT NULL, 
                            CustDOB DATE NOT NULL, 
                            [Address] VARCHAR(50) NOT NULL, 
                            [State] VARCHAR(50) NOT NULL, 
                            City VARCHAR(50)NOT NULL, 
                            PostalCode CHAR(9) NOT NULL, 
                            Country VARCHAR(50) NOT NULL)
GO
CREATE TABLE tblMEMBERSHIP (MembershipID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                            CustomerID INT FOREIGN KEY REFERENCES tblCUSTOMER NOT NULL, 
                            MembershipName VARCHAR(50) NOT NULL,
                            MembershipDescr VARCHAR(150) NOT NULL, 
                            MembershipPrice NUMERIC(8,2) NOT NULL, 
                            BeginDate DATETIME NOT NULL, 
                            EndDate DATETIME NULL)
GO

CREATE TABLE tblDOWNLOAD_EPISODE (DownloadEpisodeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                                PlatformEpisodeID INT FOREIGN KEY REFERENCES tblPLATFORM_EPISODE (PlatformEpisodeID) NOT NULL, 
                                MembershipID INT FOREIGN KEY REFERENCES tblMEMBERSHIP (MembershipID) NOT NULL, 
                                DownloadDateTime DATETIME NOT NULL)
GO
CREATE TABLE tblSURVEY (SurveyID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                        SurveyDate DATETIME NOT NULL)
GO 
CREATE TABLE tblQUESTION_TYPE (QuestionTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                                QuestionTypeName VARCHAR(50) NOT NULL, 
                                QuestionTypeDescr VARCHAR(100) NULL)
GO 
CREATE TABLE tblQUESTION (QuestionID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                        QuestionTypeID INT FOREIGN KEY REFERENCES tblQUESTION_TYPE NOT NULL, 
                        QuestionDate DATETIME NOT NULL, 
                        QuestionName VARCHAR(150) NOT NULL)
GO
CREATE TABLE tblSURVEY_QUESTION (SurveyQuestionID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                                SurveyID INT FOREIGN KEY REFERENCES tblSURVEY NOT NULL, 
                                QuestionID INT FOREIGN KEY REFERENCES tblQUESTION (QuestionID) NOT NULL)       
GO 
CREATE TABLE tblCUSTOMER_SURVEY_RESPONSE (CustomerSurveyResponseID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
                                        CustomerID INT FOREIGN KEY REFERENCES tblCUSTOMER (CustomerID) NOT NULL, 
                                        SurveyQuestionID INT FOREIGN KEY REFERENCES tblSURVEY_QUESTION (SurveyQuestionID) NOT NULL,
                                        Response VARCHAR(250) NOT NULL)
GO                                                                               
