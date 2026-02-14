-- go to master
USE master;
GO

--- Drop and create the database if doesn't exist already
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'VideoGameAnalysis')
BEGIN
	ALTER DATABASE VideoGameAnalysis
	SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END;
GO

/*
===================
| CREATE DATABASE |
===================
*/
CREATE DATABASE VideoGameAnalysis;
GO

