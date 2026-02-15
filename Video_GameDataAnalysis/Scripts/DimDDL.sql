

/*
==========================
| CREATE DIMENSION TABLES|
==========================
*/ 

Use VideoGame;
GO

/*
-----------------------------------
| DimGame Grain: One row per game |
-----------------------------------
*/

CREATE TABLE Dim_Game (
	GameId INT PRIMARY KEY,
	GameName VARCHAR(255) NOT NULL,
	ReleaseDate DATE NULL
);
GO

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Dim_Game';

/*
-------------------------------------------
| DimPlatform Grain: One row per platform |
-------------------------------------------
*/

CREATE TABLE Dim_Platform (
	PlatformId INT IDENTITY(1,1) PRIMARY KEY,
	PlatformName VARCHAR(100) NOT NULL
);

/*
-----------------
| DimPublisher  |
-----------------
*/

CREATE TABLE Dim_Publisher (
    PublisherId INT IDENTITY(1,1) PRIMARY KEY,
    PublisherName VARCHAR(150) NOT NULL
);

/*
------------
| DimTime  |
------------
*/
CREATE TABLE Dim_Time (
    Year INT PRIMARY KEY
);

