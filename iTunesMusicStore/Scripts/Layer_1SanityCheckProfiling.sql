/*------------------------------------
| SANITY CHECK - Table and Row Count |
--------------------------------------
*/

SELECT name 
FROM sys.tables
WHERE name LIKE 'Raw%';

SELECT 'RawArtist' AS TableName, COUNT(*) AS [RowCount] FROM RawArtist
UNION ALL
SELECT 'RawAlbum', COUNT(*) FROM RawAlbum
UNION ALL
SELECT 'RawTrack', COUNT(*) FROM RawTrack
UNION ALL
SELECT 'RawCustomer', COUNT(*) FROM RawCustomer
UNION ALL
SELECT 'RawEmployee', COUNT(*) FROM RawEmployee
UNION ALL
SELECT 'RawInvoice', COUNT(*) FROM RawInvoice
UNION ALL
SELECT 'RawInvoiceLine', COUNT(*) FROM RawInvoiceLine;

/*----------------------------
| SANITY CHECK - Duplicates |
-----------------------------
*/

SELECT ArtistId, COUNT(*) 
FROM RawArtist
GROUP BY ArtistId
HAVING COUNT(*) > 1;

SELECT AlbumId, COUNT(*) 
FROM RawAlbum
GROUP BY AlbumId
HAVING COUNT(*) > 1;

SELECT TrackId, COUNT(*) 
FROM RawTrack
GROUP BY TrackId
HAVING COUNT(*) > 1;

SELECT CustomerId, COUNT(*) 
FROM RawCustomer
GROUP BY CustomerId
HAVING COUNT(*) > 1;

SELECT Name, COUNT(*) 
FROM RawGenre
GROUP BY Name
HAVING COUNT(*) > 1;


/*----------------------------
| SANITY CHECK - Nulls |
-----------------------------
*/
SELECT * 
FROM RawTrack
WHERE TrackId IS NULL OR TrackId = '';

SELECT *
FROM RawInvoice
WHERE InvoiceId IS NULL OR InvoiceId = '';

/*---------------------------------------
| SANITY CHECK - Numeric Pattern Validation |
----------------------------------------
*/
SELECT *
FROM RawTrack
WHERE TRY_CAST(TrackId AS INT) IS NULL
AND TrackId IS NOT NULL; --TrackId Not Numeric

SELECT *
FROM RawTrack
WHERE TRY_CAST(UnitPrice AS DECIMAL(10,2)) IS NULL --UnitPrice Not Decimal
AND UnitPrice IS NOT NULL;

SELECT *
FROM RawEmployee
WHERE TRY_CONVERT(DATE, BirthDate, 105) IS NULL
AND BirthDate IS NOT NULL; --Date Pattern Validation For Employee BirthDate:

/*---------------------------------------
| SANITY - Referential Integrity Checks |
----------------------------------------
*/
SELECT *
FROM RawAlbum a
LEFT JOIN RawArtist ar
    ON a.ArtistId = ar.ArtistId
WHERE ar.ArtistId IS NULL; -- Album Without Artist

SELECT *
FROM RawTrack t
LEFT JOIN RawAlbum a
    ON t.AlbumId = a.AlbumId
WHERE a.AlbumId IS NULL; -- Track Without Album

SELECT *
FROM RawInvoiceLine il
LEFT JOIN RawInvoice i
    ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceId IS NULL; -- InvoiceLine Without Invoice

/*---------------------------
| Text Anomaly SANITY Check |
-----------------------------
*/

SELECT DISTINCT Name -- Check for Trailing spaces, Weird symbols, Case inconsistency
FROM RawGenre
ORDER BY Name; 

