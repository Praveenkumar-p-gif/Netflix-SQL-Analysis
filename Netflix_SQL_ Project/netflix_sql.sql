CREATE TABLE netflix
(
show_id VARCHAR(10),
showtypes VARCHAR(10),
title VARCHAR(150),
director VARCHAR(210),
casts VARCHAR(1000),
country  VARCHAR(150),
date_added  VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration  VARCHAR(55),
listed_in VARCHARVARC(100),
description varchar(250));

Select * from netflix;


-----1.Count the number of Movies vs TV Shows

SELECT showtypes,
COUNT(*)AS total_content
FROM netflix
GROUP BY showtypes


-----2. Find the most common rating for movies and TV Shows


SELECT showtypes,rating
FROM
(
SELECT showtypes,rating,COUNT(*),
RANK()OVER(PARTITION BY showtypes ORDER BY COUNT(*)DESC)AS ranking
FROM netflix
GROUP BY 1,2) AS T1
WHERE 
     ranking = 1
	 

-----3. List all movies released in a specific year(e.g.,2020)


SELECT * FROM netflix
WHERE 
showtypes = 'Movie'
AND
release_year = 2020


-----4. Find the top 5 countries with the most content on Netflix


SELECT
UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
COUNT(show_id)AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC


-----5.Identify the longer movie of TV show duration


SELECT * FROM netflix
WHERE
showtypes = 'Movie'
AND
duration = (SELECT MAX(duration)FROM netflix)


-----6.Find the content added in the last 5 years .


SELECT * FROM netflix
WHERE 
TO_DATE(date_added,'Month DD, YYYY')>= CURRENT_DATE - INTERVAL'5 years'


-----7.Find all the movies/TV Show by director'Rajiv Chilaka'


SELECT * FROM netflix
WHERE director ILIKE '%Rajiv chilaka%'


-----8.List all TV Show with more the 5 seasons


SELECT * FROM netflix
WHERE 
    showtypes = 'TV Show'
	AND
	Split_part(duration,' ',1)::numeric > 5 
	

-----9.Count the number of content items in each genre

SELECT 
UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
COUNT(show_id)AS total_content
FROM netflix
GROUP BY 1


-----10.Find thr average release year for cotent produced in a specific country


SELECT 
EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD ,YYYY')) AS year,
COUNT(*),
ROUND(
COUNT(*)::numeric/(SELECT COUNT(*)FROM netflix WHERE country = 'India')::numeric * 100
,2) As avg_content_per_year
FROM netflix
WHERE
   country = 'India'
GROUP BY 1


-----11.List all movies that are documentaries


SELECT * FROM netflix
WHERE
   listed_in ILIKE '%documentari%'
   

-----12.Find a;; content without a director


SELECT * FROM netflix
WHERE
director IS null
   

-----13.Find how many movies actor'Salman Khan' apperaed in lasr 10 years!


SELECT * FROM netflix
WHERE 
    casts ILIKE '%Salman khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE)-10


-----14.Find the top 10 actors who have appeared in the highest number pf movies produced in india


SELECT 
UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
COUNT(*)AS total_content
FROM netflix
WHERE
   country LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


-----15.Categorize the content based on the presence of the keywords'kill' and 'violence' in the description field.Lable content containing thes keywords as 'Bad' and all other content 'Good'.Count how many items fall into each category.


WITH new_table
AS
(
SELECT *,
     CASE
	 WHEN
	    Description ILIKE '%kill%' OR
		Description ILIKE '%viloence%' THEN 'Bad_content'
	ELSE
	    'Good_content'
	END category
FROM netflix
)
SELECT category,
COUNT(*) AS total_content
FROM new_table
GROUP BY 1

	

