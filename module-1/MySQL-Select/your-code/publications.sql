USE publications;
-- Challenge 1 - Who Have Published What At Where?
-- In this challenge you will write a MySQL SELECT query that joins various tables to figure out what titles each author has published at which publishers. 
-- CREATE TEMPORARY TABLE AB
CREATE VIEW c1_subquery AS
SELECT
	b.au_id AS 'Author ID',
	b.au_lname AS 'Last Name',
	b.au_fname AS 'First Name',
	b.title AS 'Title',
	publishers.pub_name AS 'Publisher'
FROM    (SELECT 
		a.au_id,
		a.au_lname,
		a.au_fname,
		titles.title,
		titles.pub_id    
	FROM (SELECT 
			authors.au_id, 
			authors.au_lname, 
			authors.au_fname, 
			titleauthor.title_id  
		FROM publications.authors
		INNER JOIN publications.titleauthor
		ON publications.authors.au_id = publications.titleauthor.au_id) AS a
	INNER JOIN publications.titles
	ON publications.a.title_id = publications.titles.title_id) as b
INNER JOIN publications.publishers
ON publications.b.pub_id = publications.publishers.pub_id;

CREATE VIEW simplified AS 
SELECT 
	A.au_id AS 'AUTHOR ID', 
    A.au_lname AS 'LAST NAME', 
    A.au_fname AS 'FIRST NAME',  
    T.title AS 'TITLE',
    P.pub_name AS 'PUBLISER'
FROM publications.authors AS A
INNER JOIN publications.titleauthor AS TA
ON A.au_id = TA.au_id
INNER JOIN publications.titles AS T
ON TA.title_id = T.title_id
INNER JOIN publications.publishers AS P
ON T.pub_id = P.pub_id;
-- If your query is correct, the total rows in your output should be the same as the total number of records in Table titleauthor.
-- SELECT COUNT(*) FROM publications.simplified;
-- 25
-- SELECT COUNT(*) FROM publications.titleauthor;
-- 25

-- Challenge 2 - Who Have Published How Many At Where?
-- Elevating from your solution in Challenge 1, query how many titles each author has published at each publisher. 
-- To check if your output is correct, sum up the TITLE COUNT column. The sum number should be the same as the total number of records in Table titleauthor.
-- Hint: In order to count the number of titles published by an author, you need to use MySQL COUNT. Also check out MySQL Group By because you will count the rows of different groups of data. Refer to the references and learn by yourself. These features will be formally discussed in the Temp Tables and Subqueries lesson.

