

/*
Purpose: Clean + transform only what is needed i.e 9 Tables
-----------------------------------------------
| STORED PROCEDURE TO LOAD DATA TO STAGING TABLES |
-----------------------------------------------
*/

Use iTunesMusic;

CREATE OR ALTER PROCEDURE dbo.uspLoadStaging -- ONLY SAVES the procedure in SQL Server. It does NOT execute.
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProcName VARCHAR(100) = 'uspLoadStaging';
    DECLARE @RowCount INT;

    BEGIN TRY
        ---------------------------------------------------
        -- LOG START
        ----------------------------------------------------
        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message)
        VALUES (@ProcName, 'START', 'RUNNING', 'Staging ETL Started');

        ----------------------------------------------------
        -- TRUNCATE STAGING TABLES
        ----------------------------------------------------
         /*
       --------------------------------------------------------------
        TRUNCATE TABLE StgArtist; -- Table 1
        TRUNCATE TABLE StgAlbum; -- Table 2
        TRUNCATE TABLE StgTrack; -- Table 3
        TRUNCATE TABLE StgGenre; -- Table 4
        TRUNCATE TABLE StgMediaType; -- Table 5
        TRUNCATE TABLE StgCustomer; -- Table 6
        TRUNCATE TABLE StgEmployee; -- Table 7
        TRUNCATE TABLE StgInvoice; -- Table 8
        TRUNCATE TABLE StgInvoiceLine; -- Table 9

       
       TRUNCATE TABLE StgPlaylist; -- Table 10
       TRUNCATE TABLE StgPlaylistTrack; -- Table 11
       --------------------------------------------------------------
        */

        PRINT 'Step 2: Loading Staging Tables...'

       INSERT INTO StgArtist (ArtistId, Name)
        SELECT
            TRY_CAST(ArtistId AS INT),
            dbo.fnCleanText(Name)
        FROM RawArtist;

        SET @RowCount = @@ROWCOUNT;

        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message, RowsAffected)
        VALUES (@ProcName, 'LOAD StgArtist', 'SUCCESS', 'Loaded StgArtist', @RowCount);

        ----------------------------------------------------
        -- LOAD STG ALBUM
        ----------------------------------------------------
        INSERT INTO StgAlbum (AlbumId, Title, ArtistId)
        SELECT
            TRY_CAST(AlbumId AS INT),
            dbo.fnCleanText(Title),
            TRY_CAST(ArtistId AS INT)
        FROM RawAlbum
        WHERE TRY_CAST(ArtistId AS INT) IS NOT NULL;

        SET @RowCount = @@ROWCOUNT;

        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message, RowsAffected)
        VALUES (@ProcName, 'LOAD StgAlbum', 'SUCCESS', 'Loaded StgAlbum', @RowCount);

        ----------------------------------------------------
        -- LOAD STG CUSTOMER
        ----------------------------------------------------
      INSERT INTO StgCustomer
        (
            CustomerId, FirstName, LastName, Company,
            Address, City, State, Country,
            PostalCode, Phone, Fax, Email, SupportRepId
        )
        SELECT
            TRY_CAST(CustomerId AS INT),
            dbo.fnCleanText(FirstName),
            dbo.fnCleanText(LastName),
            Company,
            Address,
            City,
            State,
            Country,
            PostalCode,
            Phone,
            Fax,
            Email,
            TRY_CAST(SupportRepId AS INT)
        FROM RawCustomer;

        SET @RowCount = @@ROWCOUNT;

        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message, RowsAffected)
        VALUES (@ProcName, 'LOAD StgCustomer', 'SUCCESS', 'Loaded StgCustomer', @RowCount);

        ----------------------------------------------------
        -- LOAD STG INVOICE
        ----------------------------------------------------
        INSERT INTO StgInvoice
        (
            InvoiceId, CustomerId, InvoiceDate,
            BillingAddress, BillingCity,
            BillingState, BillingCountry,
            BillingPostalCode, Total
        )
        SELECT
            TRY_CAST(InvoiceId AS INT),
            TRY_CAST(CustomerId AS INT),
            TRY_CONVERT(DATE, InvoiceDate, 120),
            BillingAddress,
            BillingCity,
            BillingState,
            BillingCountry,
            BillingPostalCode,
            TRY_CAST(Total AS DECIMAL(10,2))
        FROM RawInvoice;

        SET @RowCount = @@ROWCOUNT;

        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message, RowsAffected )
        VALUES (@ProcName, 'LOAD StgInvoice', 'SUCCESS', 'Loaded StgInvoice', @RowCount);
        
        ----------------------------------------------------
        -- LOAD STG INVOICE LINE
        ----------------------------------------------------
        INSERT INTO StgInvoiceLine
        (
            InvoiceLineId, InvoiceId,
            TrackId, UnitPrice, Quantity
        )
        SELECT
            TRY_CAST(InvoiceLineId AS INT),
            TRY_CAST(InvoiceId AS INT),
            TRY_CAST(TrackId AS INT),
            TRY_CAST(UnitPrice AS DECIMAL(10,2)),
            TRY_CAST(Quantity AS INT)
        FROM RawInvoiceLine;

        SET @RowCount = @@ROWCOUNT;
       
         INSERT INTO ETLLog (ProcedureName, StepName, Status, Message, RowsAffected)
        VALUES (@ProcName, 'LOAD StgInvoiceLine', 'SUCCESS', 'Loaded StgInvoiceLine', @RowCount);

        ----------------------------------------------------
        -- FINAL SUCCESS
        ----------------------------------------------------
        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message)
        VALUES (@ProcName, 'END', 'SUCCESS', 'Staging ETL Completed Successfully');

        PRINT 'Staging Load Completed Successfully!';
    
   END TRY
    --------------------------------------------------------------
    BEGIN CATCH 
        INSERT INTO ETLLog (ProcedureName, StepName, Status, Message)
            VALUES (
                @ProcName,
                'ERROR',
                'FAILED',
                ERROR_MESSAGE()
            );

            THROW;
    END CATCH
END;
GO

/*
---------------------------------------
| EXECUTE LOAD DATA TO STAGING TABLES |
---------------------------------------
*/

SELECT COUNT(*) FROM StgArtist;
SELECT COUNT(*) FROM StgAlbum;
SELECT COUNT(*) FROM StgCustomer;


EXEC dbo.uspLoadStaging;

SELECT TOP 10 * FROM ETLLog ORDER BY LogId DESC;

SELECT * 
FROM ETLLog
ORDER BY LogId DESC;

SELECT name 
FROM sys.tables
WHERE name LIKE 'Dim%';

SELECT DB_NAME();

/*
----------------------------------------------------
Duplicates After Loading Clean Staging Data |
----------------------------------------------------
*/

SELECT *
FROM StgGenre;

SELECT Name, COUNT(*)
FROM StgGenre
GROUP BY Name
HAVING COUNT(*) > 1;

-- Remove Duplicates After Loading Clean Staging Data
WITH CTE AS (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY Name ORDER BY GenreId) AS RN
    FROM StgGenre
)
DELETE FROM CTE WHERE RN > 1;

SELECT * from StgArtist;

/*
---------------------
| CHECKING ETL LOGS |
---------------------
*/
SELECT * 
FROM ETLLog
ORDER BY LogId DESC;


