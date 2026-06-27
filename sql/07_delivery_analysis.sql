-- ==========================================================
-- Retail Sales Analytics Platform
-- File: 07_advanced_sql.sql
-- Description: Advanced SQL Analysis using CTEs & Window Functions
-- ==========================================================


-- ==========================================================
-- 1. Monthly Revenue Trend
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
-- 2. Running Revenue (Window Function)
-- ==========================================================

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(op.payment_value), 2) AS revenue,

    ROUND(
        SUM(SUM(op.payment_value))
        OVER (
            ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
        ),
        2
    ) AS running_revenue

FROM orders o
JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY month
ORDER BY month;


-- ==========================================================
-- 3. Top 10 Customers by Total Spend
-- ==========================================================

SELECT

    o.customer_id,

    ROUND(
        SUM(op.payment_value),
        2
    ) AS total_spent

FROM orders o

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY o.customer_id

ORDER BY total_spent DESC

LIMIT 10;


-- ==========================================================
-- 4. Average Delivery Time (Days)
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
-- 5. Delayed Orders
-- ==========================================================

SELECT

    COUNT(*) AS delayed_orders

FROM orders

WHERE order_delivered_customer_date >
      order_estimated_delivery_date;


-- ==========================================================
-- 6. Revenue by State
-- ==========================================================

SELECT

    c.customer_state,

    ROUND(
        SUM(op.payment_value),
        2
    ) AS revenue

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY c.customer_state

ORDER BY revenue DESC;


-- ==========================================================
-- 7. Average Review Score by State
-- ==========================================================

SELECT

    c.customer_state,

    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_reviews r
    ON o.order_id = r.order_id

GROUP BY c.customer_state

ORDER BY average_review DESC;


-- ==========================================================
-- 8. Seller Revenue Ranking
-- ==========================================================

SELECT

    oi.seller_id,

    ROUND(
        SUM(op.payment_value),
        2
    ) AS revenue,

    DENSE_RANK() OVER (

        ORDER BY SUM(op.payment_value) DESC

    ) AS seller_rank

FROM order_items oi

JOIN order_payments op
    ON oi.order_id = op.order_id

GROUP BY oi.seller_id

ORDER BY seller_rank;


-- ==========================================================
-- 9. Top 5 Products per Category
-- ==========================================================

WITH ranked_products AS (

SELECT

    pct.product_category_name_english,

    oi.product_id,

    COUNT(*) AS total_sales,

    ROW_NUMBER() OVER (

        PARTITION BY pct.product_category_name_english

        ORDER BY COUNT(*) DESC

    ) AS rn

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

JOIN product_category_translation pct
    ON p.product_category_name = pct.product_category_name

GROUP BY

    pct.product_category_name_english,
    oi.product_id

)

SELECT *

FROM ranked_products

WHERE rn <= 5

ORDER BY
product_category_name_english,
total_sales DESC;


-- ==========================================================
-- 10. Month-over-Month Revenue Growth
-- ==========================================================

WITH monthly_sales AS (

SELECT

    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,

    SUM(op.payment_value) AS revenue

FROM orders o

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY month

)

SELECT

    month,

    ROUND(revenue,2) AS revenue,

    ROUND(
        LAG(revenue)
        OVER(ORDER BY month),
        2
    ) AS previous_month,

    ROUND(

        (
            revenue -
            LAG(revenue)
            OVER(ORDER BY month)
        )

        /

        LAG(revenue)
        OVER(ORDER BY month)

        * 100,

        2

    ) AS growth_percentage

FROM monthly_sales

ORDER BY month;