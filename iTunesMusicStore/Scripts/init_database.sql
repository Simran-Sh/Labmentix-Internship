
/*
-------------------------------------------------------
CREATE NEW DATABASE for Apple iTunes Analytics project |
--------------------------------------------------------
*/

USE master;
GO

-- 1. Check if the database exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'iTunesMusic')
-- N stands for  National Character Set. 
-- Tells SQL to treat the text that follows as Unicode (UCS-2/UTF-16) rather than standard ASCII/non-Unicode text

BEGIN
    -- 2. Kick off any active users so the drop doesn't fail
    ALTER DATABASE iTunesMusic 
    SET MULTI_USER WITH ROLLBACK IMMEDIATE;
    
    -- 3. Delete the database
    DROP DATABASE iTunesMusic;
END

-- 4. Create the fresh database
CREATE DATABASE iTunesMusic;
GO

Use iTunesMusic;

-- The "ETLLog table" is used to track, monitor, and audit your ETL executions

CREATE TABLE ETLLog
(
    LogId INT IDENTITY PRIMARY KEY,
    ProcedureName VARCHAR(100),
    StepName VARCHAR(100),
    LoadDate DATETIME DEFAULT GETDATE(), -- Gets current date and time
    Status VARCHAR(50),
    Message VARCHAR(1000),
    [RowCount] INT NULL -- -- Wrapped in brackets to avoid reserved word error
);

ALTER TABLE ETLLog
DROP COLUMN [RowCount];

ALTER TABLE ETLLog
ADD RowsAffected INT NULL;

SELECT * FROM ETLLog;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ETLLog';

sp_help ETLLog;
