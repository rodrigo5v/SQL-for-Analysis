/*
Aggregation Questions
Use the SQL environment below to find the solution for each 
of the following questions. If you get stuck or want to check 
your answers, you can find the answers at the top of the next 
concept.

1.Find the total amount of poster_qty paper ordered in the orders 
table.

2.Find the total amount of standard_qty paper ordered in the orders 
table.

3.Find the total dollar amount of sales using the total_amt_usd in 
the orders table.

4.Find the total amount spent on standard_amt_usd and gloss_amt_usd 
paper for each order in the orders table. This should give a dollar 
amount for each order in the table.

5.Find the standard_amt_usd per unit of standard_qty paper. Your solution 
should use both an aggregation and a mathematical operator.
*/

SELECT SUM(poster_qty) AS total_poster
FROM orders;

SELECT SUM(standard_qty) AS total_standard
FROM orders;

SELECT SUM(total_amt_usd) AS total_dollar
FROM orders;

SELECT standard_amt_usd + gloss_amt_usd AS total_standard_glosse
FROM orders;

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS unit_of_standard
FROM orders;

/*
Questions: MIN, MAX, & AVERAGE

1.When was the earliest order ever placed? 
You only need to return the date.

2.Try performing the same query as in question 1 without 
using an aggregation function.

3.When did the most recent (latest) web_event occur?

4.Try to perform the result of the previous query without 
using an aggregation function.

5.Find the mean (AVERAGE) amount spent per order on each 
paper type, as well as the mean amount of each paper type 
purchased per order. Your final answer should have 6 values
- one for each paper type for the average number of sales, 
as well as the average amount.

6.Via the video, you might be interested in how to calculate 
the MEDIAN. Though this is more advanced than what we have 
covered so far try finding - what is the MEDIAN total_usd 
spent on all orders?
*/

SELECT MIN(occurred_at) FROM orders; 

SELECT occurred_at 
FROM orders
ORDER BY occurred_at
LIMIT 1;

SELECT MAX(occurred_at) FROM web_events;

SELECT occurred_at 
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

SELECT AVG(standard_qty) standard_qty , AVG(standard_amt_usd) standard_usd,
	avg(gloss_qty) gloss_qty,AVG(gloss_amt_usd) gloss_usd, 
	AVG(poster_qty) poster_qty,AVG(poster_amt_usd) poster_usd
FROM orders;

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

/*
GROUP BY Note
Now that you have been introduced to JOINs, GROUP BY, and 
aggregate functions, the real power of SQL starts to come 
to life. Try some of the below to put your skills to the 
test!

Questions: GROUP BY

1.One part that can be difficult to recognize is when it might
be easiest to use an aggregate or one of the other SQL 
functionalities. Try some of the below to see if you can 
differentiate to find the easiest solution.

2.Which account (by name) placed the earliest order? Your 
solution should have the account name and the date of the order.

3.Find the total sales in usd for each account. You should include
two columns - the total sales for each company's orders in usd and 
the company name.

4.Via what channel did the most recent (latest) web_event occur, 
which account was associated with this web_event? Your query should 
return only three values - the date, channel, and account name.

5.Find the total number of times each type of channel from the web_events
was used. Your final table should have two columns - the channel and the 
number of times the channel was used.

6.Who was the primary contact associated with the earliest web_event?

7.What was the smallest order placed by each account in terms of total usd.
Provide only two columns - the account name and the total usd. Order from 
smallest dollar amounts to largest.

8.Find the number of sales reps in each region. Your final table should have 
two columns - the region and the number of sales_reps. Order from fewest reps 
to most reps.
*/

SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

SELECT a.name, SUM(o.total_amt_usd) AS total_per_company
FROM accounts a, orders o
WHERE a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

SELECT a.name, wb.occurred_at, wb.channel
FROM web_events wb
RIGHT JOIN accounts a
ON a.id =  wb.account_id
ORDER BY wb.occurred_at DESC
LIMIT 1;

SELECT channel, COUNT(channel)
FROM web_events
GROUP BY channel;

SELECT a.primary_poc, wb.occurred_at, wb.channel
FROM web_events wb
RIGHT JOIN accounts a
ON a.id =  wb.account_id
ORDER BY wb.occurred_at
LIMIT 1;

SELECT a.name, MIN(o.total_amt_usd) AS smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;/**/

SELECT r.name, COUNT(s.region_id) AS num_reps_region
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps_region;

/*
Questions: GROUP BY Part II

1.For each account, determine the average amount of each 
type of paper they purchased across their orders. Your 
result should have four columns - one for the account 
name and one for the average quantity purchased for 
each of the paper types for each account.


2.For each account, determine the average amount spent 
per order on each paper type. Your result should have 
four columns - one for the account name and one for 
the average amount spent on each paper type.


3.Determine the number of times a particular channel was 
used in the web_events table for each sales rep. Your 
final table should have three columns - the name of the 
sales rep, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences 
first.


4.Determine the number of times a particular channel was 
used in the web_events table for each region. Your final 
table should have three columns - the region name, the 
channel, and the number of occurrences. Order your table 
with the highest number of occurrences first.
*/

SELECT a.name, 
	AVG(o.standard_qty) avg_standard_qty, 
	AVG(o.gloss_qty) avg_gloss_qty, 
	AVG(o.poster_qty) avg_poster_qty
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

SELECT a.name, 
	AVG(o.standard_amt_usd) avg_standard_spent, 
	AVG(o.gloss_amt_usd) avg_gloss_spent, 
	AVG(o.poster_amt_usd) avg_poster_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

SELECT s.name, wb.channel, COUNT(wb.channel) AS occurrences
FROM web_events wb
JOIN accounts a 
ON wb.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name,wb.channel
ORDER BY occurrences DESC;

SELECT r.name, wb.channel, COUNT(wb.channel) AS occurrences
FROM web_events wb
JOIN accounts a 
ON wb.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name,wb.channel
ORDER BY occurrences DESC;

/*
Questions DISTINCT:
1.Use DISTINCT to test if there are any accounts 
associated with more than one region.


2.Have any sales reps worked on more than one account?
*/

SELECT DISTINCT id, name
FROM accounts;

SELECT DISTINCT id, name
FROM sales_reps;

/*
Questions HAVING:
1.How many of the sales reps have more than 5 accounts 
that they manage?

2.How many accounts have more than 20 orders?

3.Which account has the most orders?

4.Which accounts spent more than 30,000 usd total across 
all orders?

5.Which accounts spent less than 1,000 usd total across 
all orders?

6.Which account has spent the most with us?

7.Which account has spent the least with us?

8.Which accounts used facebook as a channel to contact 
customers more than 6 times?

9.Which account used facebook most as a channel?

10.Which channel was most frequently used by most accounts?
*/
SELECT s.name, COUNT(*) num_accounts
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(*)>5
ORDER BY num_accounts;

SELECT a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*)>20
ORDER BY num_orders;

SELECT a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC 
LIMIT 1;

SELECT a.name, SUM(o.total_amt_usd) spent_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY spent_orders;

SELECT a.name, SUM(o.total_amt_usd) spent_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY spent_orders;

SELECT a.name, SUM(o.total_amt_usd) spent_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY spent_orders DESC
LIMIT 1;

SELECT a.name, SUM(o.total_amt_usd) spent_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY spent_orders 
LIMIT 1;

SELECT a.name, wb.channel,COUNT(*) use_of_channel
FROM accounts a 
JOIN web_events wb
ON a.id = wb.account_id
GROUP BY a.name, wb.channel
HAVING COUNT(*) > 6 AND wb.channel = 'facebook';

SELECT a.name, wb.channel,COUNT(*) use_of_channel
FROM accounts a 
JOIN web_events wb
ON a.id = wb.account_id
WHERE wb.channel ='facebook'
GROUP BY a.name, wb.channel
ORDER BY use_of_channel DESC
LIMIT 1;

SELECT a.id, a.name, wb.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events wb
ON a.id = wB.account_id
GROUP BY a.id, a.name, wb.channel
ORDER BY use_of_channel DESC
LIMIT 10;

/*
Questions: Working wiht DATES:
1.Find the sales in terms of total dollars for all orders 
in each year, ordered from greatest to least. Do you 
notice any trends in the yearly sales totals?

2.Which month did Parch & Posey have the greatest sales in 
terms of total dollars? Are all months evenly represented 
by the dataset?

3.Which year did Parch & Posey have the greatest sales in 
terms of total number of orders? Are all years evenly 
represented by the dataset?

4.Which month did Parch & Posey have the greatest sales in 
terms of total number of orders? Are all months evenly 
represented by the dataset?

5.In which month of which year did Walmart spend the most on 
gloss paper in terms of dollars?
*/
SELECT SUM(total_amt_usd) AS total,DATE_PART('year',occurred_at) AS year
FROM orders
GROUP BY year
ORDER BY total DESC;

SELECT SUM(total_amt_usd) AS total,DATE_PART('month',occurred_at) AS mm
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY mm
ORDER BY total DESC;

SELECT COUNT(*) AS total_orders,DATE_PART('year',occurred_at) AS year
FROM orders
GROUP BY year
ORDER BY total_orders DESC;

SELECT COUNT(*) AS total_sales,DATE_PART('month',occurred_at) AS month
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY month
ORDER BY total_sales DESC;

SELECT SUM(o.gloss_amt_usd) AS total_spent_gloss, 
	DATE_TRUNC('month',o.occurred_at) AS month
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY month
ORDER BY total_spent_gloss DESC
LIMIT 1;

/*
Questions: CASE

1.Write a query to display for each order, the account ID, 
total amount of the order, and the level of the order - 
‘Large’ or ’Small’ - depending on if the order is $3000 or 
more, or smaller than $3000.

2.Write a query to display the number of orders in each 
of three categories, based on the total number of items 
in each order. The three categories are: 'At Least 2000', 
'Between 1000 and 2000' and 'Less than 1000'.

3.We would like to understand 3 different levels of customers 
based on the amount associated with their purchases. The top 
level includes anyone with a Lifetime Value (total sales of all 
orders) greater than 200,000 usd. The second level is between 
200,000 and 100,000 usd. The lowest level is anyone under 100,000 
usd. Provide a table that includes the level associated with each 
account. You should provide the account name, the total sales of 
all orders for the customer, and the level. Order with the top 
spending customers listed first.

4.We would now like to perform a similar calculation to the first, 
but we want to obtain the total amount spent by customers only 
in 2016 and 2017. Keep the same levels as in the previous question. 
Order with the top spending customers listed first.

5.We would like to identify top performing sales reps, which are sales 
reps associated with more than 200 orders. Create a table with the 
sales rep name, the total number of orders, and a column with top or 
not depending on if they have more than 200 orders. Place the top sales 
people first in your final table.

6.The previous didn't account for the middle, nor the dollar amount 
associated with the sales. Management decides they want to see these 
characteristics represented as well. We would like to identify top 
performing sales reps, which are sales reps associated with more than 
200 orders or more than 750000 in total sales. The middle group has any 
rep with more than 150 orders or 500000 in sales. Create a table with the 
sales rep name, the total number of orders, total sales across all orders, 
and a column with top, middle, or low depending on this criteria. Place the 
top sales people based on dollar amount of sales first in your final table. 
You might see a few upset sales people by this criteria!
*/

SELECT account_id, total_amt_usd, 
	CASE WHEN total_amt_usd >= 3000 THEN 'Large'
		ELSE 'Small' END AS level_order
FROM orders;

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
   WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
   ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

SELECT a.name,SUM(o.total_amt_usd),
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'TOP'
	WHEN SUM(o.total_amt_usd) <= 200000 AND SUM(o.total_amt_usd) > 100000 THEN 'MIDDLE'
	ELSE 'LOW' END AS level_of_costumer
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

SELECT a.name,SUM(o.total_amt_usd),
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'TOP'
	WHEN SUM(o.total_amt_usd) <= 200000 AND SUM(o.total_amt_usd) > 100000 THEN 'MIDDLE'
	ELSE 'LOW' END AS level_of_costumer
FROM accounts a
JOIN orders o 
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

SELECT s.name, COUNT(*) num_orders,
	CASE WHEN COUNT(*)>200 THEN 'TOP'
	ELSE 'NOT' END AS level_rep
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;

SELECT s.name, COUNT(*) num_orders, SUM(o.total_amt_usd) total_spent, 
	CASE WHEN COUNT(*)>200 OR SUM(o.total_amt_usd)>750000 THEN 'TOP'
	WHEN COUNT(*)>150 OR SUM(o.total_amt_usd)>500000 THEN 'MIDDLE'
	ELSE 'LOW' END AS level
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 3 DESC;