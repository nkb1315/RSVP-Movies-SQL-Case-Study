USE imdb;
show tables;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    'director_mapping' AS Table_Name, COUNT(*) AS RowCount
FROM
    director_mapping 
UNION ALL SELECT 
    'genre' AS Table_Name, COUNT(*) AS RowCount
FROM
    genre 
UNION ALL SELECT 
    'movie' AS Table_Name, COUNT(*) AS RowCount
FROM
    movie 
UNION ALL SELECT 
    'names' AS Table_Name, COUNT(*) AS RowCount
FROM
    names 
UNION ALL SELECT 
    'ratings' AS Table_Name, COUNT(*) AS RowCount
FROM
    ratings 
UNION ALL SELECT 
    'role_mapping' AS Table_Name, COUNT(*) AS RowCount
FROM
    role_mapping;
    

/* From the above code I found the following result:
Table_Name           RowCount
-------------------------------
director_mapping	3867
genre				14662
movie				7997
names				25735
ratings				7997
role_mapping		15615

*/


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS id_null,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_null,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_null,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_null,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_null,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_null,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worlwide_gross_income_null,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_null,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_null
FROM
    movie;
    
/* In the movie table the following columns have null values:
country
languages
production_company
worlwide_gross_income

*/


-- Now as you can see four columns of the movie table has null values. Let's look at the movies released each year. 

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Code for first part

SELECT 
    year AS Year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year;


/* Following is the output for the first part of the question
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944	.		|
|	2019		|	2011	.		|
+---------------+-------------------+

*/

-- Code for second part

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;

/* Following is the output for the second part of the question
month_num      number_of_movies
	1				804
	2				640
	3				824
	4				680
	5				625
	6				580
	7				493
	8				678
	9				809
	10				801
	11				625
	12				438
    
    From The Above Analysis we can also deduce that Highest Number of Movies are released in the month of March.
	While Least Number of Movies are released in the month of December.
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(id) AS Movies_USA_India_2019
FROM
    movie
WHERE
    (country LIKE '%India%'
        OR country LIKE '%USA%')
        AND year = 2019;

/* In the year 2019, 1059 movies were produced in USA and India.*/


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre
FROM
    genre;

/* Unique list of of Genres are:
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others

*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT 
    genre, 
    COUNT(m.title) AS No_of_movies
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY No_of_movies DESC
LIMIT 1;

/* 4285 movies were produced on the 'Drama' Genre. */

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre AS
(
SELECT 
    movie_id
FROM
    genre
GROUP BY movie_id
HAVING COUNT(genre) = 1
)
SELECT 
    COUNT(*) AS No_of_movies
FROM
    one_genre;


/* 3289 movies belong to only one kind of genre */


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
    genre, 
    Round(Avg(duration),2) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration;


/* Horror moives have the shortest average duration while Action movies have the longest duration. 
   Maximum genres have average duration of more than 100 mintues.
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank
     AS (SELECT genre,
                Count(m.id) AS movie_count,
                Rank() OVER( ORDER BY Count(m.id) DESC) AS genre_rank
         FROM   movie m
                INNER JOIN genre g
                        ON m.id = g.movie_id
         GROUP  BY genre)
SELECT *
FROM   genre_rank
WHERE  genre = 'Thriller';
  
  
/* This Query was same as that of Question 6 in which we counted Genre wise movies.
	Except this time we calculated Rank
    And Thriller movies gets the 3rd Rank. 
    Following is the output:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|Thriller		|	1484			|			3		  |
+---------------+-------------------+---------------------+*/
 

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;

/* Following is the output for the above query:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|		10.0	    |	       100		  |	   725138   		 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


SELECT     m.title,
           r.avg_rating,
           ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id 
LIMIT 10;

/* Following is the output for the above query:
title						avg_rating			movie_rank
------------------------------------------------------------
Kirket							10.0				1
Love in Kilnerry				10.0				2
Gini Helida Kathe				9.8					3
Runam							9.7					4
Fan								9.6					5
Android Kunjappan Version 5.25	9.6					6
Yeh Suhaagraat Impossible		9.5					7
Safe							9.5					8
The Brighton Miracle			9.5					9
Shibu							9.4					10
*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, 
    COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;

/* Maximum number of movies have a median rating of 7.*/ 


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH hit_movies AS
(
SELECT production_company,
       Count(m.id) AS movie_count,
       Dense_rank() OVER (ORDER BY Count(m.id) DESC) AS prod_company_rank
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  production_company IS NOT NULL
       AND avg_rating > 8
GROUP  BY production_company
)
SELECT *
FROM hit_movies
WHERE prod_company_rank = 1;
     
-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

/* We found that two production comapanies have same number of hit movies:
'Dream Warrior Pictures' and 'National Theatre Live' */



-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT g.genre,
       Count(m.id) AS movie_count
FROM   genre g
       INNER JOIN movie m
               ON g.movie_id = m.id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  ( country LIKE '%USA%' )
       AND year = 2017
       AND Month(date_published) = 3
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

/* Following is the output for the above query:
genre				movie_count
------------------------------------
Drama					24
Comedy					9
Action					8
Thriller				8
Sci-Fi					7
Crime					6
Horror					6
Mystery					4
Romance					4
Fantasy					3
Adventure				3
Family					1

USA had produced mostly Drama movies in 2017 in the month of March with more than 1000 votes.   */


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title, 
    r.avg_rating, 
    g.genre
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    genre g ON r.movie_id = g.movie_id
WHERE
    m.title LIKE 'The%' 
    AND r.avg_rating > 8
ORDER BY avg_rating DESC;


/* There are 15 movies starting with "The" and having an average rating > 8.
   The Drama genre has the top 3 movies.
   One Thing To Note That We Have Some Movies Belonging to Different Genre Have Come More Than 1 Times.
	This is Because Question Asked Had only mention of 'THe' Expression & Rating > 8. */


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(m.id) AS no_of_movies
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01';

/* 361 movies were released between 1 April 2018 and 1 April 2019 having median rating of 8. */


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- This query can be solved using two approaches:
-- Approach 1 : query based on language column
-- Approach 2 : query based on country column


-- Code for query based on Approach 1

SELECT SUM(CASE
             WHEN m.languages LIKE '%german%' THEN r.total_votes
           end) AS german_votes,
       SUM(CASE
             WHEN m.languages LIKE '%italian%' THEN r.total_votes
           end) AS italian_votes
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id;
 

/* Following is the output for the Approach 1 query :
	german_votes	italian_votes
    ----------------------------------
	4421525			  2559540              */

-- Code for query based on Approach 2

SELECT SUM(CASE
             WHEN m.country LIKE '%germany%' THEN r.total_votes
           end) AS germany_votes,
       SUM(CASE
             WHEN m.country LIKE '%italy%' THEN r.total_votes
           end) AS italy_votes
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id;
 
/* Following is the output for the Approach 2 query :
germany_votes         italy_votes 
-------------------------------------------
  2026223				703024 					*/

/* So if we approach the query by language wise or country wise German movies are way more popular than Italian Movies. */

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:

-- Q18. Which columns in the names table have null values?

/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;

/* Following is the output for the above query:
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|	   17335 		|	     13431  	   |	      15226	     |
+---------------+-------------------+---------------------+----------------------+  */



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top3_genre AS
(
SELECT
    genre, Count(m.id) AS no_of_movies,
    Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
    INNER JOIN ratings r
    ON r.movie_id = m.id
    WHERE avg_rating>8
GROUP BY genre
limit 3
)
SELECT
    n.NAME AS director_name,
    Count(m.id) AS movie_count
FROM
    movie m
INNER JOIN
    director_mapping d ON m.id = d.movie_id
INNER JOIN
    names n ON n.id = d.name_id
INNER JOIN
    genre g ON g.movie_id = m.id
INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE g.genre IN ( SELECT genre FROM top3_genre)
AND avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
limit 3;

/* So Approach was to first find top 3 genres based on movie count.
	Then Find The Name Of Directors who have Directed most no. of movies in those genres.
    We found the following result:
    director_name				movie_count
    --------------------------------------------
    James Mangold					4
	Anthony Russo					3
	Joe Russo	    				3               */


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    n.name AS actor_name,
    COUNT(m.id) AS movie_count
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    role_mapping rm ON m.id = rm.movie_id
        INNER JOIN
    names n ON n.id = rm.name_id
WHERE
    median_rating >= 8
    and category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/* Again Approach was to Find Names & Movie Count & filter it based on median rating & Category
	We found the following result:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Mammootty  	|		8			|
|Mohanlal		|		5			|
+---------------+-------------------+ */


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	   Sum(total_votes) AS vote_count,
	   Row_number() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
GROUP BY production_company
limit 3;     

/* Following is the output for the above query:
+-----------------------+-------------------+---------------------+
|production_company		|		vote_count	|		prod_comp_rank|
+-----------------------+-------------------+---------------------+
| Marvel Studios		|		2656967		|		1	  		  |
|Twentieth Century Fox	|		2411163		|		2		  	  |
|Warner Bros.			|		2396057		|		3		  	  |
+-------------------+-------------------+---------------------+*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT n.NAME AS actor_name,
		Sum(total_votes) AS total_votes,
		Count(m.id) AS movie_count,
		Round(Sum(r.total_votes * r.avg_rating)/Sum(r.total_votes) , 2 ) AS actor_avg_rating,
		Rank() OVER (ORDER BY Round(Sum(r.total_votes * r.avg_rating)/Sum(r.total_votes) , 2 ) DESC ) AS actor_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN role_mapping rm
ON m.id = rm.movie_id
INNER JOIN names n
ON n.id = rm.name_id
WHERE country LIKE '%India%'
	AND category = 'Actor'
GROUP BY actor_name
HAVING movie_count>=5
LIMIT 1;

/* We found that actor Vijay Sethupathi is at top of the list */

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.NAME AS actress_name,
		Sum(total_votes) AS total_votes,
		Count(m.id) AS movie_count,
		Round(Sum(r.total_votes * r.avg_rating)/Sum(r.total_votes) , 2 ) AS actress_avg_rating,
		Rank() OVER (ORDER BY Round(Sum(r.total_votes * r.avg_rating)/Sum(r.total_votes) , 2 ) DESC ) AS actress_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN role_mapping rm
ON m.id = rm.movie_id
INNER JOIN names n
ON n.id = rm.name_id
WHERE country LIKE '%India%'
	AND category = 'Actress'
    AND languages like '%Hindi%'
GROUP BY actress_name
HAVING movie_count>=3
LIMIT 5;

/* We found that actress Taapsee Pannu is at top of the list */


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 
    title,
    avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS Movie_category
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    genre g ON g.movie_id = m.id
WHERE
    genre = 'Thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
     Round(Avg(duration),2) AS avg_duration,
     Sum(Round(Avg(duration),2)) OVER (ORDER BY genre) AS running_total_duration,
     Round(Avg(Round(Avg(duration), 2)) OVER (ORDER BY genre) ,2) AS moving_avg_duration
FROM
    movie AS m
INNER JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY
    genre
ORDER BY
    genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- First  CTE is created to get the top 3 genres with highest number of movies

with top3_genre AS
(
SELECT
    genre, 
    count(m.title) AS no_of_movies
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY no_of_movies DESC
limit 3
),
-- Creating another CTE for getting the top five movies from each of the top three genres for each year based on worldwide gross income
top5_movies AS
(
SELECT  g.genre,
		m.year,
        m.title as movie_name,
        m.worlwide_gross_income,
        row_number() OVER (partition BY m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
FROM movie m
INNER JOIN genre g
ON m.id = g.movie_id
WHERE genre IN (SELECT genre FROM top3_genre)
)
-- merging the CTE's to get the required result
SELECT 
    *
FROM
    top5_movies
WHERE
    movie_rank <= 5;

/* The top 3 genres are Drama, Thriller and Comedy.*/


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
    Count(m.id) AS movie_count,
        Rank() OVER (ORDER BY Count(m.id) DESC) AS prod_comp_rank
FROM movie m
        INNER JOIN ratings r
        ON m.id = r.movie_id
        WHERE median_rating >=8
        AND position(',' IN languages) > 0 -- Movies with multiple languages
        AND production_company IS NOT NULL
    GROUP BY
        production_company
        LIMIT 2;

/* Star Cinema and Twentieth Century Fox are top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies. */


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.NAME AS actress_name,
    Sum(total_votes) AS total_votes,
        Count(m.id) AS movie_count,
        Round(Sum(r.total_votes * r.avg_rating)/Sum(r.total_votes) , 2 ) AS actress_avg_rating,
    Rank() OVER (ORDER BY Count(m.id) DESC) AS actress_rank
FROM movie m
INNER JOIN ratings r
ON m.id = r.movie_id
INNER JOIN role_mapping rm
ON m.id = rm.movie_id
INNER JOIN names n
ON n.id = rm.name_id
INNER JOIN genre g
ON g.movie_id = m.id
WHERE category = 'Actress'
    AND avg_rating > 8
    AND genre = 'Drama'
GROUP BY actress_name
LIMIT 3;

/*Following is the output for the above query
+-----------------------+-------------------+---------------------+----------------------+-----------------+
| actress_name			|	total_votes		|	movie_count		  |  actress_avg_rating	 |actress_rank	   |
+-----------------------+-------------------+---------------------+----------------------+-----------------+
|   Parvathy Thiruvothu |		4974		|	       2		  |	  	8.25		     |		1	       |
|	Susan Brown			|		656			|	       2	 	  |	    8.94		 	 |		1          |
|	Amanda Lawrence		|	    656		 	|	 	   2	  	  |	    8.94    		 |		1          |
+---------------+-------------------+---------------------+----------------------+-----------------+*/



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH nextdate AS
(
SELECT dm.name_id AS director_id,
  n.NAME AS director_name,
    dm.movie_id,
    m.duration,
    r.avg_rating,
    total_votes,
    m.date_published,
    Lead(m.date_published, 1) OVER (partition BY dm.name_id ORDER BY m.date_published, dm.movie_id) AS next_date_published
FROM director_mapping dm
INNER JOIN names n
ON n.id = dm.name_id
INNER JOIN movie m
ON m.id = dm.movie_id
INNER JOIN ratings r
ON r.movie_id = dm.movie_id
),
top_director AS
(
SELECT *,
    Datediff(next_date_published,date_published) AS date_difference
        FROM nextdate
        )
SELECT director_id,
  director_name,
    Count(movie_id) AS number_of_movies,
    Round(Avg(date_difference),2) AS avg_inter_movie_days,
    Round(Avg(avg_rating), 2) AS avg_rating,
    Sum(total_votes) AS total_votes,
    Min(avg_rating) AS min_rating,
    Max(avg_rating) AS max_rating,
    Sum(duration) AS total_duration
    FROM top_director
    GROUP BY director_id
    ORDER BY number_of_movies DESC
    LIMIT 9;

