use VideoGame;
GO

/*
============================
| Insert Data into Fact Tables |
============================
One row per unique GameId in the entire warehouse
*/

--- FactGameEngagement bulk insert from staging table

INSERT INTO Fact_GameEngagement
(
    GameId,
    Rating,
    TimesListed,
    NumberOfReviews,
    Plays,
    Playing,
    Backlogs,
    Wishlist
)
SELECT
    GameId,
    AVG(Rating),
    SUM(TimesListed),
    SUM(NumberOfReviews),
    SUM(Plays),
    SUM(Playing),
    SUM(Backlogs),
    SUM(Wishlist)
FROM Stg_Engagement
GROUP BY GameId;


--- FactGameSales bulk insert from staging table and by join to dimension tables to get surrogate keys.
INSERT INTO Fact_GameSales
(
    GameId,
    PlatformId,
    PublisherId,
    Year,
    NaSales,
    EuSales,
    JpSales,
    OtherSales,
    GlobalSales
)
SELECT
    s.GameId,
    p.PlatformId,
    pub.PublisherId,
    t.Year,
    SUM(s.NaSales),
    SUM(s.EuSales),
    SUM(s.JpSales),
    SUM(s.OtherSales),
    SUM(s.GlobalSales)
FROM Stg_Sales s
JOIN Dim_Platform p
    ON s.Platform = p.PlatformName
JOIN Dim_Publisher pub
    ON s.Publisher = pub.PublisherName
JOIN Dim_Time t
    ON s.Year = t.Year
GROUP BY
    s.GameId,
    p.PlatformId,
    pub.PublisherId,
    t.Year;


/*

----------------
| Sanity Check |
----------------
*/
SELECT COUNT(*) FROM Dim_Game;

SELECT COUNT(*)
FROM Stg_Sales s
LEFT JOIN Dim_Game d
    ON s.GameId = d.GameId
WHERE d.GameId IS NULL;

SELECT COUNT(*)
FROM Fact_GameSales f
LEFT JOIN Dim_Game d ON f.GameId = d.GameId
WHERE d.GameId IS NULL;


SELECT COUNT(*) FROM Fact_GameSales;
SELECT COUNT(*) FROM Fact_GameEngagement;
