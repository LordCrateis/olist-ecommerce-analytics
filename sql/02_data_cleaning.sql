-- Fix: olist_order_reviews_dataset.csv contains 814 duplicate review_id values.
-- Strategy: load into a staging table (no PK constraint), then keep only the
-- most recently answered version of each duplicated review.

CREATE TABLE staging_order_reviews (
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score SMALLINT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- Note: run via psql with \copy, or adapt to COPY if run server-side.
-- ENCODING 'LATIN1' is required — this file is not valid UTF-8.
\copy staging_order_reviews FROM 'data/raw/olist_order_reviews_dataset.csv' DELIMITER ',' CSV HEADER ENCODING 'LATIN1';

INSERT INTO olist_order_reviews
SELECT DISTINCT ON (review_id) *
FROM staging_order_reviews
ORDER BY review_id, review_answer_timestamp DESC;

DROP TABLE staging_order_reviews;