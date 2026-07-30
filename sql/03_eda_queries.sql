-- ============================================
-- Q1: Monthly revenue and order volume trend
-- ============================================
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY order_month
ORDER BY order_month;


-- ============================================
-- Q2: Top 10 product categories by revenue
-- ============================================
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    SUM(oi.price) AS total_revenue,
    COUNT(oi.order_item_id) AS items_sold
FROM olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

-- ============================================
-- Q3: Delivery performance (actual vs estimated delivery date)
-- ============================================
SELECT
    CASE
        WHEN order_delivered_customer_date IS NULL THEN 'not yet delivered'
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'on time or early'
        ELSE 'late'
    END AS delivery_status,
    COUNT(*) AS order_count,
    ROUND(AVG(EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))), 1) AS avg_days_to_deliver
FROM olist_orders
WHERE order_status = 'delivered'
GROUP BY delivery_status
ORDER BY order_count DESC;