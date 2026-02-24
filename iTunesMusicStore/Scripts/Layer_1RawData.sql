
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

Purpose: Store source as-is in Raw Layer. 
-------------------------------------------------------------------------------
OPTION 2 - BULK UPLOAD after 11 TABLE CREATION EXPLICITLY | Raw = data archive |
-------------------------------------------------------------------------------
*/
CREATE TABLE RawArtist -- Table 1
(
    ArtistId INT PRIMARY KEY,
    Name VARCHAR(200)
);GO

-- Bulk Upload data to Table 1
BULK INSERT RawArtist
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\artist.csv'
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
    ArtistId INT
    CONSTRAINT FK_RawArtist FOREIGN KEY(ArtistId) REFERENCES RawArtist(ArtistId)
);

/* Add Foreign Key separately

ALTER TABLE RawAlbum
ADD CONSTRAINT FK_Album_Artist
FOREIGN KEY (ArtistId)
REFERENCES DimArtist(ArtistId);
*/

BULK INSERT RawAlbum
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\album.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,              -- Skip header and start reading data from the 2nd line of the file
    FIELDTERMINATOR = ',',     -- CSV (Comma-Separated Values) delimiter that defines the "divider" between columns
    FIELDQUOTE = '"',           -- CSV Contains "50" (quoted number), 50 (trailing space), blank value, etc
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',         -- UTF-8 (important for special characters)
    ERRORFILE = 'E:\LabMentixInternship\error_rows.log', -- SQL creates an error file with bad rows
    MAXERRORS = 100,
    TABLOCK                  -- "Bulk Update" lock on the entire table. Nobody else can write to or/ read from that table until the import is finished.
);
GO

Select * from RawAlbum
-------------------------------------------------------------

CREATE TABLE RawCustomer -- Table 3
(
   CustomerId INT PRIMARY KEY,
   FirstName NVARCHAR(80), -- supports Unicode
   LastName NVARCHAR(80),
   Company NVARCHAR(255),
   Address NVARCHAR(255),
   City NVARCHAR(100),
   State NVARCHAR(50),
   Country NVARCHAR(50),
   PostalCode NVARCHAR(30),
   Phone NVARCHAR(50),
   Fax NVARCHAR(50),
   Email NVARCHAR(75),
   SupportRepId INT,
);

BULK INSERT RawCustomer
FROM "E:\LabMentixInternship\iTunesMusicStore\DataSets\customer.csv"
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,              -- Skip header and start reading data from the 2nd line of the file
    FIELDTERMINATOR = ',',     -- CSV (Comma-Separated Values) delimiter that defines the "divider" between columns
    FIELDQUOTE = '"',           -- CSV Contains "50" (quoted number), 50 (trailing space), blank value, etc
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',         -- UTF-8 (important for special characters)
    ERRORFILE = 'E:\LabMentixInternship\error_rows.log', -- SQL creates an error file with bad rows
    MAXERRORS = 100,
    TABLOCK                  -- "Bulk Update" lock on the entire table. Nobody else can write to or/ read from that table until the import is finished.
);
GO

Select * from RawCustomer;
--------------------------------------------------------------

CREATE TABLE RawEmployee -- Table 4
(
    EmployeeId VARCHAR(50),
    LastName VARCHAR(100),
    FirstName VARCHAR(100),
    Title VARCHAR(200),
    ReportsTo VARCHAR(50),
    Levels VARCHAR(10),
    BirthDate VARCHAR(50),
    HireDate VARCHAR(50),
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    PostalCode VARCHAR(20),
    Phone VARCHAR(50),
    Fax VARCHAR(50),
    Email VARCHAR(200)
);GO

BULK INSERT RawEmployee
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\employee.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',     
    FIELDQUOTE = '"',           
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001', 
    TABLOCK                
);
GO
Select * from RawEmployee;
--------------------------------------------------------------

CREATE TABLE RawGenre -- Table 5
(
    GenreId INT PRIMARY KEY,
    Name VARCHAR(255)
);GO

BULK INSERT RawGenre
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\genre.csv'
WITH
(
    FIRSTROW = 2,              -- Skip header
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'         -- UTF-8 (important for special characters)
);
Select * from RawGenre;
--------------------------------------------------------------

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
);GO

BULK INSERT RawInvoice
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\invoice.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,              -- Skip header and start reading data from the 2nd line of the file
    FIELDTERMINATOR = ',',     -- CSV (Comma-Separated Values) delimiter that defines the "divider" between columns
    FIELDQUOTE = '"',           -- CSV Contains "50" (quoted number), 50 (trailing space), blank value, etc
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',         -- UTF-8 (important for special characters)
    ERRORFILE = 'E:\LabMentixInternship\error_rows.log', -- SQL creates an error file with bad rows
    MAXERRORS = 100,
    TABLOCK    
);

Select * from RawInvoice;
--------------------------------------------------------------

CREATE TABLE RawInvoiceLine -- Table 7

(
    InvoiceLineId INT PRIMARY KEY,
    InvoiceId INT,
    TrackId INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT
 );

BULK INSERT RawInvoiceLine
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\invoice_line.csv'
WITH
(
    FIRSTROW = 2,              -- Skip header
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'         -- UTF-8 (important for special characters)
);
Select * from RawInvoiceLine;

--------------------------------------------------------------

CREATE TABLE RawMediaType -- Table 8
(
    RawMediaId INT PRIMARY KEY,
    Name VARCHAR(300)
);

BULK INSERT RawMediaType
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\media_type.csv'
WITH
(
    FIRSTROW = 2,              -- Skip header
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'         -- UTF-8 (important for special characters)
);
Select * from RawMediaType;

--------------------------------------------------------------

CREATE TABLE RawPlaylist -- Table 9
(
    PlaylistId INT PRIMARY KEY,
    Name VARCHAR(200)
);

BULK INSERT RawPlaylist
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\playlist.csv'
WITH
(
    FIRSTROW = 2,              -- Skip header
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'         -- UTF-8 (important for special characters)
);
Select * from RawPlaylist;

--------------------------------------------------------------

CREATE TABLE RawTrack -- Table 10
(
    TrackId VARCHAR(50),
    Name VARCHAR(300),
    AlbumId VARCHAR(50),
    MediaTypeId VARCHAR(50),
    GenreId VARCHAR(50),
    Composer VARCHAR(500),
    Milliseconds VARCHAR(50),
    Bytes VARCHAR(50),       
    UnitPrice DECIMAL(10,2)
);

BULK INSERT RawTrack
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\track.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK   
);

Select * from RawTrack;
--------------------------------------------------------------

CREATE TABLE RawPlaylistTrack -- Table 11
(
    PlaylistId INT,
    TrackId VARCHAR(50)
);

BULK INSERT RawPlaylistTrack
FROM 'E:\LabMentixInternship\iTunesMusicStore\DataSets\playlist_track.csv'
WITH
(
    FIRSTROW = 2,              -- Skip header
    FIELDTERMINATOR = ',',     -- CSV delimiter
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'         -- UTF-8 (important for special characters)
);
Select * from RawPlaylistTrack;

--------------------------------------------------------------

-- SANITY CHECK

SELECT name 
FROM sys.tables
WHERE name LIKE 'Raw%';

SELECT COUNT(*) FROM RawArtist;
SELECT COUNT(*) FROM RawAlbum;
SELECT COUNT(*) FROM RawCustomer;
SELECT COUNT(*) FROM RawEmployee;
SELECT COUNT(*) FROM RawGenre;
SELECT COUNT(*) FROM RawInvoice;
SELECT COUNT(*) FROM RawInvoiceLine;
SELECT COUNT(*) FROM RawMediaType;
SELECT COUNT(*) FROM RawTrack;