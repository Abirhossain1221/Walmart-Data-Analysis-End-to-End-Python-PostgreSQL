select * from walmart
limit 5;

---
select count(*) from walmart;

-- 

select distinct payment_method,
		count(*) as total 
from walmart
group by 1
order by total desc ;
----------
select distinct category,
		ROUND(sum(total)) as total_sales

from walmart 
group by category
order by total_sales desc ;

---
SELECT COUNT(DISTINCT branch)
FROM walmart;
---
select max(quantity) as max_qunatity
, min(quantity) as min_quantity
from walmart;

--- Business Problems--

-- Q1 Find different panyment method and number of transactions, number of quanty sold .

select 
	payment_method,
	count(*) as no_transactions,
	sum(quantity) as no_quantity
from walmart
group by 1
	
--Q2  Identify the highest-rated category in each branch, display the branch , category 
-- and avg ratig .


SELECT *
		
FROM 
	( SELECT
		branch,
		category,
		avg(rating) AS rating,
		RANK() OVER(PARTITION BY branch ORDER BY avg(rating) DESC) as rank 
	FROM walmart
	GROUP BY 1,2 
)
WHERE rank = 1 ;

--Q3 Identify the busiest day of each branch based on the nunber of transactions. 


WITH cte AS
(
SELECT 
	branch,
	TO_CHAR(TO_DATE(date, 'DD-MM-YY'), 'DAY') AS day_name,
	COUNT(*) AS no_transaction,
	RANK() OVER (PARTITION BY branch ORDER BY COUNT(*)) AS rank

FROM walmart
GROUP BY 1, 2
)
select *
from cte 
WHERE rank = 1

--Q4 Calculate the total quantity of item sold per payment methon. List payment method and total quantity.

SELECT 
	payment_method,
	SUM(quantity) AS total_quantity
FROM walmart
GROUP BY payment_method;

--Q5 Determine the average , minimum and maximum rating  of category for each city. 
-- List the city, avg_rating, min_rating, max_rating .

SELECT 
	city,
	category,
	ROUND(AVG(rating:: NUMERIC), 2) AS avg_rating,
	MIN(rating) AS min_rating,
	MAX(rating) AS max_rating 
	
FROM walmart
GROUP BY 1, 2;
	
-- Catagory by city

select city ,  count (category)
from walmart
group by city

-- Q6 calculate the total profit for each category by considering
-- total profit as (unit_price * quantity * profit_margin)

SELECT 
	category,
	SUM(unit_price*quantity) as revenue,
	SUM(unit_price*quantity*profit_margin) as total_profit

FROM walmart
GROUP BY 1

--Q7 Determine the most common payment method for each branch.
--(display branch and the prefered payment method)

SELECT * FROM
(
SELECT 
	branch,
	payment_method,
	count(*) as total_payment,
	RANK() OVER (PARTITION BY branch ORDER BY count(*) DESC) AS rank
FROM walmart
GROUP BY 1,2
)
WHERE rank = 1 

-- Q8 Categorize sales into 3 groups morning ,afternoon,evening
-- find  out each shift and number of invoices .


 SELECT 
	branch,
 		CASE 
		 WHEN EXTRACT(HOUR FROM time :: TIME ) < 12 THEN 'Morning'
		 WHEN EXTRACT(HOUR FROM time :: TIME ) BETWEEN 12 AND 17 THEN 'Afternoon'
		 ELSE 'Evening'
		END AS day_time,
		COUNT(*) AS no_invoice	
FROM walmart
GROUP BY 1,2
ORDER BY 1,3 DESC;


--Q9 Identify 5 branch with highest desrease ratio in 
-- revenue compare to the last year (current year 2022 and last year 2023)

with ls AS
(SELECT
	branch,
	SUM(total) AS ls_rev
FROM walmart  
WHERE EXTRACT (YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
GROUP BY 1
),

cs AS
(
SELECT
	branch,
	SUM(total) cs_rev
FROM walmart  
WHERE EXTRACT (YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
GROUP BY 1
)

SELECT
	ls.branch,
	ls.ls_rev,
	cs.cs_rev,
	ROUND((cs.cs_rev-ls.ls_rev):: NUMERIC /ls.ls_rev :: NUMERIC * 100,2) as rev_dec_ratio
FROM ls
JOIN cs
ON ls.branch =cs.branch 
ORDER BY 4 
LIMIT 5; 


--Q10 cashless branches

SELECT branch, city
FROM walmart
GROUP BY branch, city
HAVING SUM(CASE WHEN payment_method = 'Cash' THEN 1 ELSE 0 END) = 0;




	   




