/*
Average number of events a day for each channel.
*/
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;

/*
Use DATE_TRUNC to pull month level information about 
the first order ever placed in the orders table.
*/

SELECT DATE_TRUNC('month',MIN(occurred_at)) 
FROM orders;

/*
Use the result of the previous query to find only the 
orders that took place in the same month and year as
the first order, and then pull the average for each
type of paper qty in this month.
*/

SELECT AVG(standard_qty) avg_standard,
	AVG(gloss_qty) avg_gloss,
	AVG(poster_qty) avg_poster,
	SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month',occurred_at) = 
 (SELECT DATE_TRUNC('month',MIN(occurred_at)) 
	FROM orders);
	
/*
1.Provide the name of the sales_rep in each region with the 
largest amount of total_amt_usd sales.

2.For the region with the largest (sum) of sales total_amt_usd, 
how many total (count) orders were placed?

3.How many accounts had more total purchases than the account 
name which has bought the most standard_qty paper throughout 
their lifetime as a customer?

4.For the customer that spent the most (in total over their 
lifetime as a customer) total_amt_usd, how many web_events 
did they have for each channel?

5.What is the lifetime average amount spent in terms of total_amt_usd 
for the top 10 total spending accounts?

6.What is the lifetime average amount spent in terms of total_amt_usd, 
including only the companies that spent more per order, on average, 
than the average of all orders.
*/

SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);
			  
SELECT COUNT(*) AS total
FROM (SELECT a.name
		FROM accounts a
		JOIN orders o 
		ON a.id = o.account_id
		GROUP BY a.name
		HAVING SUM(o.total) > (SELECT sum_total
				FROM (SELECT a.name company,SUM(o.standard_qty), SUM(o.total) sum_total
				FROM orders o
				JOIN accounts a 
				ON a.id = o.account_id
				GROUP BY 1
				ORDER BY 2 DESC
				LIMIT 1) AS sub_sum_total))sub_count;

SELECT a.name, wb.channel, COUNT(*) events
FROM web_events wb
JOIN accounts a
ON wb.account_id = a.id 
AND a.id = (SELECT spent_most.id FROM
			(SELECT a.id , SUM(o.total_amt_usd)
				FROM accounts a
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY 1 
				ORDER BY 2 DESC 
				LIMIT 1)AS spent_most) 
GROUP BY 1,2
ORDER BY 3 DESC;

SELECT AVG(top_ten.total)
FROM (SELECT a.name, SUM(o.total_amt_usd) AS total
		FROM accounts a
		JOIN orders o 
		ON a.id = o.account_id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10) AS top_ten;
		
SELECT AVG(avg_all)
FROM (SELECT a.name, AVG(o.total_amt_usd) avg_all
		FROM accounts a 
		JOIN orders o 
		ON a.id = o.account_id
		GROUP BY 1
		HAVING AVG(o.total_amt_usd) > 
	  	(SELECT AVG(total_amt_usd) FROM orders)) sub;