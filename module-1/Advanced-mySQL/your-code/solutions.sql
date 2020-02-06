/* Challenge 1 - Most Profiting Authors
In this challenge you'll find out who are the top 3 most profiting authors in the publications database? */
-- DROP VIEW C1S1;
USE publications;
CREATE VIEW C1S1 AS 
SELECT 
	ttas.title_id AS TITLE_ID,
    ttas.au_id AS AUTHOR_ID,
    authors.au_fname AS FIRST_NAME,
    authors.au_lname AS LAST_NAME,
    (ttas.advance * ttas.royaltyper / 100) AS ADVANCE,
    (ttas.price * sales.qty * ttas.royalty / 100 * ttas.royaltyper / 100) AS SALES_ROYALTY
FROM (SELECT 
		titles.title_id,
        titles.title,
        titles.`type`,
        titles.price,
        titles.advance,
        titles.royalty,
        titleauthor.au_id,
        titleauthor.royaltyper
		FROM publications.titles 
		LEFT JOIN publications.titleauthor 
		ON publications.titles.title_id =publications.titleauthor.title_id)ttas
LEFT JOIN publications.sales
ON publications.sales.title_id = ttas.title_id
LEFT JOIN publications.authors
ON publications.authors.au_id = ttas.au_id
-- GROUP BY AUTHOR_ID
ORDER BY AUTHOR_ID ASC, TITLE_ID ASC, ADVANCE DESC, SALES_ROYALTY DESC;
SELECT * FROM C1S1;

CREATE VIEW C1S2 AS
SELECT 
	TITLE_ID,
    AUTHOR_ID,
    FIRST_NAME,
    LAST_NAME,
    SUM(ADVANCE) AS ADVANCE,
    SUM(SALES_ROYALTY) AS ROYALTY
FROM C1S1
GROUP BY TITLE_ID, AUTHOR_ID
ORDER BY TITLE_ID ASC, ROYALTY DESC;
SELECT * FROM C1S2;

CREATE VIEW C1 AS
SELECT
	AUTHOR_ID,
    FIRST_NAME,
    LAST_NAME,
    (ADVANCE + ROYALTY) AS PROFIT
FROM C1S2
ORDER BY PROFIT DESC
LIMIT 3;
SELECT * FROM C1;

/*Challenge 2 - Alternative Solution

Creating MySQL temporary tables and query the temporary tables in the subsequent steps.
Include your alternative solution in solutions.sql.*/
CREATE TEMPORARY TABLE C2S1
SELECT 
		titles.title_id,
        titles.title,
        titles.`type`,
        titles.price,
        titles.advance,
        titles.royalty,
        titleauthor.au_id,
        titleauthor.royaltyper
FROM publications.titles 
LEFT JOIN publications.titleauthor 
ON publications.titles.title_id =publications.titleauthor.title_id
ORDER BY titleauthor.au_id;
CREATE TEMPORARY TABLE C2S2
SELECT 
	C2S1.title_id AS TITLE_ID,
    C2S1.au_id AS AUTHOR_ID,
    authors.au_fname AS FIRST_NAME,
    authors.au_lname AS LAST_NAME,
    (C2S1.advance * C2S1.royaltyper / 100) AS ADVANCE,
    (C2S1.price * sales.qty * C2S1.royalty / 100 * C2S1.royaltyper / 100) AS SALES_ROYALTY
FROM C2S1
LEFT JOIN publications.sales
ON publications.sales.title_id = C2S1.title_id
LEFT JOIN publications.authors
ON publications.authors.au_id = C2S1.au_id
ORDER BY AUTHOR_ID ASC, TITLE_ID ASC, ADVANCE DESC, SALES_ROYALTY DESC;

CREATE TEMPORARY TABLE C2S3
SELECT 
	TITLE_ID,
    AUTHOR_ID,
    FIRST_NAME,
    LAST_NAME,
    SUM(ADVANCE) AS ADVANCE,
    SUM(SALES_ROYALTY) AS ROYALTY
FROM C2S2
GROUP BY TITLE_ID, AUTHOR_ID
ORDER BY TITLE_ID ASC, ROYALTY DESC;
SELECT
	AUTHOR_ID,
    FIRST_NAME,
    LAST_NAME,
    (ADVANCE + ROYALTY) AS PROFIT
FROM C2S3
ORDER BY PROFIT DESC
LIMIT 3;
SELECT * FROM C2;
/*Challenge 3
Elevating from your solution in Challenge 1 & 2, create a permanent table named most_profiting_authors to hold the data about the most profiting authors. 
The table should have 2 columns:*/

CREATE TABLE most_profiting_authors
SELECT
	AUTHOR_ID,
    (ADVANCE + ROYALTY) AS PROFIT
FROM C2S3
ORDER BY PROFIT DESC;
SELECT *
FROM publications.most_profiting_authors
LIMIT 3;