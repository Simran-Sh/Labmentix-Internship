-- go to master
USE master;
GO

--- Drop and create the database if doesn't exist already
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'VideoGame')
BEGIN
	ALTER DATABASE VideoGame
	SET MULTI_USER  WITH ROLLBACK IMMEDIATE;
END;
GO

DROP DATABASE VideoGame;

/*
===================
| CREATE DATABASE |
===================
*/

CREATE DATABASE VideoGame;
GO
