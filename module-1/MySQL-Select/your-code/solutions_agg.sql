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
SELECT loan.account_id, loan.amount
FROM bank.loan
GROUP BY loan.account_id
ORDER BY loan.amount DESC
LIMIT 10;

-- 4. From the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order
CREATE VIEW loan_issued AS
SELECT loan.`date`, COUNT(loan.`date`) AS issued
FROM bank.loan
WHERE loan.`date` < 930907
GROUP BY loan.`date`
ORDER BY loan.`date` DESC;

-- 5. From the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. You can ignore days without any loans in your output.
CREATE VIEW issue_tims AS
SELECT loan.`date`, loan.duration, COUNT(loan.`duration`) AS issued
FROM bank.loan
GROUP BY loan.`date`
ORDER BY loan.`date`, loan.duration ASC;

-- 6. From the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
CREATE VIEW sum396 AS
SELECT trans.account_id, trans.`type`, SUM(trans.amount) AS total_amount
FROM bank.trans
WHERE trans.account_id = 396
ORDER BY trans.`type` ASC;

-- 7. From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer
-- UPDATE bank.trans
-- SET trans.`type` = 'OUTGOING'
-- WHERE trans.account_id = 396;

-- 8. From the previous result, modify you query so that it returns only one row, with a column for incoming amount, outgoing amount and the difference

-- 9. Continuing with the previous example, rank the top 10 account_ids based on their difference
-- SELECT trans.account_id, trans.amt_difference
-- FROM bank.trans
-- ORDER BY trans.amt_difference DESC
-- LIMIT 10;