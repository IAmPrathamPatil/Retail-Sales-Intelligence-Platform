-- ==========================================================
-- Retail Sales Analytics Platform
-- File: 10_dashboard_queries.sql
-- Description: Dashboard Queries for Power BI
-- ==========================================================


-- ==========================================================
-- 1. Total Revenue
-- ==========================================================

SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments;


-- ==========================================================
-- 2. Total Orders
-- ==========================================================

SELECT
    COUNT(*) AS total_orders
FROM orders;


-- ==========================================================
-- 3. Total Customers
-- ==========================================================

SELECT
    COUNT(DISTINCT customer_id) AS total_customers
FROM customers;


-- ==========================================================
-- 4. Total Sellers
-- ==========================================================

SELECT
    COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers;


-- ==========================================================
-- 5. Average Order Value
-- ==========================================================

SELECT
    ROUND(AVG(payment_value), 2) AS average_order_value
FROM order_payments;


-- ==========================================================
-- 6. Monthly Revenue Trend
-- ==========================================================

SELECT

    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,

    ROUND(SUM(op.payment_value), 2) AS revenue

FROM orders o

JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY month

ORDER BY month;


-- ==========================================================
-- 7. Revenue by State
-- ==========================================================

SELECT

    c.customer_state,

    ROUND(SUM(op.payment_value),2) AS revenue

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY c.customer_state

ORDER BY revenue DESC;


-- ==========================================================
-- 8. Top 10 Product Categories
-- ==========================================================

SELECT

    pct.product_category_name_english,

    COUNT(*) AS total_sales,

    ROUND(SUM(op.payment_value),2) AS revenue

FROM order_items oi

JOIN products p
ON oi.product_id = p.product_id

JOIN product_category_translation pct
ON p.product_category_name = pct.product_category_name

JOIN order_payments op
ON oi.order_id = op.order_id

GROUP BY pct.product_category_name_english

ORDER BY revenue DESC

LIMIT 10;


-- ==========================================================
-- 9. Top 10 Sellers
-- ==========================================================

SELECT

    oi.seller_id,

    ROUND(SUM(op.payment_value),2) AS revenue,

    COUNT(*) AS total_orders

FROM order_items oi

JOIN order_payments op
ON oi.order_id = op.order_id

GROUP BY oi.seller_id

ORDER BY revenue DESC

LIMIT 10;


-- ==========================================================
-- 10. Payment Method Distribution
-- ==========================================================

SELECT

    payment_type,

    COUNT(*) AS total_transactions,

    ROUND(SUM(payment_value),2) AS revenue

FROM order_payments

GROUP BY payment_type

ORDER BY revenue DESC;


-- ==========================================================
-- 11. Average Review Score
-- ==========================================================

SELECT

    ROUND(AVG(review_score),2) AS average_review_score

FROM order_reviews;


-- ==========================================================
-- 12. Review Score Distribution
-- ==========================================================

SELECT

    review_score,

    COUNT(*) AS total_reviews

FROM order_reviews

GROUP BY review_score

ORDER BY review_score;


-- ==========================================================
-- 13. Average Delivery Time (Days)
-- ==========================================================

SELECT

    ROUND(

        AVG(

            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date -
                    order_purchase_timestamp
                )
            ) / 86400

        ),

        2

    ) AS average_delivery_days

FROM orders

WHERE order_delivered_customer_date IS NOT NULL;


-- ==========================================================
-- 14. Delayed Orders
-- ==========================================================

SELECT

    COUNT(*) AS delayed_orders

FROM orders

WHERE order_delivered_customer_date >
      order_estimated_delivery_date;


-- ==========================================================
-- 15. Monthly Orders
-- ==========================================================

SELECT

    DATE_TRUNC('month', order_purchase_timestamp) AS month,

    COUNT(*) AS total_orders

FROM orders

GROUP BY month

ORDER BY month;