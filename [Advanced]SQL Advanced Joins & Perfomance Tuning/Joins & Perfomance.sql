/*
each account who has a sales rep and each sales rep 
that has an account (all of the columns in these 
returned rows will be full)
*/
SELECT *
  FROM accounts
 FULL JOIN sales_reps ON accounts.sales_rep_id = sales_reps.id;
 
/*
write a query that left joins the accounts table and
the sales_reps tables on each sale rep's ID number and
joins it using the < comparison operator on 
accounts.primary_poc and sales_reps.name
*/

SELECT a.name, a.primary_poc, s.name
FROM accounts a
LEFT JOIN sales_reps s
ON a.sales_rep_id = s.id
AND a.primary_poc < s.name;

/*
Modify the query from the previous video, which is 
pre-populated in the SQL Explorer below, to perform 
the same interval analysis except for the web_events 
table.
*/

SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occurred_at AS we1_occurred_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occurred_at AS we2_occurred_at,
       we2.channel AS we2_channel
  FROM web_events we1 
 LEFT JOIN web_events we2
   ON we1.account_id = we2.account_id
  AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day'
ORDER BY we1.account_id, we2.occurred_at;

/*
Write a query that uses UNION ALL on two instances 
(and selecting all columns) of the accounts table. 
Then inspect the results and answer the subsequent 
quiz.
*/
SELECT * 
FROM accounts
UNION
SELECT * 
FROM accounts;

/*
Add a WHERE clause to each of the tables that you 
unioned in the query above, filtering the first table 
where name equals Walmart and filtering the second table 
where name equals Disney. Inspect the results then answer 
the subsequent quiz.
*/

SELECT *
    FROM accounts
    WHERE name = 'Walmart'

UNION ALL

SELECT *
  FROM accounts
  WHERE name = 'Disney'

/*
Perform the union in your first query (under the Appending 
Data via UNION header) in a common table expression and name 
it double_accounts. Then do a COUNT the number of times a name 
appears in the double_accounts table. If you do this correctly, 
your query results should have a count of 2 for each name.
*/

WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC