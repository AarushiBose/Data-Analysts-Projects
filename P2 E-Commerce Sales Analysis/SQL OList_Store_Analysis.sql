USE olist_store_analysis;


#KPI 1:- Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
SELECT * FROM olist_orders_dataset;
SELECT * FROM olist_order_payments_dataset;

SELECT CASE
           WHEN DAYOFWEEK(order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
           ELSE 'Weekday'
       END AS Weekend_Weekday,
       CONCAT('$', FORMAT(SUM(payment_value) / 1000000, 2)) AS Total_Payment_Value_Millions
FROM olist_orders_dataset AS o
INNER JOIN olist_order_payments_dataset AS p
ON o.order_id = p.order_id
GROUP BY Weekend_Weekday
ORDER BY Total_Payment_Value_Millions DESC;


#KPI 2:- Number of Orders with review score 5 and payment type as credit card.
SELECT * FROM olist_order_payments_dataset;
SELECT * FROM olist_order_reviews_dataset;

SELECT 
       ors.review_score, 
       COUNT(opd.order_id) AS order_count
FROM olist_order_payments_dataset AS opd
INNER JOIN olist_order_reviews_dataset AS ors
ON opd.order_id = ors.order_id
WHERE opd.payment_type = 'credit_card' AND ors.review_score = 5
GROUP BY ors.review_score
ORDER BY ors.review_score;


#KPI 3:- Average number of days taken for order_delivered_customer_date for pet_shop
SELECT * FROM olist_orders_dataset;
SELECT * FROM olist_order_items_dataset;
SELECT * FROM olist_products_dataset;

SELECT
    opd.product_category_name,
    ROUND(AVG(DATEDIFF(odt.order_delivered_customer_date, odt.order_purchase_timestamp)), 0) AS Avg_Delivery_Days
FROM olist_orders_dataset AS odt
INNER JOIN olist_order_items_dataset AS oid ON odt.order_id = oid.order_id
INNER JOIN olist_products_dataset AS opd ON oid.product_id = opd.product_id
WHERE opd.product_category_name = 'Pet_Shop'
GROUP BY opd.product_category_name;


#KPI 4:- Average price and payment values from customers of sao paulo city
SELECT * FROM olist_sellers_dataset;
SELECT * FROM olist_order_payments_dataset;
SELECT * FROM olist_order_items_dataset;

SELECT osd.seller_city,
	CONCAT('$', ROUND(AVG(opd.payment_value),0)) AS Avg_Payment_Value,
    CONCAT('$', ROUND(AVG(oid.price),0)) AS Avg_Price
FROM olist_order_payments_dataset AS opd
INNER JOIN olist_order_items_dataset AS oid
ON opd.order_id = oid.order_id
INNER JOIN olist_sellers_dataset AS osd
ON oid.seller_id = osd.seller_id
WHERE osd.seller_city = 'sao paulo'
GROUP BY osd.seller_city;    


#KPI 5:- Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
SELECT * FROM olist_order_reviews_dataset;
SELECT * FROM olist_orders_dataset;

SELECT ors.review_score AS Review_Ratings,
       ROUND(AVG(DATEDIFF(od.order_delivered_customer_date, od.order_purchase_timestamp)), 0) AS Shipping_Days
FROM olist_order_reviews_dataset AS ors
INNER JOIN olist_orders_dataset AS od
ON ors.order_id = od.order_id
GROUP BY ors.review_score
ORDER BY ors.review_score; 


#KPI 6:- Customer Distribution Over States
SELECT * FROM olist_customers_dataset;       

SELECT customer_state,
       COUNT(customer_id) AS Total_Customers
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY Total_Customers DESC;       

#KPI 7:- Top 5 Products
SELECT * FROM olist_order_payments_dataset;
SELECT * FROM olist_products_dataset;
SELECT * FROM olist_order_items_dataset;

SELECT CONCAT('$', FORMAT(SUM(oid.price) / 1000000, 2), 'M') as total_price, opd.product_category_name AS products
FROM olist_order_items_dataset AS oid
INNER JOIN olist_products_dataset AS opd
ON oid.product_id = opd.product_id
GROUP BY products
ORDER BY total_price DESC LIMIT 5;





#----------------------------------------------------- Extra KPIs ------------------------------------------------------------------

#Total Customers
SELECT COUNT(customer_unique_id) FROM olist_customers_dataset;

#Total Orders
SELECT COUNT(order_id) FROM olist_orders_dataset;

#Total Sales
SELECT CONCAT('$', ROUND(SUM(payment_value)/1000000,2)) AS Total_Sales FROM olist_order_payments_dataset;







