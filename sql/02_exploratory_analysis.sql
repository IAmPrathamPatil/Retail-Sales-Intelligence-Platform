SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_sellers
FROM sellers;

SELECT
MIN(order_purchase_timestamp) AS first_order,
MAX(order_purchase_timestamp) AS last_order
FROM orders;

SELECT
customer_state,
COUNT(*) AS customers
FROM customers
GROUP BY customer_state
ORDER BY customers DESC;

SELECT
payment_type,
COUNT(*) AS payments
FROM order_payments
GROUP BY payment_type
ORDER BY payments DESC;

SELECT
review_score,
COUNT(*) AS reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;