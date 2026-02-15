/*
=======================
| FIXATIONS IN TABLES |
=======================
*/

Use VideoGameAnalysis;

-- Issue_1: The direct load from Python caused auto-generated schema
-- Solution: Dropping the loaded table(s) and creating tables manually with bulk upload from csv

DROP TABLE IF EXISTS df_CleanEngagementData;
GO

DROP TABLE IF EXISTS df_CleanSalesData;
GO


