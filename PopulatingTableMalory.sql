USE TV_SHOWS

INSERT INTO tblPLATFORM (PlatformName, PlatformDescr)
VALUES ('Netflix', 'A media streaming service for poeple to watch a wide variety of TV shows across the world.'),
('Hulu', 'A way to stream many TV shows in one place.'), ('Amazon Prime Videos', 'A Streaming service for Amazon Members. ')

INSERT INTO tblQUESTION_TYPE (QuestionTypeName, QuestionTypeDescr)
VALUES ('Short Answer', 'Less then 50 words.'), ('Long Answer', 'More then 50 words.'), 
('Multiple Choice', 'Give many choices to user.'), ('Check all that apply', 'Allows one to choose more then one answer.')

INSERT INTO tblQUESTION (QuestionName, QuestionDate, QuestionTypeID)
VALUES ('At what time do you typically watch TV?', '')
