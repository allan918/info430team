USE Group13_TV_SHOWS

INSERT INTO tblGENDER (GenderName)
VALUES ('F'), ('M')

INSERT INTO tblPLATFORM (PlatformName, PlatformDescr)
VALUES ('Netflix', 'A media streaming service for poeple to watch a wide variety of TV shows across the world.'),
('Hulu', 'A way to stream many TV shows in one place.'), ('Amazon Prime Videos', 'A Streaming service for Amazon Members. ')

INSERT INTO tblQUESTION_TYPE (QuestionTypeName, QuestionTypeDescr)
VALUES ('Short Answer', 'Less then 50 words.'), ('Long Answer', 'More then 50 words.'), 
('Multiple Choice', 'Give many choices to user.'), ('Check all that apply', 'Allows one to choose more then one answer.')

INSERT INTO tblQUESTION (QuestionName, QuestionTypeID)
VALUES ('Around what time do you typically watch TV?', (SELECT QuestionTypeID FROM tblQUESTION_TYPE WHERE QuestionTypeName = 'Multiple Choice')), 
('What is your go to genre?', (SELECT QuestionTypeID FROM tblQUESTION_TYPE WHERE QuestionTypeName = 'Check all that apply')), 
('How many hours do you typically watch TV a day?', (SELECT QuestionTypeID FROM tblQUESTION_TYPE WHERE QuestionTypeName = 'Short Answer')), 
('What is your top 5 favorite TV shows?', (SELECT QuestionTypeID FROM tblQUESTION_TYPE WHERE QuestionTypeName = 'Long Answer')), 
('Where do you typically watch TV?', (SELECT QuestionTypeID FROM tblQUESTION_TYPE WHERE QuestionTypeName = 'Multiple Choice'))

INSERT INTO tblPLATFORM (PlatformName, PlatformDescr)
VALUES ('Pluto TV', 'An online streaming service to watch your favorite TV shows'), 
('Sling', 'Online media to stream your TV')
