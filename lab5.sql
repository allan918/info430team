-- build DB
CREATE DATABASE madireyn_BookDB
GO

USE madireyn_BookDB

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

-- build stored procedure to handle the insert of a single book
-- with proper error handling
CREATE PROCEDURE usp_insertBook
@bookTitle VARCHAR(256),
@bookPrice SMALLMONEY,
@bookDesc VARCHAR(4096),
@genreName VARCHAR(256)
AS

DECLARE @genreID INT

IF (SELECT genreID from tblGenre WHERE genreName = @genreName) is NULL
    insert into tblGenre(genreName)
    Values(@genreName)

SET @genreID = (Select genreID FROM tblGenre WHERE genreName = @genreName)

Begin TRAN
    Insert Into tblBook(bookTitle, bookPrice, bookDesc, genreID)
    Values(@bookTitle, @bookPrice, @bookDesc, @genreID)

If @@ERROR <> 0
    ROLLBACK TRAN
ELSE
    COMMIT TRAN
GO
