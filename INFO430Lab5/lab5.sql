CREATE DATABASE team13_BookDB
GO

USE team13_BookDB

CREATE TABLE tblGenre (
genreID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
genreName VARCHAR(256) NOT NULL,
genreDesc VARCHAR(4096) NULL
)

GO

CREATE TABLE tblBook (
bookID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
bookTitle VARCHAR(256) NOT NULL,
bookPrice SMALLMONEY NULL,
bookDesc VARCHAR(4096) NULL,
genreID INT FOREIGN KEY REFERENCES tblGenre(genreID)
)


Create PROCEDURE team13usp_insertBook
@bookTitle VARCHAR(256),
@bookPrice SMALLMONEY,
@bookDesc VARCHAR(4096),
@genreName VARCHAR(256)
AS
DECLARE @G_ID INT 

IF @bookTitle IS NULL OR @bookPrice IS NULL OR @genreName IS NULL 
BEGIN
PRINT 'parameters must have a value'
RAISERROR ('parameters cannot be NULL', 11, 1) 
RETURN
END

SET @G_ID = (SELECT GenreID FROM tblGenre WHERE genreName = @genreName) 

BEGIN TRAN G1

INSERT INTO tblGenre (genreName) 
VALUES (@genreName)

SET @G_ID = (SELECT SCOPE_IDENTITY()) 

INSERT INTO tblBook (bookTitle, bookPrice, bookDesc, genreID) 
VALUES (@bookTitle, @bookPrice, @bookDesc, @G_ID)

IF @@ERROR <> 0 
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1
GO 
