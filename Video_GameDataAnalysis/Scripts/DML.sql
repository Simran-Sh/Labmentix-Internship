use VideoGame;
GO

/*
============================
| Insert Data into DimGame |
============================
One row per unique GameId in the entire warehouse
*/

INSERT INTO Dim_Game(GameId,GameName,ReleaseDate)
SELECT DISTINCT 
	GameId,
	GameName,
	MAX(ReleaseDate) OVER (PARTITION BY GameId)
FROM Stg_Engagement;
GO

--- Looks at every sales game, Checks if already in Dim_Game Inserts only missing ones
INSERT INTO Dim_Game (GameId, GameName)
SELECT DISTINCT
    s.GameId,
    s.GameName
FROM Stg_Sales s
LEFT JOIN Dim_Game d
    ON s.GameId = d.GameId
WHERE d.GameId IS NULL;


--- Sanity Check
Select count(*) from Stg_Engagement;
Select count(*) from Dim_Game;

SELECT GameId, COUNT(*)
FROM Stg_Engagement
GROUP BY GameId
HAVING COUNT(*) > 1;


/*
============================
| Insert Data into DimPlatform |
============================
*/

INSERT INTO Dim_Platform (PlatformName)
SELECT DISTINCT
    Platform
FROM Stg_Sales;

SELECT * FROM Dim_Platform;

/*
============================
| Insert Data into DimPublisher |
============================
*/

INSERT INTO Dim_Publisher (PublisherName)
SELECT DISTINCT
    Publisher
FROM Stg_Sales;

SELECT * FROM Dim_Publisher;

/*
============================
| Insert Data into DimTime |
============================
*/

INSERT INTO Dim_Time (Year)
SELECT DISTINCT
      Year
FROM Stg_Sales;

SELECT * FROM Dim_Time;


/*
==========================
| SANITY CHECK|
==========================
*/
SELECT COUNT(*) AS [Dim_GameCount] FROM Dim_Game;
SELECT COUNT(*) AS [Dim_PlatformCount] FROM Dim_Platform;
SELECT COUNT(*) AS [Dim_PublisherCount] FROM Dim_Publisher;
SELECT COUNT(*) AS [Dim_TimeCount] FROM Dim_Time;


