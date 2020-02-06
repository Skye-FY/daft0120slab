-- 1. From the client table, of all districts with a district_id lower than 10, how many clients are from each district_id? Show the results sorted by district_id in ascending order.
CREATE VIEW district AS
SELECT `client`.district_id, COUNT(`client`.district_id) AS district_count  
FROM bank.`client` 
WHERE `client`.district_id < 10
GROUP BY `client`.district_id
ORDER BY `client`.district_id ASC;

-- 2. From the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
CREATE VIEW card_type AS
SELECT card.`type`, COUNT(card.`type`) AS type_cnt
FROM bank.card
GROUP BY card.`type`
ORDER BY type_cnt DESC;

-- 3. Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
CREATE VIEW top10_loanid AS
SELECT loan.account_id, SUM(loan.amount) AS amt_sum
FROM bank.loan
GROUP BY loan.account_id
ORDER BY amt_sum DESC
LIMIT 10;

-- 4. From the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order
CREATE VIEW loan_issued AS
SELECT loan.`date`, COUNT(*) AS issued
FROM bank.loan
WHERE loan.`date` < 930907
GROUP BY loan.`date`
ORDER BY loan.`date` DESC;

-- 5. From the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.
CREATE VIEW issue_tims AS
SELECT loan.`date`, loan.duration, COUNT(loan.`duration`) AS issued
FROM bank.loan
WHERE 
	loan.`date` >= 971201
    AND loan.`date` <980101
GROUP BY loan.`date`
ORDER BY loan.`date`, loan.duration ASC;

-- 6. From the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
CREATE VIEW sum396 AS
SELECT trans.account_id, trans.`type`, SUM(trans.amount) AS total_amount
FROM bank.trans
WHERE trans.account_id = 396 
GROUP BY trans.account_id, trans.`type`
ORDER BY trans.`type` ASC;

-- 7. From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer
CREATE VIEW Q7 AS
SELECT 
	trans.account_id,
    IF(type = 'PRIJEM', 'INCOMING', 'OUTGOING') AS transaction_type,
    FLOOR(SUM(amount)) AS total_amount
FROM bank.trans
WHERE trans.account_id = 396
GROUP BY trans.account_id, type
ORDER BY total_amount;

-- 8. From the previous result, modify you query so that it returns only one row, 
-- with a column for incoming amount, outgoing amount and the difference
CREATE VIEW Q8 AS
SELECT
	i.account_id AS ACCOUNT_ID,
    i.incoming_amount AS INCOMING_AMOUNT,
    o.outgoing_amount AS OUTGOING_AMOUNT,
    (i.incoming_amount - o.outgoing_amount) AS DIFFERENCE
FROM (SELECT account_id,
    total_amount AS incoming_amount
	FROM bank.Q7
    WHERE transaction_type = 'INCOMING') i
INNER JOIN
	(SELECT account_id,
    total_amount AS outgoing_amount
	FROM bank.Q7
    WHERE transaction_type = 'OUTGOING') o
    ON i.account_id = o.account_id;

-- 9. Continuing with the previous example, rank the top 10 account_ids based on their difference


SELECT
	i.account_id AS ACCOUNT_ID,
    (i.incoming_amount - o.outgoing_amount) AS DIFFERENCE
FROM (SELECT 
		f.account_id,
		f.total_amount AS incoming_amount
		FROM (SELECT 
				trans.account_id,
				IF(type = 'PRIJEM', 'INCOMING', 'OUTGOING') AS transaction_type,
				FLOOR(SUM(amount)) AS total_amount
                FROM bank.trans
                GROUP BY trans.account_id, transaction_type
				ORDER BY total_amount) f
		WHERE transaction_type = 'INCOMING') i
INNER JOIN
	(SELECT 
		f.account_id,
		f.total_amount AS outgoing_amount
		FROM (SELECT 
				trans.account_id,
				IF(type = 'PRIJEM', 'INCOMING', 'OUTGOING') AS transaction_type,
				FLOOR(SUM(amount)) AS total_amount
                FROM bank.trans
                GROUP BY trans.account_id, transaction_type
				ORDER BY total_amount) f
		WHERE transaction_type = 'OUTGOING') o
    ON i.account_id = o.account_id
ORDER BY DIFFERENCE DESC
LIMIT 10;
