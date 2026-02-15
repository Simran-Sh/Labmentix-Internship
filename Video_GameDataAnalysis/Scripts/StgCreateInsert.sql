
/*
=========================
| CREATE STAGING TABLES |
=========================
*/
Use VideoGame;

DROP TABLE IF EXISTS Stg_Engagement;
GO

CREATE TABLE Stg_Engagement (
    GameId INT,
    GameName VARCHAR(255),
    ReleaseDate DATE NULL,
    Rating FLOAT NULL,
    TimesListed FLOAT,
    NumberOfReviews FLOAT,
    Plays FLOAT,
    Playing FLOAT,
    Backlogs FLOAT,
    Wishlist FLOAT
);
GO


DROP TABLE IF EXISTS Stg_Sales;
GO

CREATE TABLE Stg_Sales (
    GameId INT,
    GameName VARCHAR(255),
    Platform VARCHAR(100),
    Year INT,
    Publisher VARCHAR(150),
    NaSales FLOAT,
    EuSales FLOAT,
    JpSales FLOAT,
    OtherSales FLOAT,
    GlobalSales FLOAT
);

/*
=================================
| BULK INSERT TO STAGING TABLES |
=================================
*/

BULK INSERT dbo.Stg_Engagement
FROM "E:\LabMentixInternship\Video_GameDataAnalysis\StgCleanEngagement.csv"
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO

BULK INSERT dbo.Stg_Sales
FROM "E:\LabMentixInternship\Video_GameDataAnalysis\StageCleanSales.csv"
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/*
================
| SANITY CHECK |
================
*/
SELECT 
    COUNT(*) as [Stg_Engagement] 
FROM Stg_Engagement;
GO

SELECT 
    COUNT(*) as [Stg_Sales]
FROM Stg_Sales;
GO

-- Check for NULL critical fields
SELECT COUNT(*) FROM Stg_Sales WHERE GameId IS NULL;
SELECT COUNT(*) FROM Stg_Sales WHERE Platform IS NULL;
SELECT COUNT(*) FROM Stg_Sales WHERE Publisher IS NULL;
SELECT COUNT(*) FROM Stg_Sales WHERE NaSales IS NULL;

SELECT 
    SUM(GlobalSales) AS TotalGlobalSales
FROM Stg_Sales;

-- Checking for duplicates
SELECT
    s.GameId,
    s.Platform,
    s.Year,
    COUNT(*) AS DuplicateCount
FROM Stg_Sales s
GROUP BY
    s.GameId,
    s.Platform,
    s.Year
HAVING COUNT(*) > 1;
