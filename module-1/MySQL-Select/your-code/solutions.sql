-- 1. From the client table, what are the ids of the first 5 clients from disrict_id 1?
SELECT client_id FROM bank.client WHERE district_id = 1 LIMIT 5;
-- 2/3/22/23/28

-- 2. From the client table, what is the id of the last client from district_id 72?
SELECT client_id FROM bank.client WHERE district_id = 72 ORDER BY client_id DESC;
-- 13576

-- 3. From the loan table, what are the 3 lowest amounts?
SELECT amount FROM bank.loan ORDER BY amount LIMIT 3;
-- 4980/5148/7656

-- 4. From the loan table, what are the possible values for status, ordered alphabetically in ascending order?
SELECT loan.status FROM bank.loan ORDER BY loan.status ASC;

-- 5. From the loans table, what is the loan_id of the highest payment received?
SELECT loan.loan_id FROM bank.loan WHERE loan.payments = (SELECT MAX(loan.payments) FROM bank.loan);
-- 6415

-- 6. From the loans table, what is the loan amount of the lowest 5 account_ids. Show the account_id and the corresponding amount
SELECT loan.account_id, loan.amount FROM bank.loan ORDER BY loan.account_id LIMIT 5;

-- 7. From the loans table, which are the account_ids with the lowest loan amount have a loan duration of 60?
SELECT loan.account_id FROM bank.loan WHERE loan.duration = 60 ORDER BY loan.amount LIMIT 5; 

-- 8. From the order table, what are the unique values of k_symbol?
SELECT DISTINCT k_symbol FROM bank.`order` ORDER BY k_symbol;

-- 9. From the order table, which are the order_ids from the client with the account_id34?
SELECT `order`.order_id FROM bank.`order` WHERE `order`.account_id = 34 ORDER BY order_id;

-- 10. From the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?
SELECT `order`.account_id FROM bank.`order` WHERE order_id BETWEEN 29540 AND 29560 ORDER BY account_id;

-- 11. From the order table, what are the individual amounts that were sent to (account_to) id 30067122?
SELECT `order`.amount FROM bank.`order` WHERE `order`.account_to = 30067122 ORDER BY amount;

-- 12. From thSe trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id = 793 in chronological order, from newest to oldest.
SELECT trans.trans_id, trans.`date`, trans.`type`, trans.amount FROM bank.`trans` WHERE trans.account_id = 793 ORDER BY trans.`date` LIMIT 10;