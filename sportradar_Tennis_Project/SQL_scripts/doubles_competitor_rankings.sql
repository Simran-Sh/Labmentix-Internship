Use SportRadar_Tennis;

select * from dbo.doubles_competitor_rankings;


/*
---------------------------------------------------
Get all competitors with their rank and points
----------------------------------------------------
*/
SELECT
    competitor_name,
    rank,
    points
FROM doubles_competitor_rankings
ORDER BY rank;

/*
---------------------------------------------------
Find competitors ranked in the top 5
----------------------------------------------------
*/
SELECT
    competitor_name,
    rank,
    points,
    country
FROM doubles_competitor_rankings
WHERE rank <= 5
ORDER BY rank;

/*
---------------------------------------------------
List competitors with no rank movement (stable rank)
----------------------------------------------------
*/
SELECT
    competitor_name,
    rank,
    movement,
    points
FROM doubles_competitor_rankings
WHERE movement = 0
ORDER BY rank;

/*
---------------------------------------------------
Get total points of competitors from Croatia
----------------------------------------------------
*/
SELECT
    country,
    SUM(points) AS total_points
FROM doubles_competitor_rankings
WHERE country = 'Croatia'
GROUP BY country;

/*
---------------------------------------------------
Count the number of competitors per country
----------------------------------------------------
*/
SELECT
    country,
    COUNT(*) AS competitor_count
FROM doubles_competitor_rankings
GROUP BY country
ORDER BY competitor_count DESC;

/*
---------------------------------------------------
Find competitors with the highest points in the current week
----------------------------------------------------
*/
SELECT
    competitor_name,
    rank,
    points,
    week,
    year
FROM doubles_competitor_rankings
WHERE points = (
    SELECT MAX(points)
    FROM doubles_competitor_rankings
);

/*
---------------------------------------------------
ATP vs WTA Competitor Count
----------------------------------------------------
*/
SELECT
    league_name,
    COUNT(*) AS total_competitors
FROM doubles_competitor_rankings
GROUP BY league_name;

/*
---------------------------------------------------
Countries With Most Competitors
----------------------------------------------------
*/
SELECT TOP 10
    country,
    COUNT(*) AS total_competitors
FROM doubles_competitor_rankings
GROUP BY country
ORDER BY total_competitors DESC;

/*
---------------------------------------------------
Competitors With Negative Rank Movement
----------------------------------------------------
*/
SELECT
    competitor_name,
    movement,
    rank
FROM doubles_competitor_rankings
WHERE movement < 0
ORDER BY movement ASC;