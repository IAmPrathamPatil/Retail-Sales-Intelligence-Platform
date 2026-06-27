-- =====================================
-- SELLER ANALYSIS
-- =====================================

-- Top Sellers

SELECT

seller_id,

COUNT(*) total_sales

FROM order_items

GROUP BY seller_id

ORDER BY total_sales DESC

LIMIT 20;

-- Seller Revenue

SELECT

seller_id,

ROUND(SUM(payment_value),2) revenue

FROM order_items oi

JOIN order_payments op

ON oi.order_id=op.order_id

GROUP BY seller_id

ORDER BY revenue DESC

LIMIT 20;