Use VideoGameAnalysis;
GO

/*
==========================
| CREATE DIMENSION TABLES|
==========================

-----------------------------------
| DimGame Grain: One row per game |
-----------------------------------
*/

CREATE TABLE DimGame (
	GameId INT PRIMARY KEY,
	GameName VARCHAR(255) NOT NULL,
	ReleaseDate DATE NULL
);
GO

/*
-------------------------------------------
| DimPlatform Grain: One row per platform |
-------------------------------------------
*/

CREATE TABLE DimPlatform (
	PlatformId INT IDENTITY(1,1) PRIMARY KEY,
	PlatformName VARCHAR(100) NOT NULL
);

/*
-----------------
| DimPublisher  |
-----------------
*/

CREATE TABLE DimPublisher (
    PublisherId INT IDENTITY(1,1) PRIMARY KEY,
    PublisherName VARCHAR(150) NOT NULL
);

/*
-----------------
| DimTime  |
-----------------
*/
CREATE TABLE DimTime (
    Year INT PRIMARY KEY
);

