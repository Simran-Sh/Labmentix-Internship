
/*
Staging Layer
-------------
 Need type conversion
 Need cleaning
Need deduplication
Need joins before warehouse load

If a table is small, clean, and simple → can skip staging
--------------
In staging: Store raw cleaned data and Avoid derived metrics
*/

Use iTunesMusic;

CREATE TABLE StgArtist -- Table 1
(
    ArtistId INT PRIMARY KEY,
    Name VARCHAR(200)
);GO


CREATE TABLE StgAlbum -- Table 2
(
    AlbumId INT PRIMARY KEY,
    Title VARCHAR(300),
    ArtistId INT
);

CREATE TABLE StgCustomer -- Table 3
(
   CustomerId INT PRIMARY KEY,
   FirstName NVARCHAR(80), -- supports Unicode
   LastName NVARCHAR(80),
   Company NVARCHAR(255),
   Address NVARCHAR(255),
   City NVARCHAR(100),
   State NVARCHAR(50),
   Country NVARCHAR(50),
   SupportRepId INT
);

CREATE TABLE StgEmployee -- Table 4
(
    EmployeeId INT PRIMARY KEY,
    LastName VARCHAR(100),
    FirstName VARCHAR(100),
    Title VARCHAR(200),
    ReportsTo INT,
    Levels VARCHAR(10),
    BirthDate DATE,
    HireDate DATE,
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
);GO

CREATE TABLE StgGenre -- Table 5
(
    GenreId INT PRIMARY KEY,
    Name VARCHAR(255)
);GO

CREATE TABLE StgInvoice -- Table 6
(
    InvoiceId INT PRIMARY KEY,
    CustomerId INT,
    InvoiceDate DATE,
    BillingAddress VARCHAR(255),
    BillingCity VARCHAR(100),
    BillingState VARCHAR(100),
    BillingCountry VARCHAR(100),
    Total DECIMAL(10,2) -- Invoice Total = SUM(UnitPrice × Quantity). Can be recalculated from InvoiceLine
);GO

CREATE TABLE StgInvoiceLine -- Table 7

(
    InvoiceLineId INT PRIMARY KEY,
    InvoiceId INT,
    TrackId INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT,
 );

 CREATE TABLE StgMediaType -- Table 8
(
    MediaId INT PRIMARY KEY,
    Name VARCHAR(300)
);

CREATE TABLE StgTrack -- Table 9
(
    TrackId INT PRIMARY KEY,
    Name VARCHAR(300),
    AlbumId INT,
    MediaTypeId INT,
    GenreId INT,
    Composer VARCHAR(500),
    Milliseconds INT,
    Bytes INT,
    UnitPrice DECIMAL(10,2)
);

-- Sanity Check
SELECT name 
FROM sys.tables
WHERE name LIKE 'Dim%' OR name LIKE 'Fact%';


/*
For revenue analytics,NOT NEEDED FOR NOW

CREATE TABLE StgPlaylistTrack -- Table 10
(
    PlaylistId INT,
    TrackId INT
);

CREATE TABLE StgPlaylist -- Table 11
(
    PlaylistId INT PRIMARY KEY,
    Name VARCHAR(200)
);