SELECT
ROUND(SUM(payment_value),2) AS total_revenue
FROM order_payments;

SELECT
ROUND(AVG(payment_value),2) AS average_order_value
FROM order_payments;

SELECT
MAX(payment_value)
FROM order_payments;

SELECT
MIN(payment_value)
FROM order_payments;

SELECT

DATE_TRUNC('month',o.order_purchase_timestamp) AS month,

ROUND(SUM(op.payment_value),2) AS revenue

FROM orders o

JOIN order_payments op

ON o.order_id=op.order_id

GROUP BY month

ORDER BY month;