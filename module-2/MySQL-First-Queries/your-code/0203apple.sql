CREATE DATABASE lab_mysql_1stQ;
USE lab_mysql_1stQ;
-- Use the data table to query the data about Apple Store Apps and answer the following questions:

-- 1. What are the different genres?
DESCRIBE apple;
CREATE VIEW app_genre AS
SELECT DISTINCT prime_genre FROM apple;

-- 2. Which is the genre with the most apps rated?
DESCRIBE apple;
CREATE VIEW genre_most_rated AS
SELECT prime_genre, rating_count_tot FROM apple
GROUP BY prime_genre ORDER BY rating_count_tot DESC;
-- Social Networking

-- 3. Which is the genre with most apps?
DESCRIBE apple;
CREATE VIEW genre_most_apps AS
SELECT prime_genre, COUNT(prime_genre) AS genre_cnt FROM apple
GROUP BY prime_genre ORDER BY genre_cnt DESC;
-- Games

-- 4. Which is the one with least?
-- Catalogs

-- 5. Find the top 10 apps most rated.
CREATE VIEW top10_rated AS
SELECT track_name, rating_count_tot
FROM apple
ORDER BY rating_count_tot DESC
LIMIT 10;

-- 6. Find the top 10 apps best rated by users.
CREATE VIEW top10_best_rated AS
SELECT track_name, user_rating
FROM apple
ORDER BY user_rating DESC
LIMIT 10;

-- 7. Take a look at the data you retrieved in question 5. Give some insights.
create temporary table q5
SELECT track_name, prime_genre, rating_count_tot
FROM apple
ORDER BY rating_count_tot DESC
LIMIT 10;
SELECT prime_genre, COUNT(prime_genre) AS genre_cnt 
FROM q5
GROUP BY prime_genre ORDER BY genre_cnt DESC;
-- Lifestyle apps such as 'Photo& Video' and 'Social Networking' are amongst the most popular apps, following by Entertainment apps like 'Games' and 'Music'.
-- Among top 10 most rated apps, there is only one which is not related to recreation -- Bible.
-- If users of Bible and the ones of above leisure apps are largely overlapping,
-- under beather the flamboyant surface of today's fast moving society advocating individualism, maybe there's still place for traditional values.
-- More data required for further analysis.

-- 8. Take a look at the data you retrieved in question 6. Give some insights.
create temporary table q6
SELECT track_name, prime_genre, user_rating
FROM apple
ORDER BY user_rating DESC
LIMIT 10;
SELECT prime_genre, COUNT(prime_genre) AS genre_cnt 
FROM q6
GROUP BY prime_genre ORDER BY genre_cnt DESC;
-- Users seem to be most satisfied with gaming apps.
-- Game "Plants vs. Zombie" counts 20% share of top 10 best rated apps.

-- 9. Now compare the data from questions 5 and 6. What do you see?
-- Based on provided data, followed by Photo & Video editing apps, gaming apps seem to be the most used and most popular apps.

-- 10. How could you take the top 3 regarding both user ratings and number of votes?
CREATE VIEW top3_mnb_rated AS
SELECT track_name, user_rating, cont_rating
FROM apple
ORDER BY user_rating DESC, cont_rating DESC
LIMIT 3;

-- 11. Do people care about the price of an app? Do some queries, comment why are you doing them and the results you retrieve. What is your conclusion?
CREATE TEMPORARY TABLE freeapp
SELECT prime_genre, AVG(user_rating) AS avg_rating
FROM apple
WHERE price = 0
GROUP BY prime_genre ORDER BY prime_genre ASC;

CREATE TEMPORARY TABLE paidapp
SELECT prime_genre, AVG(user_rating) AS avg_rating
FROM apple
WHERE price > 0
GROUP BY prime_genre ORDER BY prime_genre ASC;

CREATE TEMPORARY TABLE FVP
SELECT prime_genre, freeapp.avg_rating AS rating_free, paidapp.avg_rating AS rating_paid
FROM freeapp 
JOIN paidapp USING (prime_genre);
SELECT AVG(rating_free) AS free, AVG(rating_paid) AS paid
FROM FVP;
-- Paid apps on average has higher ratings.
-- Rating difference could be an indicator of quality reflected by market value but further analysis is required.

