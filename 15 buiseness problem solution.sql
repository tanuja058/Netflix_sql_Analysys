DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
(
show_id VARCHAR (6),
type  VARCHAR(10),
title  VARCHAR(150),
director VARCHAR (208),
castS  VARCHAR(1000),
country  VARCHAR (150),
date_added VARCHAR (50),
release_year INT,
rating VARCHAR (10),
Duration VARCHAR(15),
listed_in VARCHAR (100),
description VARCHAR (250)
);

SELECT * FROM netflix 

SELECT 
     COUNT(*) as total_content 
FROM netflix;

SELECT 
     DISTINCT type
FROM netflix;

SELECT * FROM netflix;

--15 buiseness problems 

-- 1. Count the number of movies vs Tv Shows 
SELECT 
     type,
	 COUNT (*) as total_content
FROM netflix
Group By type;

--2.find the most common rating for movies and tv shows 
SELECT 
     type,
	 rating
FROM
(
SELECT 
    type,
	rating,
	COUNT (*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT (*))as ranking
FROM netflix
GROUP BY 1,2
) as t1
Where 
    ranking =1 ;

-- 3. List all movies released in 2020
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;

-- 4. Top 5 countries with most content
SELECT 
     UNNEST (STRING_TO_ARRAY(country,',')) as new_country,
	 COUNT (show_id) as  total_content
FROM netflix 
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 5;

--5.Indentify the longest movie?

SELECT * From netflix
WHERE 
    type = 'movie'
	AND
	duration = (SELECT MAX (duration) FROM netflix);

-- 6. Content added in last 5 years
SELECT *
FROM netflix
WHERE  TO_DATE (date_added, 'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 years';

-- 7.Find all the movies /Tv Shows  by  director Rajiv Chilaka
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- 8. list all TV Shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND 
  SPLIT_PART(duration, ' ', 1):: numeric > 5;

-- 9. Count the number of content items in each genre
SELECT
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;

-- 10. find each year and the Average number of content releases in India on Netflix .return top 5 year with highest avg content release
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS total_content,
    COUNT(*) * 100.0 / (
        SELECT COUNT(*)
        FROM netflix
        WHERE country ILIKE '%India%'
    ) AS percentage_content_per_year
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 1;

-- 11. List all movies that are documentaries
SELECT *
FROM netflix
WHERE type = 'Movie'
  AND listed_in ILIKE '%Documentaries%';

--12 find all content without a director 

SELECT * FROM NETFLIX
WHERE
    director IS NULL ;

--13. find how many movies actor 'Salman Khan' appeared in last 10 years 
SELECT * 
FROM netflix 
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

14.Find the top 10 actors who have appeared in the highest number of movies produced in india

SELECT 
UNNEST (STRING_TO_ARRAY(casts, ','))as actors,
COUNT (*) as total_content
FROM netflix
WHERE COUNTRY ILIKE '%india%'
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 10;

-- 15.Categorize the content based on the prasence of the keyword 'kill' AND 'voilence' in the description field. label content containing these keywords as 'bad' and all other content as 'good'.
--count how many items fall into each category .

SELECT
    category,
    COUNT(*) AS total_content
FROM (
    SELECT
        CASE
            WHEN COALESCE(description, '') ILIKE '%kill%'
              OR COALESCE(description, '') ILIKE '%violence%'
            THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) t
GROUP BY category;



