Use SportRadar_Tennis;

select * from dbo.competitions;

/*
---------------------------------------------------
List all competitions along with their category name
----------------------------------------------------
*/
SELECT
    c.competition_name,
    cat.category_name
FROM competitions c
LEFT JOIN categories cat
    ON c.category_id = cat.category_id
ORDER BY cat.category_name;

/*
---------------------------------------------------
Count the number of competitions in each category
----------------------------------------------------
*/
SELECT
    cat.category_name,
    COUNT(c.competition_id) AS competition_count
FROM competitions c
LEFT JOIN categories cat
    ON c.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY competition_count DESC;

/*
---------------------------------------------------
Find all competitions of type 'doubles'
----------------------------------------------------
*/
SELECT
    competition_name,
    type,
    gender
FROM competitions
WHERE type = 'doubles';

/*
---------------------------------------------------
Get competitions belonging to a specific category (ITF Men)
----------------------------------------------------
*/
SELECT
    c.competition_name,
    cat.category_name
FROM competitions c
LEFT JOIN categories cat
    ON c.category_id = cat.category_id
WHERE cat.category_name = 'ITF Men';

/*
---------------------------------------------------
Identify parent competitions and sub-competitions
----------------------------------------------------
*/
SELECT
    parent.competition_name AS parent_competition,
    child.competition_name AS sub_competition
FROM competitions child
INNER JOIN competitions parent
    ON child.parent_id = parent.competition_id
ORDER BY parent_competition;

/*
---------------------------------------------------
Analyze distribution of competition types by category
----------------------------------------------------
*/
SELECT
    cat.category_name,
    c.type,
    COUNT(*) AS total_competitions
FROM competitions c
LEFT JOIN categories cat
    ON c.category_id = cat.category_id
GROUP BY
    cat.category_name,
    c.type
ORDER BY
    cat.category_name,
    total_competitions DESC;

 /*
---------------------------------------------------
List all competitions with no parent (top-level competitions)
----------------------------------------------------
*/
SELECT
    competition_name,
    category_id,
    gender,
    type
FROM competitions
WHERE parent_id IS NULL;