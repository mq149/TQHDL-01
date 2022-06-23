-- DT03 ------------------------------------------------------------
-- Sales amount by year
SELECT SUM(o.total_price) as revenue, YEAR(o.created_at) as y
FROM orders as o 
    JOIN order_details as od ON o.id = od.order_id
-- WHERE o.store_id = 2
GROUP BY y
ORDER BY y

-- Sales amount by quarter
SELECT SUM(o.total_price) as revenue,
    CASE
        WHEN MONTH(o.created_at) >= 10 THEN 4
        WHEN MONTH(o.created_at) >= 7 THEN 3
        WHEN MONTH(o.created_at) >= 4 THEN 2
        ELSE 1
    END AS quarter,
    MONTH(o.created_at) as month,
    YEAR(o.created_at) as year
FROM orders as o 
    JOIN order_details as od ON o.id = od.order_id
-- WHERE o.store_id = 2
GROUP BY month, quarter, year
ORDER BY year, quarter, month

-- Sales amount by month
SELECT SUM(o.total_price) as revenue, MONTH(o.created_at) as m, YEAR(o.created_at) as y
FROM orders as o 
    JOIN order_details as od ON o.id = od.order_id
-- WHERE o.store_id = 2
GROUP BY m, y
ORDER BY y, m

-- DT04 ------------------------------------------------------------
SELECT COUNT(sub.customer_id) as customers, sub.district, sub.province
FROM (
    SELECT u.id as customer_id, a.district as district, a.province as province
    FROM orders o
        JOIN users u ON o.customer_id = u.id
        JOIN addresses a ON a.user_id = u.id
--     WHERE o.store_id = 2
    GROUP BY customer_id
) as sub
GROUP BY sub.district, sub.province
ORDER BY customers DESC

-- DT06 ------------------------------------------------------------
SELECT r.revenue as revenue,
	LEFT(r.d, 7) as month,
	r_prev.revenue as previous_revenue,
	LEFT(r_prev.d, 7) as previous_month,
	100 * (r.revenue - r_prev.revenue) / r_prev.revenue as percentage
FROM
    (
        SELECT SUM(o.total_price) as revenue, CONCAT(LEFT(o.created_at, 7), "-01") as d
        FROM orders as o 
            JOIN order_details as od ON o.id = od.order_id
        WHERE o.store_id = 2
        GROUP BY d
    ) as r
    LEFT JOIN 
    (
        SELECT SUM(o.total_price) as revenue, CONCAT(LEFT(o.created_at, 7), "-01") as d
        FROM orders as o 
            JOIN order_details as od ON o.id = od.order_id
        WHERE o.store_id = 2
        GROUP BY d
    ) as r_prev
    ON DATE(r.d) = DATE(r_prev.d) + INTERVAL 1 MONTH
ORDER BY month


-- DT09 ------------------------------------------------------------
-- Top 10 MOST sold product by unit
SELECT p.id as product_id, p.name as product_name, SUM(od.unit) as unit
FROM orders as o 
    JOIN order_details as od ON o.id = od.order_id
	JOIN products as p ON od.product_id = p.id
-- WHERE o.store_id = 2
GROUP BY product_id, product_name
ORDER BY unit DESC
LIMIT 10

-- Top 10 LEAST sold product by unit
SELECT p.id as product_id, p.name as product_name, SUM(od.unit) as unit
FROM orders as o 
    JOIN order_details as od ON o.id = od.order_id
	JOIN products as p ON od.product_id = p.id
-- WHERE o.store_id = 2
GROUP BY product_id, product_name
ORDER BY unit
LIMIT 10

-- DT14 ------------------------------------------------------------
SELECT id, name, in_stock
FROM products
WHERE in_stock <= 200 AND store_id = 4
ORDER BY in_stock


-- DT16 ------------------------------------------------------------
-- By product
SELECT p.id as product_id, p.name as product_name, SUM(od.subtotal_price) as sales_amount
FROM orders as o 
    JOIN order_details as od ON o.id = od.order_id
	JOIN products as p ON od.product_id = p.id
WHERE o.store_id = 2
GROUP BY product_id, product_name
ORDER BY sales_amount DESC
-- LIMIT 10

-- By product category
SELECT pc.name as product_category, SUM(od.subtotal_price) as sales_amount
FROM orders as o 
    JOIN order_details as od ON o.id = od.order_id
	JOIN products as p ON od.product_id = p.id
	JOIN product_categories as pc ON p.product_category_id = pc.id
WHERE o.store_id = 2
GROUP BY product_category
ORDER BY sales_amount DESC
-- LIMIT 10

-- DT18 ------------------------------------------------------------
-- Rating by product
SELECT p.id as product_id, p.name as product_name, AVG(pr.rating) as average_rating
FROM product_reviews pr
	JOIN products p ON p.id = pr.product_id
WHERE p.store_id = 2
GROUP BY product_id, product_name

-- Rating by product category
SELECT pc.id as product_category_id, pc.name as product_category_name, AVG(pr.rating) as average_rating
FROM product_reviews pr
	JOIN products p ON p.id = pr.product_id
	JOIN product_categories pc ON pc.id = p.product_category_id
WHERE p.store_id = 2
GROUP BY product_category_id, product_category_name

-- Most 1 point rating:
-- Product
SELECT p.id as product_id, p.name as product_name, pr.rating as rating, COUNT(*) as count
FROM product_reviews pr
	JOIN products p ON p.id = pr.product_id
WHERE pr.rating = 1 AND p.store_id = 2
GROUP BY product_id, product_name, rating
ORDER BY count DESC
-- Product category
SELECT pc.id as product_category_id, pc.name as product_category_name, pr.rating as rating, COUNT(*) as count
FROM product_reviews pr
	JOIN products p ON p.id = pr.product_id
	JOIN product_categories pc ON pc.id = p.product_category_id
WHERE pr.rating = 1 AND p.store_id = 2
GROUP BY product_category_id, product_category_name, rating
ORDER BY count DESC