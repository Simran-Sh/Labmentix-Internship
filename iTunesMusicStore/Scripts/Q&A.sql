/*
========================================================
Customer Analytical SQL Questions (Apple Business View) |
=========================================================
*/
Use iTunesMusic;

-- Which customers have spent the most money?
SELECT 
    dc.FirstName,
    dc.LastName,
    SUM(fs.Revenue) AS TotalSpent
FROM FactSales fs
JOIN DimCustomer dc ON fs.CustomerKey = dc.CustomerKey
GROUP BY dc.FirstName, dc.LastName
ORDER BY TotalSpent DESC;

-- Average Customer Lifetime Value
SELECT AVG(CustomerTotal) AS AvgCustomerLifetimeValue
FROM (
    SELECT SUM(Revenue) AS CustomerTotal
    FROM FactSales
    GROUP BY CustomerKey
) t;

-- Top Customers Lifetime Value
SELECT 
    c.CustomerId,
    c.FirstName + ' ' + c.LastName AS FullName,
    SUM(f.Revenue) AS LifetimeValue
FROM FactSales f
JOIN DimCustomer c 
    ON f.CustomerKey = c.CustomerKey
GROUP BY 
    c.CustomerId,
    c.FirstName,
    c.LastName
ORDER BY LifetimeValue DESC;

-- Repeat vs One-Time Customers
SELECT 
    CASE 
        WHEN COUNT(DISTINCT DateKey) > 1 THEN 'Repeat'
        ELSE 'One-Time'
    END AS CustomerType,
    COUNT(*) AS CustomerCount
FROM FactSales
GROUP BY CustomerKey;

/*----------------------------
| Sales & Revenue Analysis |
-----------------------------
*/

-- Total Revenue
SELECT SUM(Revenue) AS TotalRevenue
FROM FactSales;


-- Revenue by Country
SELECT 
    c.Country,
    SUM(f.Revenue) AS Revenue
FROM FactSales f
JOIN DimCustomer c ON f.CustomerKey = c.CustomerId
GROUP BY c.Country
ORDER BY Revenue DESC;


-- Monthly Revenue Trends (Trend Over Time)
SELECT 
    d.Year,
    d.Month,
    SUM(fs.Revenue) AS MonthlyRevenue
FROM FactSales fs
JOIN DimDate d ON fs.DateKey = d.DateKey
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month;

-- Average Invoice Value
SELECT AVG(InvoiceTotal) AS AvgInvoiceValue
FROM (
    SELECT SUM(Revenue) AS InvoiceTotal
    FROM FactSales
    GROUP BY DateKey, CustomerKey
) t;

/*----------------------------
| Product & Content Analysis |
-----------------------------
*/

-- Top Revenue Tracks
SELECT 
    dt.TrackName,
    SUM(fs.Revenue) AS TotalRevenue
FROM FactSales fs
JOIN DimTrack dt ON fs.TrackKey = dt.TrackKey
GROUP BY dt.TrackName
ORDER BY TotalRevenue DESC;

-- Tracks Never Purchased
SELECT dt.TrackName
FROM DimTrack dt
LEFT JOIN FactSales fs ON dt.TrackKey = fs.TrackKey
WHERE fs.TrackKey IS NULL;

/*----------------------------
| Artist & Genre Performance |
-----------------------------
*/
-- Top 5 Artists  by Revenue
SELECT TOP 5
    da.ArtistName,
    SUM(fs.Revenue) AS TotalRevenue
FROM FactSales fs
JOIN DimTrack dt ON fs.TrackKey = dt.TrackKey
JOIN DimAlbum dal ON dt.AlbumKey = dal.AlbumKey
JOIN DimArtist da ON dal.ArtistKey = da.ArtistKey
GROUP BY da.ArtistName
ORDER BY TotalRevenue DESC;

-- Top Selling Genres
SELECT 
    g.GenreName,
    SUM(f.Revenue) AS Revenue
FROM FactSales f
JOIN DimTrack t ON f.TrackKey = t.TrackId
JOIN DimGenre g ON t.GenreKey = g.GenreId
GROUP BY g.GenreName
ORDER BY Revenue DESC;


/*----------------------------
| Employee Performance |
-----------------------------
*/

-- Revenue Per Employee
SELECT 
    de.FirstName,
    de.LastName,
    SUM(fs.Revenue) AS RevenueGenerated
FROM FactSales fs
JOIN DimEmployee de ON fs.EmployeeKey = de.EmployeeKey
GROUP BY de.FirstName, de.LastName
ORDER BY RevenueGenerated DESC;


/*----------------------------
| Pareto Analysis (80/20 Rule) |
--------------------------------
Top 20% customers contributing 80% of revenue.
---------------------------------------------
*/

-- Calculate Total Revenue Per Customer

WITH CustomerRevenue AS
(
    SELECT
        dc.CustomerKey,
        dc.FirstName,
        dc.LastName,
        SUM(fs.Revenue) AS TotalRevenue
    FROM FactSales fs
    JOIN DimCustomer dc ON fs.CustomerKey = dc.CustomerKey
    GROUP BY dc.CustomerKey, dc.FirstName, dc.LastName
),
RankedRevenue AS -- -- Add Running Total + Percentage
(
    SELECT *,
        SUM(TotalRevenue) OVER() AS GrandTotal,
        SUM(TotalRevenue) OVER(ORDER BY TotalRevenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
    FROM CustomerRevenue
)
SELECT
    FirstName,
    LastName,
    TotalRevenue,
    RunningTotal,
    CAST(RunningTotal * 100.0 / GrandTotal AS DECIMAL(5,2)) AS CumulativePercent -- -- Final Pareto Output
FROM RankedRevenue
ORDER BY TotalRevenue DESC;

-- Only Top 80%
SELECT
    FirstName,
    LastName,
    TotalRevenue,
    RunningTotal,
    CAST(RunningTotal * 100.0 / GrandTotal AS DECIMAL(5,2)) AS CumulativePercent
FROM RankedRevenue
WHERE RunningTotal * 1.0 / GrandTotal <= 0.8
ORDER BY TotalRevenue DESC;
