<<<<<<< HEAD
CREATE DATABASE _BookDB
=======
<<<<<<< HEAD
<<<<<<< HEAD
CREATE DATABASE team13_BookDB
GO

USE team13_BookDB
=======
CREATE DATABASE team_13_BookDB
GO

USE team_13_BookDB
>>>>>>> mr-lab05
=======
CREATE DATABASE rosem15_BookDB
>>>>>>> 127ad3b3762e63fae9b15ee549a228e898b06aaa
GO

USE rosem15_BookDB
>>>>>>> 76d4ead1e073d3d33ed2cddb9efb9c204fcb4de1

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


<<<<<<< HEAD
<<<<<<< HEAD
Create PROCEDURE team13usp_insertBook
=======
Create PROCEDURE team_13usp_insertBook
>>>>>>> mr-lab05
=======
ALTER PROCEDURE rosem15usp_insertBook
>>>>>>> 76d4ead1e073d3d33ed2cddb9efb9c204fcb4de1
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


<<<<<<< HEAD
IF (SELECT genreID FROM tblGenre WHERE genreName = @genreName) IS NULL   
	INSERT INTO tblGenre (genreName) 
	VALUES (@genreName)


SET @G_ID = (SELECT GenreID FROM tblGenre WHERE genreName = @genreName) 

SET @G_ID = (SELECT SCOPE_IDENTITY()) 

BEGIN TRAN G1
=======
IF @G_ID IS NULL 
INSERT INTO tblGenre (genreName) 
VALUES (@genreName)

SET @G_ID = (SELECT SCOPE_IDENTITY()) 

BEGIN TRAN G1 
>>>>>>> 76d4ead1e073d3d33ed2cddb9efb9c204fcb4de1
INSERT INTO tblBook (bookTitle, bookPrice, bookDesc, genreID) 
VALUES (@bookTitle, @bookPrice, @bookDesc, @G_ID)

IF @@ERROR <> 0 
	ROLLBACK TRAN G1
ELSE 
	COMMIT TRAN G1
GO 
