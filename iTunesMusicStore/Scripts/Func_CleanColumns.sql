
Use iTunesMusic;
-- Universal text cleaning function

CREATE OR ALTER FUNCTION dbo.fnCleanText (@Input VARCHAR(500))
RETURNS VARCHAR(500)
AS
BEGIN
    DECLARE @Clean VARCHAR(500)

    SET @Clean = LTRIM(RTRIM(@Input))

    -- Remove special characters
    SET @Clean = REPLACE(@Clean, '.', '')
    SET @Clean = REPLACE(@Clean, ',', '')
    SET @Clean = REPLACE(@Clean, '&', '')
    SET @Clean = REPLACE(@Clean, '-', ' ')
    SET @Clean = REPLACE(@Clean, '_', ' ')

    -- Lowercase
    SET @Clean = LOWER(@Clean)

    -- Capitalize Each Word
    DECLARE @Result VARCHAR(500) = ''
    DECLARE @Word VARCHAR(100)

    WHILE LEN(@Clean) > 0
    BEGIN
        SET @Word = LEFT(@Clean, CHARINDEX(' ', @Clean + ' ') - 1)

        SET @Result = @Result +
            UPPER(LEFT(@Word, 1)) +
            LOWER(SUBSTRING(@Word, 2, LEN(@Word))) + ' '

        SET @Clean = LTRIM(SUBSTRING(@Clean, LEN(@Word) + 1, LEN(@Clean)))
    END

    RETURN RTRIM(@Result)
END

-- UPDATE DimGenre SET Name = dbo.fnCleanText(Name);


-- Convert Column or/ any string to PascalCase
/*
CREATE FUNCTION dbo.fnToPascalCase (@Input VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @Output VARCHAR(255) = ''
    DECLARE @Word VARCHAR(100)
    
    WHILE LEN(@Input) > 0
    BEGIN
        SET @Word = LEFT(@Input, CHARINDEX(' ', @Input + ' ') - 1)
        
        SET @Output = @Output + 
            UPPER(LEFT(@Word, 1)) + 
            LOWER(SUBSTRING(@Word, 2, LEN(@Word)))
        
        SET @Input = LTRIM(SUBSTRING(@Input, LEN(@Word) + 1, LEN(@Input)))
    END
    
    RETURN @Output
END

*/
