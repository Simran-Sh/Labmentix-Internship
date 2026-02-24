
/*
Purpose of WAREHOUSE Layer: Business logic decides final schema
-----------------------------------------------
| STORED PROCEDURE TO LOAD DATA TO STG TABLES |
-----------------------------------------------
*/

Use iTunesMusic;

CREATE TABLE DimArtist
(
    ArtistKey INT IDENTITY PRIMARY KEY,
    ArtistId INT,
    ArtistName VARCHAR(200)
);

CREATE TABLE DimGenre
(
    GenreKey INT IDENTITY PRIMARY KEY,
    GenreId INT,
    GenreName VARCHAR(255)
);

CREATE TABLE DimMediaType
(
    MediaTypeKey INT IDENTITY PRIMARY KEY,
    MediaTypeId INT,
    MediaTypeName VARCHAR(255)
);

CREATE TABLE DimAlbum -- → FK to DimArtist
(
    AlbumKey INT IDENTITY PRIMARY KEY,
    AlbumId INT,
    AlbumTitle VARCHAR(300),
    ArtistKey INT
        CONSTRAINT FK_DimAlbum_Artist
        FOREIGN KEY REFERENCES DimArtist(ArtistKey)
);

CREATE TABLE DimTrack -- Snowflake with → FK to Album, Genre, MediaType
(
    TrackKey INT IDENTITY PRIMARY KEY,
    TrackId INT,
    TrackName VARCHAR(300),
    AlbumKey INT
        CONSTRAINT FK_DimTrack_Album
        FOREIGN KEY REFERENCES DimAlbum(AlbumKey),
    GenreKey INT
        CONSTRAINT FK_DimTrack_Genre
        FOREIGN KEY REFERENCES DimGenre(GenreKey),
    MediaTypeKey INT
        CONSTRAINT FK_DimTrack_MediaType
        FOREIGN KEY REFERENCES DimMediaType(MediaTypeKey),
    Composer VARCHAR(500),
    Milliseconds INT,
    Bytes INT,
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE DimEmployee
(
    EmployeeKey INT IDENTITY PRIMARY KEY,
    EmployeeId INT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Title VARCHAR(200),
    HireDate DATE
);

CREATE TABLE DimCustomer -- → FK to Employee
(
    CustomerKey INT IDENTITY PRIMARY KEY,
    CustomerId INT,
    FirstName VARCHAR(80),
    LastName VARCHAR(80),
    Country VARCHAR(50),
    City VARCHAR(100),
    EmployeeKey INT -- SupportRepId logically belongs to employee but doNOT store SupportRepId.Instead store EmployeeKey INT
        CONSTRAINT FK_DimCustomer_Employee
        FOREIGN KEY REFERENCES DimEmployee(EmployeeKey)
);

CREATE TABLE DimDate
(
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Month INT,
    MonthName VARCHAR(20),
    Quarter INT
);

CREATE TABLE FactSales -- → FK to: DateKey CustomerKey TrackKey EmployeeKey
(
    SalesKey INT IDENTITY PRIMARY KEY,
    DateKey INT
        CONSTRAINT FK_FactSales_Date
        FOREIGN KEY (DateKey)
        REFERENCES DimDate(DateKey),
    CustomerKey INT
        CONSTRAINT FK_FactSales_Customer
        FOREIGN KEY (CustomerKey)
        REFERENCES DimCustomer(CustomerKey),
    TrackKey INT
        CONSTRAINT FK_FactSales_Track
        FOREIGN KEY (TrackKey)
        REFERENCES DimTrack(TrackKey),
    EmployeeKey INT
        CONSTRAINT FK_FactSales_Employee
        FOREIGN KEY (EmployeeKey)
        REFERENCES DimEmployee(EmployeeKey),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Revenue DECIMAL(10,2)
);

SELECT name
FROM sys.tables
WHERE name LIKE 'Dim%' OR name LIKE 'Fact%';

Select count(*) from DimEmployee;
SELECT COUNT(*) FROM DimArtist;
SELECT COUNT(*) FROM DimAlbum;
SELECT COUNT(*) FROM DimTrack;
SELECT COUNT(*) FROM DimCustomer;
SELECT COUNT(*) FROM FactSales;

/*
ALTER TABLE FactSales
ADD CONSTRAINT FK_FactSales_Date
FOREIGN KEY (DateKey)
REFERENCES DimDate(DateKey);

ALTER TABLE FactSales
ADD CONSTRAINT FK_FactSales_Customer
FOREIGN KEY (CustomerKey)
REFERENCES DimCustomer(CustomerKey);

ALTER TABLE FactSales
ADD CONSTRAINT FK_FactSales_Track
FOREIGN KEY (TrackKey)
REFERENCES DimTrack(TrackKey);

ALTER TABLE FactSales
ADD CONSTRAINT FK_FactSales_Employee
FOREIGN KEY (EmployeeKey)
REFERENCES DimEmployee(EmployeeKey);

*/

/*
-----------------------------------------------
| STORED PROCEDURE TO LOAD DATA TO STG TABLES |
-----------------------------------------------
*/

CREATE OR ALTER PROCEDURE dbo.uspLoadWarehouse
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProcName VARCHAR(100) = 'uspLoadWarehouse';
    DECLARE @RowsAffected INT;

    BEGIN TRY

        ------------------------------------------------
        -- LOG START
        ------------------------------------------------
        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message)
        VALUES (@ProcName, 'START', 'RUNNING', 'Warehouse Load Started');

        /*
   
        TRUNCATE cannot run on parent tables that are referenced.
        SQL blocks TRUNCATE with FK existence

        DELETE works with foreign keys (as long as child rows removed first).
        */
        ------------------------------------------------
        -- TRUNCATE FACT FIRST (child)
        ------------------------------------------------
        DELETE FROM FactSales; -- Fact table first

        ------------------------------------------------
        -- TRUNCATE DIMENSIONS
        ------------------------------------------------
        
        DELETE FROM DimTrack; -- References Album, Genre, MediaType
        DELETE FROM DimAlbum; -- References Artist
        DELETE FROM DimArtist;
        DELETE FROM DimGenre;
        DELETE FROM DimMediaType;
        DELETE FROM DimCustomer; -- References Employee
        DELETE FROM DimEmployee;
        DELETE FROM DimDate;

        ------------------------------------------------
        -- LOAD DIM ARTIST
        ------------------------------------------------
        INSERT INTO DimArtist (ArtistId, ArtistName)
        SELECT ArtistId, Name
        FROM StgArtist;

        ------------------------------------------------
        -- LOAD DIM GENRE
        ------------------------------------------------
        INSERT INTO DimGenre (GenreId, GenreName)
        SELECT GenreId, Name
        FROM StgGenre;

        ------------------------------------------------
        -- LOAD DIM MEDIATYPE
        ------------------------------------------------
        INSERT INTO DimMediaType (MediaTypeId, MediaTypeName)
        SELECT MediaId, Name
        FROM StgMediaType;

        ------------------------------------------------
        -- LOAD DIM ALBUM
        ------------------------------------------------
        INSERT INTO DimAlbum (AlbumId, AlbumTitle, ArtistKey)
        SELECT 
            a.AlbumId,
            a.Title,
            da.ArtistKey
        FROM StgAlbum a
        JOIN DimArtist da ON a.ArtistId = da.ArtistId;

        ------------------------------------------------
        -- LOAD DIM TRACK
        ------------------------------------------------
        INSERT INTO DimTrack
        (
            TrackId, TrackName,
            AlbumKey, GenreKey, MediaTypeKey,
            Composer, Milliseconds, Bytes, UnitPrice
        )
        SELECT
            t.TrackId,
            t.Name,
            da.AlbumKey,
            dg.GenreKey,
            dm.MediaTypeKey,
            t.Composer,
            t.Milliseconds,
            t.Bytes,
            t.UnitPrice
        FROM StgTrack t
        JOIN DimAlbum da ON t.AlbumId = da.AlbumId
        JOIN DimGenre dg ON t.GenreId = dg.GenreId
        JOIN DimMediaType dm ON t.MediaTypeId = dm.MediaTypeId;

        ------------------------------------------------
        -- LOAD DIM EMPLOYEE
        ------------------------------------------------
        INSERT INTO DimEmployee
        (EmployeeId, FirstName, LastName, Title, HireDate)
        SELECT EmployeeId, FirstName, LastName, Title, HireDate
        FROM StgEmployee;

        ------------------------------------------------
        -- LOAD DIM CUSTOMER
        ------------------------------------------------
           INSERT INTO DimCustomer
            (
                CustomerId,
                FirstName,
                LastName,
                Country,
                City,
                EmployeeKey
            )
            SELECT
                c.CustomerId,
                c.FirstName,
                c.LastName,
                c.Country,
                c.City,
                de.EmployeeKey
            FROM StgCustomer c
            JOIN DimEmployee de
                ON c.SupportRepId = de.EmployeeId;

        ------------------------------------------------
        -- LOAD DIM DATE
        ------------------------------------------------
        INSERT INTO DimDate
        (DateKey, FullDate, Year, Month, MonthName, Quarter)
        SELECT DISTINCT
            CAST(FORMAT(InvoiceDate, 'yyyyMMdd') AS INT),
            CAST(InvoiceDate AS DATE),
            YEAR(InvoiceDate),
            MONTH(InvoiceDate),
            DATENAME(MONTH, InvoiceDate),
            DATEPART(QUARTER, InvoiceDate)
        FROM StgInvoice;

        ------------------------------------------------
        -- LOAD FACT SALES
        ------------------------------------------------
        INSERT INTO FactSales
        (
            DateKey,
            CustomerKey,
            TrackKey,
            EmployeeKey,
            Quantity,
            UnitPrice,
            Revenue
        )
        SELECT
            CAST(FORMAT(i.InvoiceDate, 'yyyyMMdd') AS INT),
            dc.CustomerKey,
            dt.TrackKey,
            dc.EmployeeKey,   -- get from DimCustomer
            il.Quantity,
            il.UnitPrice,
            il.Quantity * il.UnitPrice
        FROM StgInvoiceLine il
        JOIN StgInvoice i ON il.InvoiceId = i.InvoiceId
        JOIN DimCustomer dc ON i.CustomerId = dc.CustomerId
        JOIN DimTrack dt ON il.TrackId = dt.TrackId;

        ------------------------------------------------
        -- LOG SUCCESS
        ------------------------------------------------
        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message)
        VALUES (@ProcName, 'END', 'SUCCESS', 'Warehouse Load Completed');

    END TRY
    BEGIN CATCH
        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message)
        VALUES (@ProcName, 'ERROR', 'FAILED', ERROR_MESSAGE());

        THROW;
    END CATCH
END;
GO

/*
---------------------------------------
| EXECUTE LOAD DATA TO STAGING TABLES |
---------------------------------------
*/

EXEC dbo.uspLoadWarehouse;

/*
---------------------
| CHECKING ETL LOGS |
---------------------
*/
SELECT * FROM ETLLog
ORDER BY LogId DESC;

SELECT 
    (SELECT COUNT(*) FROM DimArtist)   AS ArtistCount,
    (SELECT COUNT(*) FROM DimAlbum)    AS AlbumCount,
    (SELECT COUNT(*) FROM DimGenre)    AS GenreCount,
    (SELECT COUNT(*) FROM DimTrack)    AS TrackCount,
    (SELECT COUNT(*) FROM DimCustomer) AS CustomerCount,
    (SELECT COUNT(*) FROM DimEmployee) AS EmployeeCount,
    (SELECT COUNT(*) FROM DimDate)     AS DateCount,
    (SELECT COUNT(*) FROM FactSales)   AS FactCount;
