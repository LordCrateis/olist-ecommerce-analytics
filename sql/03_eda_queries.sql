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

-- ============================================
-- Q4: Payment method usage and installment behavior
-- ============================================
SELECT
    payment_type,
    COUNT(*) AS transaction_count,
    ROUND(AVG(payment_installments), 1) AS avg_installments,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM olist_order_payments
GROUP BY payment_type
ORDER BY transaction_count DESC;

-- ============================================
-- Q5: Repeat customer rate
-- ============================================
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS num_orders
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    CASE WHEN num_orders = 1 THEN 'one-time customer' ELSE 'repeat customer' END AS customer_type,
    COUNT(*) AS num_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM customer_order_counts
GROUP BY customer_type;

-- ============================================
-- Q6: Top 10 sellers by revenue
-- ============================================
SELECT
    oi.seller_id,
    s.seller_state,
    SUM(oi.price) AS total_revenue,
    COUNT(oi.order_item_id) AS items_sold
FROM olist_order_items oi
JOIN olist_sellers s ON oi.seller_id = s.seller_id
GROUP BY oi.seller_id, s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;

-- ============================================
-- Q7: Review score by delivery status (on-time vs late)
-- ============================================
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'on time or early'
        ELSE 'late'
    END AS delivery_status,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(*) AS num_reviews
FROM olist_orders o
JOIN olist_order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status
ORDER BY avg_review_score DESC;