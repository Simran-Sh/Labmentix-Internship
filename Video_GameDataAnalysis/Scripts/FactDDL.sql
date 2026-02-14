
/*
=====================
| CREATE FACT TABLES|
=====================

----------------------------------------------
| FactGameEngagement Grain: One row per game |
----------------------------------------------
*/

CREATE TABLE FactGameEngagement (
	GameId INT PRIMARY KEY,
	Rating FLOAT NULL,
	TimesListed FLOAT,
    NumberOfReviews FLOAT,
    Plays FLOAT,
    Playing FLOAT,
    Backlogs FLOAT,
    Wishlist FLOAT,
    FOREIGN KEY (GameId) REFERENCES DimGame (GameId)
);
GO

/*
---------------------------------------------------------------
| FactGameSales Grain: One row per Game per Platform per Year |
---------------------------------------------------------------
*/
CREATE TABLE FactGameSales (
    GameId INT NOT NULL,
    PlatformId INT NOT NULL,
    Year INT NOT NULL,
    PublisherId INT NOT NULL,
    NaSales FLOAT,
    EuSales FLOAT,
    JpSales FLOAT,
    OtherSales FLOAT,
    GlobalSales FLOAT,
    
    PRIMARY KEY (GameId, PlatformId, Year),

    FOREIGN KEY (GameId) REFERENCES DimGame(GameId),
    FOREIGN KEY (PlatformId) REFERENCES DimPlatform(PlatformId),
    FOREIGN KEY (PublisherId) REFERENCES DimPublisher(PublisherId),
    FOREIGN KEY (Year) REFERENCES DimTime(Year)
);

