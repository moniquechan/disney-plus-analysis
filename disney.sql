-- view data set
SELECT *
FROM DisneyPlus..disney_plus_titles

-- add numeric column for duration
ALTER TABLE DisneyPlus..disney_plus_titles
ADD duration_value NUMERIC;

UPDATE DisneyPlus..disney_plus_titles
SET duration_value = CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT);

-- look for duplicates
SELECT show_id, COUNT(*)                                                                                                                                                                            
FROM DisneyPlus..disney_plus_titles 
GROUP BY show_id                                                                                                                                                                                            
ORDER BY show_id DESC;
-- no duplicates found

-- drop columns that are not needed
ALTER TABLE DisneyPlus..disney_plus_titles
DROP COLUMN [description];

ALTER TABLE DisneyPlus..disney_plus_titles
DROP COLUMN [cast];

ALTER TABLE DisneyPlus..disney_plus_titles
DROP COLUMN [country];

--tables for visualizations

SELECT [type], COUNT(*)
FROM DisneyPlus..disney_plus_titles
GROUP BY [type];

SELECT rating, COUNT(*) AS 'Count'
FROM DisneyPlus..disney_plus_titles
WHERE rating != ''
GROUP BY rating
ORDER BY [Count] DESC;

SELECT YEAR(date_added) AS 'Year', COUNT(YEAR(date_added)) AS 'Count'
FROM DisneyPlus..disney_plus_titles
WHERE YEAR(date_added) IS NOT NULL
GROUP BY YEAR(date_added)
ORDER BY [Year] ASC;

SELECT duration_value AS 'Number of Seasons', COUNT(*) AS 'Number of TV Shows'
FROM DisneyPlus..disney_plus_titles
WHERE [type] = 'TV Show'
GROUP BY duration_value;

SELECT release_year AS 'Release Year', COUNT(*) AS 'Number of Movies Released', FORMAT(ROUND(AVG(duration_value),2), '##.##') AS 'Average Length of Movies (minutes)'
FROM DisneyPlus..disney_plus_titles
WHERE [type] = 'Movie'
GROUP BY release_year
ORDER BY release_year ASC;

SELECT listed_in, COUNT(*) AS 'Count'
FROM DisneyPlus..disney_plus_titles
GROUP BY listed_in
ORDER BY COUNT(listed_in) DESC;

CREATE VIEW top_directors AS
SELECT TOP 10 director, COUNT(*) AS 'Count'
FROM DisneyPlus..disney_plus_titles
WHERE director != ''
GROUP BY director, [type]
ORDER BY COUNT(director) DESC

SELECT director, listed_in, COUNT(*) AS 'Count'
FROM DisneyPlus..disney_plus_titles
WHERE director != '' AND director IN (SELECT director FROM top_directors)
GROUP BY [director], listed_in
ORDER BY director, COUNT(director) DESC
