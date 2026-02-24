
Use iTunesMusic;

/*
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'xp_cmdshell', 1; -- Enable xp_cmdshell (Need for Folder Read)
RECONFIGURE;

/*
----------------------------------------------------------------------
OPTION 1 - BULK UPLOAD FROM FOLDER WITHOUT TABLE CREATION EXPLICITLY |
----------------------------------------------------------------------
*/

CREATE TABLE #FileList --- Create Table to Store File Names
(
    FileName VARCHAR(255)
);

/*
-------------------------------
Get All CSV Files From Folder |
-------------------------------
*/
INSERT INTO #FileList
EXEC xp_cmdshell 'dir E:\LabMentixInternship\iTunesMusicStore\DataSets\*.csv /b';

 -- Remove all Nulls
DELETE FROM #FileList WHERE FileName IS NULL;

-- SANITY CHECK for 11 files
SELECT * FROM #FileList


-- BULK INSER INTO THE DATABASE RAW DATA
BULK INSERT SCRIPT 
DECLARE @FileName VARCHAR(355);
DECLARE @TableName VARCHAR(355);
DECLARE @SQL NVARCHAR(MAX);

DECLARE FileCursor CURSOR FOR
SELECT FileName FROM #FileList;

OPEN FileCursor;
FETCH NEXT FROM FileCursor INTO @FileName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Convert filename to Raw table name
    SET @TableName = 'Raw' + 
                     REPLACE(REPLACE(@FileName, '.csv', ''), '_', '');

    SET @SQL = '
        TRUNCATE TABLE ' + @TableName + ';
        BULK INSERT ' + @TableName + '
        FROM ''C:\AppleData\' + @FileName + '''
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''\n'',
            CODEPAGE = ''65001'',
            TABLOCK
        );';

    PRINT @SQL;
    EXEC sp_executesql @SQL;

    FETCH NEXT FROM FileCursor INTO @FileName;
END

CLOSE FileCursor;
DEALLOCATE FileCursor;

*/

/*
-----------------------------------------------------------
OPTION 2 - BULK UPLOAD after 11 TABLE CREATION EXPLICITLY |
-----------------------------------------------------------
*/
CREATE TABLE RawArtist -- Table 1
(
    ArtistId INT PRIMARY KEY,
    Name VARCHAR(200)
);


BULK INSERT RawArist
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\invoice.csv'
WITH
(
    FIRSTROW = 2,              -- Skip header
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'         -- UTF-8 (important for special characters)
);
GO
------------------------------------------------------------

CREATE TABLE RawAlbum -- Table 2
(
    AlbumId int PRIMARY KEY,
    Title VARCHAR(300),
    ArtistId int CONSTRAINT FK_RawArtist FOREIGN KEY(ArtistId) REFERENCES RawArtist(AristId)
);

-- Add Foreign Key separately

ALTER TABLE RawAlbum
ADD CONSTRAINT FK_Album_Artist
FOREIGN KEY (ArtistId)
REFERENCES DimArtist(ArtistId);


BULK INSERT RawAlbum
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\album.csv'
WITH
(
    FIRSTROW = 2,              -- Skip header and start reading data from the 2nd line of the file
    FIELDTERMINATOR = ',',     -- CSV (Comma-Separated Values) delimiter that defines the "divider" between columns
    ROWTERMINATOR = '\n',
    TABLOCK,                  -- "Bulk Update" lock on the entire table. Nobody else can write to or/ read from that table until the import is finished.
    CODEPAGE = '65001'         -- UTF-8 (important for special characters)
);
GO

-------------------------------------------------------------

CREATE TABLE RawCustomer -- Table 3
(
    
);
--------------------------------------------------------------

CREATE TABLE RawEmployee -- Table 4
(
);

CREATE TABLE RawGenre -- Table 5
(
)

CREATE TABLE RawInvoice -- Table 6
(
    InvoiceId INT,
    CustomerId INT,
    InvoiceDate DATETIME,
    BillingAddress VARCHAR(255),
    BillingCity VARCHAR(100),
    BillingState VARCHAR(100),
    BillingCountry VARCHAR(100),
    BillingPostalCode VARCHAR(20),
    Total DECIMAL(10,2)
);

BULK INSERT RawInvoice
FROM 'C:\Data\invoice.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

--------------------------------------------------------------

CREATE TABLE RawInvoiceLine -- Table 7
(
);

CREATE TABLE RawMediaType -- Table 8
(
);

CREATE TABLE RawPlaylist -- Table 9
(
);

CREATE TABLE RawPlaylistTrack -- Table 10
(
);

CREATE TABLE RawTrack -- Table 11
(
);



BULK INSERT RawInvoice
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\invoice.csv'
WITH
(
    FIRSTROW = 2,              -- Skip header
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'         -- UTF-8 (important for special characters)
);



