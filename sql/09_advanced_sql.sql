-- ==========================================
-- SALES SUMMARY VIEW
-- ==========================================

CREATE OR REPLACE VIEW vw_sales_summary AS

SELECT

o.order_id,

o.order_purchase_timestamp,

c.customer_city,

c.customer_state,

SUM(op.payment_value) total_payment

FROM orders o

JOIN customers c
ON o.customer_id=c.customer_id

JOIN order_payments op
ON o.order_id=op.order_id

GROUP BY

o.order_id,

o.order_purchase_timestamp,

c.customer_city,

c.customer_state;


CREATE OR REPLACE VIEW vw_product_sales AS

SELECT

oi.product_id,

COUNT(*) total_sales,

SUM(op.payment_value) revenue

FROM order_items oi

JOIN order_payments op

ON oi.order_id=op.order_id

GROUP BY

oi.product_id;


CREATE OR REPLACE VIEW vw_seller_revenue AS

SELECT

seller_id,

COUNT(*) total_orders,

ROUND(SUM(payment_value),2) revenue

FROM order_items oi

JOIN order_payments op

ON oi.order_id=op.order_id

GROUP BY seller_id;