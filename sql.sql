use walmartdb;
select * from walmart limit 10;

--  q1   1. Analyze Payment Methods and Sales
-- ● Question 1: What are the different payment methods, and how many transactions and
-- items were sold with each method?

SELECT payment_method,  
       COUNT(*) AS total_transactions,  
       SUM(quantity) AS total_items_sold  
FROM walmart  
GROUP BY payment_method order by total_transactions  desc;




-- . Identify the Highest-Rated Category in Each Branch
-- ● Question 2: Which category received the highest average rating in each branch?

SELECT
  branch,
  category,
  AVG(rating) AS avg_rating
FROM walmart 
GROUP BY branch, category;    # it will give per category per branch;


WITH avg_ratings AS (
  SELECT
    branch,
    category,
    AVG(rating) AS avg_rating,
    RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
  FROM walmart
  GROUP BY branch, category
)

SELECT branch, category, avg_rating
FROM avg_ratings
WHERE rnk = 1;


-- ● Question3: What is the busiest day of the week for each branch based on transaction
-- volume?
WITH daily_counts AS (
  SELECT 
    branch,
    DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS weekday,
    COUNT(*) AS total_transactions,
    RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
  FROM walmart
  GROUP BY branch, weekday
)

SELECT branch, weekday, total_transactions
FROM daily_counts
WHERE rnk = 1;


-- ● Question 4: How many items were sold through each payment method? 
SELECT
  payment_method,
  SUM(quantity) AS total_items_sold
FROM walmart
GROUP BY payment_method
ORDER BY total_items_sold DESC;


-- ● Question 5: What are the average, minimum, and maximum ratings for each category in
-- each city?
SELECT
  city,
  category,
  AVG(rating) AS avg_rating,
  MIN(rating) AS min_rating,
  MAX(rating) AS max_rating
FROM walmart
GROUP BY city, category
ORDER BY city, category;



-- Question 6: What is the total profit for each category, ranked from highest to lowest?
SELECT
  category,
  SUM(total * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;


-- ● Question: What is the most frequently used payment method in each branch?
WITH method_counts AS (
  SELECT
    branch,
    payment_method,
    COUNT(*) AS total_transactions,
    RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
  FROM walmart
  GROUP BY branch, payment_method
)

SELECT branch, payment_method, total_transactions
FROM method_counts
WHERE rnk = 1;

-- Question 8: How many transactions occur in each shift (Morning, Afternoon, Evening)
-- across branches?
SELECT
  branch,
  CASE
    WHEN TIME(time) BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
    WHEN TIME(time) BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
    WHEN TIME(time) BETWEEN '17:00:00' AND '22:00:00' THEN 'Evening'
    ELSE 'Other'
  END AS shift,
  COUNT(*) AS total_transactions
FROM walmart
GROUP BY branch, shift
ORDER BY branch, shift;






	