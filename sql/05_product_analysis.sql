-- =====================================
-- PRODUCT ANALYSIS
-- =====================================

-- Top Selling Products

SELECT
oi.product_id,
COUNT(*) AS total_sales
FROM order_items oi
GROUP BY oi.product_id
ORDER BY total_sales DESC
LIMIT 20;

-- Top Categories

SELECT
pct.product_category_name_english,
COUNT(*) AS total_sales
FROM products p

JOIN product_category_translation pct
ON p.product_category_name=pct.product_category_name

JOIN order_items oi
ON p.product_id=oi.product_id

GROUP BY pct.product_category_name_english
ORDER BY total_sales DESC;

-- Highest Revenue Categories

SELECT

pct.product_category_name_english,

ROUND(SUM(op.payment_value),2) revenue

FROM order_items oi

JOIN products p
ON oi.product_id=p.product_id

JOIN product_category_translation pct
ON p.product_category_name=pct.product_category_name

JOIN order_payments op
ON oi.order_id=op.order_id

GROUP BY pct.product_category_name_english

ORDER BY revenue DESC;