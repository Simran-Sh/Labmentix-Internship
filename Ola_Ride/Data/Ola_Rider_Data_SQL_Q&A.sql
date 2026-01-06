/*
---------------------------------------------------------
CREATE DATABASE AND DELETE IF ALREADY EXISTS WITH SAME NAME
---------------------------------------------------------
*/
 -- go to master 

Use master;
GO

-- Drop and recreate the database, only if working from scratch

IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'Ola_Rider_Data')
BEGIN 
	ALTER DATABASE Ola_Rider_Data
	SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END;
GO

CREATE DATABASE Ola_Rider_Data;
GO


USE Ola_Rider_Data;
GO

/*
-------------------------------
SELECT TOP 100 ROWS FROM TABLE
-------------------------------
*/
SELECT TOP (100) 
       [Date]
      ,[Time]
      ,[Booking_ID]
      ,[Booking_Status]
      ,[Customer_ID]
      ,[Vehicle_Type]
      ,[Pickup_Location]
      ,[Drop_Location]
      ,[V_TAT]
      ,[C_TAT]
      ,[Canceled_Rides_by_Customer]
      ,[Canceled_Rides_by_Driver]
      ,[Incomplete_Rides]
      ,[Incomplete_Rides_Reason]
      ,[Booking_Value]
      ,[Payment_Method]
      ,[Ride_Distance]
      ,[Driver_Ratings]
      ,[Customer_Rating]
      ,[Vehicle_Images]
  FROM [Ola_Rider_Data].[dbo].[Ola_Dataset_2024]

  /*
-------------------------------
Question_1: List of records with succcessful bookings
-------------------------------
*/
  
  SELECT * FROM dbo.Ola_Dataset_2024
  WHERE Booking_Status='Success';

    /*
-------------------------------------------------------
| Question_2: Average Vehicle Distance by Vehicle type |
--------------------------------------------------------
*/
  SELECT Vehicle_Type, AVG(Ride_Distance) AS [Average Distance]
  FROM DBO.Ola_Dataset_2024
  GROUP BY Vehicle_Type;

/*
---------------------------------------------
Question_3: Total Cancelled rides by Customer |
---------------------------------------------
*/ 
  SELECT Canceled_Rides_by_Customer, COUNT(Booking_ID) FROM DBO.Ola_Dataset_2024
  GROUP BY Canceled_Rides_by_Customer;
  GO

  SELECT Booking_Status, COUNT(Booking_ID) AS [Count] FROM DBO.Ola_Dataset_2024
  GROUP BY Booking_Status;

  SELECT * FROM DBO.Ola_Dataset_2024
  WHERE Booking_Status = 'Canceled by Customer';
  GO

/*
------------------------------------------------------------
| Question_4: TOP 5 CUSTOMERS WITH HIGHEST NUMBER OF RIDES |
------------------------------------------------------------
*/ 

SELECT TOP (5) 
    Customer_ID, 
    COUNT(Booking_ID) AS [RIDE_COUNT]
FROM [Ola_Rider_Data].[dbo].[Ola_Dataset_2024]
GROUP BY Customer_ID
ORDER BY [RIDE_COUNT] DESC;
GO


/*
-----------------------------------------------------------------------------------------
| Question_5: NUMBER OF RIDES CANCELED BY DRIVERS DUE TO PERSONAL AND CAR RELATED ISSUES |
-----------------------------------------------------------------------------------------
*/ 
SELECT 
   COUNT(*) AS [Rides Canceled by Driver] 
FROM [Ola_Rider_Data].[dbo].[Ola_Dataset_2024]
WHERE Booking_Status = 'Canceled by Driver'
GO

SELECT Booking_Status, COUNT(*)
FROM [Ola_Rider_Data].[dbo].[Ola_Dataset_2024]
GROUP BY Booking_Status;
GO

SELECT Canceled_Rides_by_Driver, COUNT(*)
FROM [Ola_Rider_Data].[dbo].[Ola_Dataset_2024]
GROUP BY Canceled_Rides_by_Driver;
GO

SELECT COUNT(*)
FROM [Ola_Rider_Data].[dbo].[Ola_Dataset_2024]
WHERE Canceled_Rides_by_Driver = 'Personal & Car related issue';
GO

/*
--------------------------------------------------------------------------
| Question_6: MAXIMUM AND MINIMUM DRIVER RATINGS FOR PRIME SEDAN BOOKINGS |
--------------------------------------------------------------------------
*/
SELECT
    Vehicle_Type,
    COUNT(*) AS [Rides_COUNT_per_Vehicle],
    AVG(Driver_Ratings) AS [AVG_DRVER_RATING],
    MAX(Driver_Ratings) AS [MAX_DRVER_RATING],
    MIN(Driver_Ratings) AS [MIN_DRVER_RATING]
FROM Ola_Dataset_2024
GROUP BY Vehicle_Type;
GO

SELECT
    MAX(Driver_Ratings) AS [MAX_DRVER_RATING],
    MIN(Driver_Ratings) AS [MIN_DRVER_RATING]
FROM Ola_Dataset_2024
WHERE Vehicle_Type = 'Prime Sedan';
GO
/*
----------------------------------------
| Question_7: RECORDS WITH UPI PAYMENT |
-----------------------------------------
*/
SELECT 
count(*), Payment_Method
FROM Ola_Dataset_2024
GROUP BY Payment_Method;
GO

SELECT 
* 
FROM Ola_Dataset_2024
WHERE Payment_Method ='UPI';
GO

/*
------------------------------------------------------
| Question_8: AVERAGE CUSTOMER RATING BY VEHICLE TYPE |
------------------------------------------------------
*/
SELECT
    Vehicle_Type,
    COUNT(*) AS [Rides_COUNT_per_Vehicle],
    AVG(Customer_Rating) AS [AVG_Customer_RATING],
    MAX(Customer_Rating) AS [MAX_Customer_RATING],
    MIN(Customer_Rating) AS [MIN_Customer_RATING]
FROM Ola_Dataset_2024
GROUP BY Vehicle_Type;
GO

SELECT
    Vehicle_Type,
    AVG(Customer_Rating) AS [AVG_Customer_RATING]
FROM Ola_Dataset_2024
GROUP BY Vehicle_Type;
GO
/*
------------------------------------------------------
| Question_9:  TOTAL BOOKING VALUE OF SUCCESFULL RIDES |
------------------------------------------------------
*/
SELECT 
    SUM(Booking_Value) AS [Total Succcessful booking Value]
FROM dbo.Ola_Dataset_2024
WHERE Booking_Status='Success';
GO

SELECT 
    Booking_Status,
    Booking_Value
FROM dbo.Ola_Dataset_2024
WHERE Booking_Status='Success';
GO
/*
----------------------------------------------------
| Question_10: LIST OF INCOMPLETE RIDES WITH REASON |
----------------------------------------------------
*/

SELECT 
    COUNT(*) AS [INCOMPLETE_RIDES_COUNT],
    Incomplete_Rides_Reason
FROM dbo.Ola_Dataset_2024
WHERE Incomplete_Rides = 1
GROUP BY Incomplete_Rides_Reason;
GO

SELECT 
    Customer_ID,
    Booking_ID,
    Customer_Rating,
    Driver_Ratings,
    Booking_Value,
    Incomplete_Rides_Reason
FROM dbo.Ola_Dataset_2024
WHERE Incomplete_Rides = 1;
GO