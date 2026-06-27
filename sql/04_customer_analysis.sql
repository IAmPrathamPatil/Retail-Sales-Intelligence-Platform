-- =====================================
-- CUSTOMER ANALYSIS
-- =====================================

-- 1. Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 2. Customers by State
SELECT
customer_state,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- 3. Top 10 Cities
SELECT
customer_city,
COUNT(*) AS customers
FROM customers
GROUP BY customer_city
ORDER BY customers DESC
LIMIT 10;

-- 4. Orders per Customer
SELECT
customer_id,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 20;

-- 5. Average Orders per Customer
SELECT
ROUND(
COUNT(order_id)::numeric /
COUNT(DISTINCT customer_id),2
) AS avg_orders_per_customer
FROM orders;

-- 6. Monthly New Customers
SELECT
DATE_TRUNC('month',order_purchase_timestamp) AS month,
COUNT(DISTINCT customer_id)
FROM orders
GROUP BY month
ORDER BY month;