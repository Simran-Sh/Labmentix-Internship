Use VideoGame;
/*
=====================
| CREATE FACT TABLES|
=====================

----------------------------------------------
| FactGameEngagement Grain: One row per game |
----------------------------------------------
*/



CREATE TABLE Fact_GameEngagement (
	GameId INT PRIMARY KEY,
	Rating FLOAT NULL,
	TimesListed FLOAT,
    NumberOfReviews FLOAT,
    Plays FLOAT,
    Playing FLOAT,
    Backlogs FLOAT,
    Wishlist FLOAT,
    FOREIGN KEY (GameId) REFERENCES dbo.Dim_Game(GameId)
);
GO

/*
---------------------------------------------------------------
| FactGameSales Grain: One row per Game per Platform per Year |
---------------------------------------------------------------
*/
CREATE TABLE Fact_GameSales (
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

    FOREIGN KEY (GameId) REFERENCES Dim_Game(GameId),
    FOREIGN KEY (PlatformId) REFERENCES Dim_Platform(PlatformId),
    FOREIGN KEY (PublisherId) REFERENCES Dim_Publisher(PublisherId),
    FOREIGN KEY (Year) REFERENCES Dim_Time(Year)
);

