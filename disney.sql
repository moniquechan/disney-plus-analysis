-- view data set
SELECT *
FROM DisneyPlus..disney_plus_titles

-- add column for duration as a numeric value
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

-- Table1 Content Type Distribution
SELECT [type], COUNT(*) AS 'Count'
FROM DisneyPlus..disney_plus_titles
GROUP BY [type];

-- Table2 Content Rating Distribution
SELECT rating, COUNT(*) AS 'Count'
FROM DisneyPlus..disney_plus_titles
WHERE rating != ''
GROUP BY rating
ORDER BY [Count] DESC;

-- Table3 Amount of Content Added per Month
SELECT CAST(YEAR(date_added) AS NVARCHAR(4)) 
        + '-' 
        + CAST(FORMAT(MONTH(date_added), '0#') AS NVARCHAR(2)) AS 'Date Added', COUNT(YEAR(date_added)) AS 'Count'
FROM DisneyPlus..disney_plus_titles
WHERE date_added IS NOT NULL
GROUP BY  CAST(YEAR(date_added) AS NVARCHAR(4)) 
        + '-' 
        + CAST(FORMAT(MONTH(date_added), '0#') AS NVARCHAR(2))
ORDER BY [Date Added] ASC;

-- Table4 Number of Seasons Distribution
SELECT CAST(duration_value AS nvarchar) AS 'Number of Seasons', COUNT(*) AS 'Number of TV Shows'
FROM DisneyPlus..disney_plus_titles
WHERE [type] = 'TV Show'
GROUP BY duration_value;

-- Table5 Length of Movies Based on the Year Released
SELECT release_year AS 'Release Year', COUNT(*) AS 'Number of Movies Released', FORMAT(ROUND(AVG(duration_value),2), '##.##') AS 'Average Length of Movies (minutes)'
FROM DisneyPlus..disney_plus_titles
WHERE [type] = 'Movie'
GROUP BY release_year
ORDER BY release_year ASC;

-- Table6 Most Common Genres
SELECT listed_in AS 'Genre(s)', COUNT(*) AS 'Count'
FROM DisneyPlus..disney_plus_titles
GROUP BY listed_in
ORDER BY COUNT(listed_in) DESC;

-- Table7 Directors that Made the Most Content
CREATE VIEW top_directors AS
SELECT TOP 10 director, COUNT(*) AS 'Count'
FROM DisneyPlus..disney_plus_titles
WHERE director != ''
GROUP BY director, [type]
ORDER BY COUNT(director) DESC

-- Table8 Genres the Top Directors Most Commonly Make
SELECT director, listed_in, COUNT(*) AS 'Count'
FROM DisneyPlus..disney_plus_titles
WHERE director != '' AND director IN (SELECT director FROM top_directors)
GROUP BY [director], listed_in
ORDER BY director, COUNT(director) DESC
