CREATE TABLE olist_customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32) NOT NULL,
    customer_zip_code_prefix VARCHAR(5),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

CREATE TABLE olist_orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32) NOT NULL REFERENCES olist_customers(customer_id),
    order_status VARCHAR(20) NOT NULL,
    order_purchase_timestamp TIMESTAMP NOT NULL,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE olist_products (
    product_id VARCHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

CREATE TABLE olist_sellers (
    seller_id VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

CREATE TABLE olist_order_items (
    order_id VARCHAR(32) NOT NULL REFERENCES olist_orders(order_id),
    order_item_id INTEGER NOT NULL,
    product_id VARCHAR(32) NOT NULL REFERENCES olist_products(product_id),
    seller_id VARCHAR(32) NOT NULL REFERENCES olist_sellers(seller_id),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2) NOT NULL,
    freight_value NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE olist_order_payments (
    order_id VARCHAR(32) NOT NULL REFERENCES olist_orders(order_id),
    payment_sequential INTEGER NOT NULL,
    payment_type VARCHAR(20) NOT NULL,
    payment_installments INTEGER NOT NULL,
    payment_value NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE olist_order_reviews (
    review_id VARCHAR(32) PRIMARY KEY,
    order_id VARCHAR(32) NOT NULL REFERENCES olist_orders(order_id),
    review_score SMALLINT NOT NULL,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100) NOT NULL
);