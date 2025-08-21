/* Exploring the Magist Database - - Big Picture Questions */

USE magist123;

/* 1. How many orders are there in the dataset? The orders table contains a row for each order, so this should be easy to find out!*/
-- 99441 orders

SELECT *
FROM orders;


/* 2. Are orders actually delivered? Look at the columns in the orders table: one of them is called order_status.
 Most orders seem to be delivered, but some aren’t. Find out how many orders are delivered and how many are cancelled, 
unavailable, or in any other status by grouping and aggregating this column. */

-- delivered - 96478


SELECT 
    order_status, 
    COUNT(*) AS orders
FROM
    orders
GROUP BY order_status;


/* 3. Is Magist having user growth? A platform losing users left and right isn’t going to be very useful to us. 
It would be a good idea to check for the number of orders grouped by year and month. Tip: you can use the functions YEAR() 
and MONTH() to separate the year and the month of the order_purchase_timestamp.*/

SELECT YEAR(order_purchase_timestamp) AS `year` , MONTHNAME(order_purchase_timestamp) AS `month`, COUNT(customer_id)
FROM orders
GROUP by `year`, `month`
ORDER by `year` ASC, `month` DESC;


/* 4. How many products are there on the products table? (Make sure that there are no duplicate products.) */
-- 32951


SELECT DISTINCT COUNT(*) AS total_product_count
FROM products;

SELECT 
    COUNT(DISTINCT product_id) AS products_count
FROM
    products;


/* 5. Which are the categories with the most products? Since this is an external database and has been partially anonymized, 
we do not have the names of the products. But we do know which categories products belong to. This is the closest we can get to 
knowing what sellers are offering in the Magist marketplace. By counting the rows in the products table and grouping them by categories, 
we will know how many products are offered in each category. This is not the same as how many products are actually sold by category*/

SELECT pt.product_category_name_english AS category_name_english, COUNT(DISTINCT p.product_id) AS number_of_products
FROM products p
JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
GROUP BY pt.product_category_name_english
ORDER BY number_of_products DESC;


/* 6. How many of those products were present in actual transactions? The products table is a “reference” of all the available products. 
Have all these products been involved in orders? Check out the order_items table to find out! */

SELECT COUNT(DISTINCT oi.product_id)
FROM order_items oi;


/* 7. What’s the price for the most expensive and cheapest products? Sometimes, having a broad range of prices is informative. 
Looking for the maximum and minimum values is also a good way to detect extreme outliers.*/

-- most expensive price 6735
-- cheapest 0.85
-- average price 120.65

SELECT MAX(price) AS most_expensive, MIN(price) AS cheapest, ROUND(AVG(price), 2) as average_price
FROM order_items;

/* 8. What are the highest and lowest payment values? Some orders contain multiple products. 
What’s the highest someone has paid for an order? Look at the order_payments table and try to find it out.*/

SELECT *
FROM order_payments;

-- highest payment value 13664.1
-- lowest payment value 0
-- average payment value 154.1

SELECT MAX(payment_value) AS highest_payment, MIN(payment_value) AS lowest_payment, ROUND(AVG(payment_value), 2) AS average_payment
FROM order_payments;

SELECT SUM(payment_value) AS maximum_payment
FROM order_payments
GROUP BY order_id
ORDER BY maximum_payment DESC
LIMIT 1;


/* */


