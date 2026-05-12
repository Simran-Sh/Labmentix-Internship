
use SportRadar_Tennis;

ALTER TABLE tennis_complexes
DROP COLUMN capacity,
            map_coordinates,
            changed,
            reduced_capacity,
            reduced_capacity_max;

select * from dbo.tennis_complexes;

/*
---------------------------------------------------
List all venues along with associated complex name
----------------------------------------------------
*/
SELECT
    complex_name,
    venue_name
FROM tennis_complexes
ORDER BY complex_name, venue_name;

/*
---------------------------------------------------
Count number of venues in each complex
----------------------------------------------------
*/
SELECT
    complex_name,
    COUNT(venue_id) AS venue_count
FROM tennis_complexes
GROUP BY complex_name
ORDER BY venue_count DESC;


/*
---------------------------------------------------
Get details of venues in a specific country (Chile)
----------------------------------------------------
*/
SELECT *
FROM tennis_complexes
WHERE country_name = 'Chile';

/*
---------------------------------------------------
Identify all venues and their timezones
----------------------------------------------------
*/
SELECT
    venue_name,
    timezone
FROM tennis_complexes
ORDER BY timezone;

/*
---------------------------------------------------
Find complexes having more than one venue
----------------------------------------------------
*/
SELECT
    complex_name,
    COUNT(venue_id) AS venue_count
FROM tennis_complexes
GROUP BY complex_name
HAVING COUNT(venue_id) > 1
ORDER BY venue_count DESC;

/*
---------------------------------------------------
List venues grouped by country
----------------------------------------------------
*/
SELECT
    country_name,
    STRING_AGG(venue_name, ', ') AS venues
FROM tennis_complexes
GROUP BY country_name
ORDER BY country_name;

/*
---------------------------------------------------
Find all venues for a specific complex (Nacional)
----------------------------------------------------
*/
SELECT
    complex_name,
    venue_name
FROM tennis_complexes
WHERE complex_name = 'Nacional';

/*
---------------------------------------------------
SQL Validation Queries
----------------------------------------------------
*/
SELECT COUNT(*) AS total_venues
FROM tennis_complexes;

SELECT COUNT(DISTINCT complex_id) AS total_complexes
FROM tennis_complexes;

SELECT COUNT(DISTINCT country_name) AS countries
FROM tennis_complexes;