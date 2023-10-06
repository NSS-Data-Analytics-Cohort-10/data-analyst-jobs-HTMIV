-- 1.	How many rows are in the data_analyst_jobs table?
SELECT 
  COUNT(*) 
FROM 
  data_analyst_jobs;

-- 1793

-- 2.	Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?

SELECT 
* 
FROM 
 data_analyst_jobs
LIMIT(10);

-- ExxonMobil

-- 3.	How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?
SELECT
 SUM(CASE WHEN UPPER(location) = 'TN' THEN 1 ELSE 0 END) posting_TN,
 SUM(CASE WHEN UPPER(location) in ('TN','KY') THEN 1 ELSE 0 END) posting_TN_KY
FROM 
 data_analyst_jobs;

-- TN = 21
-- TN or KY = 27

-- 4.	How many postings in Tennessee have a star rating above 4?

SELECT 
 COUNT(*) 
FROM 
 data_analyst_jobs 
WHERE  
 star_rating > 4 AND location ='TN'

-- 3

-- 5.	How many postings in the dataset have a review count between 500 and 1000?

SELECT 
 COUNT(*) 
FROM 
 data_analyst_jobs 
WHERE 
 review_count between  500 and 1000 ;

-- 151

-- 6.	Show the average star rating for companies in each state. The output should show the state as `state` and the average rating for the state as `avg_rating`. Which state shows the highest average rating?

/*
This is a select to get average rating by State.
*/
SELECT
 CASE WHEN location IS NULL THEN '*STATE UNASSIGNED'
 ELSE LOCATION END state,
 AVG(CASE
 WHEN star_rating IS NULL THEN 0 
 ELSE star_rating END)avg_rating
FROM 
 data_analyst_jobs
GROUP BY 
 location
ORDER BY
 location;

/*
This is a select gets the sate.
*/

WITH X AS (
SELECT
 CASE WHEN location IS NULL THEN '*STATE UNASSIGNED'
 ELSE LOCATION END state,
 AVG(CASE
 WHEN star_rating IS NULL THEN 0 
 ELSE star_rating END)avg_rating
FROM 
 data_analyst_jobs
GROUP BY 
 location
ORDER BY
 location) 
SELECT 
 X.state 
FROM X
WHERE avg_rating =
 (SELECT MAX(avg_rating) 
 FROM (
 SELECT
 CASE WHEN location IS NULL THEN '*STATE UNASSIGNED'
 ELSE LOCATION END state,
 AVG(CASE
 WHEN star_rating IS NULL THEN 0 
 ELSE star_rating END)avg_rating
FROM 
 data_analyst_jobs
GROUP BY 
 location))
 
-- NE
 
-- 7.	Select unique job titles from the data_analyst_jobs table. How many are there?


SELECT 
 COUNT(DISTINCT(UPPER(title)))
FROM 
 data_analyst_jobs 

-- 877

-- 8.	How many unique job titles are there for California companies?

SELECT 
 COUNT(DISTINCT(UPPER(title)))
FROM 
 data_analyst_jobs 
WHERE
 UPPER(location) ='CA'
 
-- 229

-- 9.	Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?

SELECT 
 CASE
 WHEN company IS NULL THEN '*UNASSIGNED COMPANY'
 ELSE UPPER(company) END company , 
 AVG(star_rating) avg_rating
FROM  
 data_analyst_jobs
WHERE 
 review_count > 5000 AND company is not null 
GROUP BY
 company;

/*
How many companies are there with more that 5000 reviews across all locations?
*/
SELECT 
COUNT(DISTINCT(UPPER(company)))
FROM  
 data_analyst_jobs
WHERE 
 review_count > 5000 AND company IS NOT NULL
 
-- 40

-- 10.	Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?
SELECT 
 TM.company,
 TM.avg_rating 
FROM (
SELECT 
 CASE
 WHEN company IS NULL THEN '*UNASSIGNED COMPANY'
 ELSE UPPER(company) END company , 
 AVG(star_rating) avg_rating
FROM  
 data_analyst_jobs
WHERE 
 review_count > 5000 AND company is not null
GROUP BY
 company
ORDER BY avg_rating DESC, company ASC) TM
WHERE 
TM.avg_rating =
(SELECT 
MAX(avg_rating) FROM (
SELECT 
 CASE
 WHEN company IS NULL THEN '*UNASSIGNED COMPANY'
 ELSE UPPER(company) END company , 
 AVG(star_rating) avg_rating
FROM  
 data_analyst_jobs
WHERE 
 review_count > 5000 AND company is not null
GROUP BY
 company
ORDER BY avg_rating DESC, company ASC))

-- AMERICAN EXPRESS, GENERAL MOTORS,KAISER PERMANENTE,MICROSOFT,NIKE,UNILEVER
-- 4.1999998090000000

--11.	Find all the job titles that contain the word ‘Analyst’. How many different job titles are there? 

/*
select to find all job titles that contain the word ‘Analyst'
*/

SELECT 
  title
FROM 
 data_analyst_jobs 
WHERE
 UPPER(title) like '%ANALYST%';
 
/*
How many different job titles are there?
*/ 

SELECT 
 COUNT(DISTINCT(UPPER(title))) COUNT
FROM 
 data_analyst_jobs 
WHERE
 UPPER(title) like '%ANALYST%';

-- 770

-- 12.	How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?

/*
How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? 
*/

SELECT 
	  COUNT(DISTINCT(UPPER(title))) COUNT
FROM 
	 data_analyst_jobs 
WHERE
	UPPER(title) not like '%ANALYST%' and 
	UPPER(title) not like '%ANALYTICS%';

-- 4

/*
What word do these positions have in common?
*/

SELECT 
  title
FROM 
 data_analyst_jobs 
WHERE
 UPPER(title) not like '%ANALYST%' AND
 UPPER(title) not like '%ANALYTICS%';

-- Tableau

-- **BONUS:**
-- You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks. 
-- Disregard any postings where the domain is NULL. 
-- Order your results so that the domain with the greatest number of `hard to fill` jobs is at the top. 
SELECT 
 UPPER(DOMAIN) DOMAIN,
 COUNT(*) COUNTS
FROM 
 data_analyst_jobs 
WHERE 
 UPPER(skill) like '%SQL%' AND 
 days_since_posting > 21 AND DOMAIN IS NOT NULL
GROUP BY
 DOMAIN
 ORDER BY COUNTS DESC
LIMIT (4);

--  Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4?

--INTERNET AND SOFTWARE(62), BANKS AND FINANCIAL SERVICES(61), CONSULTING AND BUSINESS SERVICES(57), HEALTH CARE(52)

/*
How many jobs have been listed for more than 3 weeks for each of the top 4?
*/

SELECT
  SUM(COUNTS) TOTAL 
FROM(
SELECT 
  UPPER(DOMAIN) DOMAIN,
  COUNT(*) COUNTS
FROM 
 data_analyst_jobs 
WHERE 
 UPPER(skill) like '%SQL%' AND 
 days_since_posting > 21 AND 
 DOMAIN IS NOT NULL
GROUP BY
 DOMAIN
 ORDER BY COUNTS DESC
LIMIT (4));

-- 232





