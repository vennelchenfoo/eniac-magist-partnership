-- CODE SLICERS answer to Business Questions

USE magist123;

-- Kehinde's solutions to product related questions

/* What categories of tech products does Magist have? */
        SELECT
        pct.product_category_name_english
        AS tech_category
        From products p
        JOIN  product_category_name_translation pct
        ON p.product_category_name =   pct.product_category_name
        WHERE pct.product_category_name_english  REGEXP 'compu|elect|tablet|phon|watches|audio'
        group by pct.product_category_name_english ;
    -- Alternative
   SELECT
        pct.product_category_name_english
        AS tech_category
        From products p
        JOIN  product_category_name_translation pct
        ON p.product_category_name =   pct.product_category_name
  WHERE product_category_name_english  IN ('audio', 'electronics', 'computers_accessories', 'watches_gifts',
										 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony')
group by pct.product_category_name_english ;

/* How many products of these tech categories have been sold (within the time window of the database snapshot)?
        What percentage does that represent from the overall number of products sold?*/
		
SELECT
    COUNT(DISTINCT oi.product_id) AS tech_products_sold
FROM
    order_items oi
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name)
WHERE
    product_category_name_english IN ('audio' , 'electronics',
        'computers_accessories',
        'watches_gifts',
        'computers',
        'tablets_printing_image',
        'telephony',
        'fixed_telephony');
	-- 4832 tech_products_sold
 SELECT COUNT(DISTINCT product_id) AS products_sold
FROM order_items;
-- 32951    Total_products_sold               1
SELECT
    4832 AS tech_products_sold,
    (SELECT
            COUNT(DISTINCT product_id)
        FROM
            order_items) AS total_products_sold,
    ROUND((4832 / (SELECT
                    COUNT(DISTINCT product_id)
                FROM
                    order_items)) * 100,
            2) AS percentage_tech_products;
 -- 14.66.    percentage_tech_products         2
  -- Alternative
 SELECT
    4832 AS tech_products_sold,
    (SELECT
            COUNT(DISTINCT product_id)
        FROM
            order_items) AS total_products_sold,
             -- Alternative
    ROUND((4832 / 32951) * 100, 2) AS percentage_tech_products;
-- 14.66.    percentage_tech_products             2
 -- Alternative
 SELECT ROUND((4832/ 32951) * 100, 2) percentage_tech_products;
 -- 14.66.    percentage_tech_products         2
  -- Alternative
SELECT
    COUNT(DISTINCT CASE
            WHEN
                product_category_name_english IN ('audio' , 'electronics',
                    'computers_accessories',
                    'watches_gifts',
                    'computers',
                    'tablets_printing_image',
                    'telephony',
                    'fixed_telephony')
            THEN
                oi.product_id
        END) / COUNT(DISTINCT oi.product_id) * 100.0 AS percentage
FROM
    order_items oi
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pt USING (product_category_name);
-- 14.66.    percentage_tech_products

/* What’s the average price of the products being sold? */
  SELECT ROUND(AVG(price), 2) AS avg_product_price
FROM (SELECT DISTINCT product_id,
                      price
	  FROM order_items) AVG_UNique_Price;
-- 145.93      AVG_UNique_Price

SELECT ROUND(AVG(price), 2)
FROM order_items;
-- 120.65  AVG_Price_customers_pay

/* Are expensive tech products popular? * TIP: Look at the function CASE WHEN to accomplish this task. */
SELECT COUNT(oi.product_id),
	CASE
		WHEN price > 850 THEN "Expensive"
		WHEN price > 350 THEN "Mid-range"
		ELSE "Cheap"
	END AS "price_range"
FROM order_items oi
LEFT JOIN products p
	ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation pt
	USING (product_category_name)
WHERE pt.product_category_name_english IN ('audio' , 'electronics',
                    'computers_accessories',
                    'watches_gifts',
                    'computers',
                    'tablets_printing_image',
                    'telephony',
                    'fixed_telephony')
GROUP BY price_range
ORDER BY 1 DESC;
-- 20627 CAT As Cheap Tech
-- 1009  CAT AS Mid-Range Tech
-- 408.  CAT AS Expensive

-- Kübra's solution to sellers related questions

/* Magist Business Questions – Seller Analysis
-- 5. How many months of data are included in the Magist database?*/

SELECT TIMESTAMPDIFF(MONTH, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) + 1 AS total_months
FROM orders;

-- Answer: Tecnically 26 months, but only 25 moths with active orders.

-- 6. How many sellers are there in total?
SELECT COUNT(DISTINCT seller_id) AS count_seller
FROM sellers;
-- total sellers: 3095

--    How many Tech sellers are there?

SELECT COUNT(DISTINCT s.seller_id) AS tech_sellers
FROM sellers s
JOIN order_items oi USING (seller_id)
JOIN products p USING (product_id)
JOIN product_category_name_translation pcnt USING (product_category_name)
WHERE pcnt.product_category_name_english IN (
	  'audio',
      'computers',
      'computers_accessories',
      'electronics',
      'fixed_telephony',
      'tablets_printing_image',
      'telephony',
      'watches_gifts');
-- total tech sellers: 525

--    What percentage of overall sellers are Tech sellers?

-- 1. -> counting all sellers:
SELECT COUNT(DISTINCT seller_id) AS total_seller
FROM sellers;
-- 2. -> seller who sold min. 1 tech product
SELECT COUNT(DISTINCT s.seller_id) AS tech_sellers
FROM sellers s
JOIN order_items oi USING (seller_id)
JOIN products p USING (product_id)
JOIN product_category_name_translation pcnt USING (product_category_name)
WHERE pcnt.product_category_name_english IN (
	  'audio',
      'computers',
      'computer_accessories',
      'electronics',
      'fixed_telephony',
      'tablets_printing_image',
      'telephony',
      'watches_gifts');
-- 3. -> calculate result:

SELECT ROUND((356 / 3095) * 100, 2) AS percentage_tech_sellers;

-- -> result: 11,50% of sellers are Tech Sellers.

-- 7. What is the total amount earned by all sellers?
SELECT ROUND(SUM(oi.price), 2) AS total_earnd
FROM sellers s
JOIN order_items oi USING (seller_id);

--    What is the total amount earned by all Tech sellers?
SELECT ROUND(SUM(oi.price), 2) AS total_amount_earnd_by_tech_sellers
FROM sellers s
JOIN order_items oi USING (seller_id)
JOIN products p USING (product_id)
JOIN product_category_name_translation pcnt USING (product_category_name)
WHERE product_category_name_english IN (
	  'audio',
      'computers',
      'computer_accessories',
      'electronics',
      'fixed_telephony',
      'tablets_printing_image',
      'telephony',
      'watches_gifts');
      
-- All sellers (total): EUR 13.591.643
-- Tech sellers : EUR 2.029.682,99 (14,93%)
-- Non-tech sellers: EUR 11.561.960,01 (85,07%)

-- 8. Can you work out the average monthly income of all sellers?
SELECT ROUND(13591643.7 / 3095 / 25, 2) AS avg_monthly_income_all_sellesers;
-- Average monthly income from all sellers: EUR 175,66

--    Can you work out the average monthly income of Tech sellers?
SELECT ROUND(2029682.99 / 356 / 25, 2) AS avg_monthly_income_tech_sellesers;
-- Average monthly income from tech sellers: EUR 228,05



-- Vennel's solutions

-- A. Product Fit

-- A1) List tech categories present in Magist’s data

SELECT DISTINCT pct.product_category_name_english AS tech_category
FROM products p
JOIN product_category_name_translation pct
  ON p.product_category_name = pct.product_category_name
JOIN order_items oi
  ON oi.product_id = p.product_id
WHERE pct.product_category_name_english REGEXP 'aud|compu|elect|tablet|phon|watches';
       

-- A2) How many tech products were sold?
		-- Tech products sold: 4832

SELECT COUNT(DISTINCT oi.product_id) AS tech_products_sold
FROM order_items oi
JOIN products p
  ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
  ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english REGEXP 'aud|compu|elect|tablet|phon|watches';
       
-- A3) Share of sales that are tech
		-- all items sold: 112650
        -- tech items sold: 22044
        -- percentage of tech/all items: 19.57%
	
SELECT
  COUNT(*) AS all_items,
  SUM(CASE WHEN pct.product_category_name_english REGEXP 'aud|compu|elect|tablet|phon|watches'
      THEN 1 ELSE 0 END) AS tech_items,
  ROUND(
    100.0 * SUM(CASE WHEN pct.product_category_name_english REGEXP 'aud|compu|elect|tablet|phon|watches'
        THEN 1 ELSE 0 END) / COUNT(*)
  ,2) AS tech_items_share_percent
FROM order_items oi
JOIN products p  ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
  ON p.product_category_name = pct.product_category_name;
  
-- A4) Average price of tech products (based on sold items)
		-- avergae price of tech products: 133.44 Euros

SELECT ROUND(AVG(oi.price), 2) AS avg_tech_item_price
FROM order_items oi
JOIN products p  ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
  ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english REGEXP 'aud|compu|elect|tablet|phon|watches';
       
-- A5) Popularity of “expensive” tech (75th percentile threshold)
		-- average price 138.44
        -- expensive: greater than 500
        -- mid-range: greater than 100
        -- cheap: less than 100
        -- if above average expensive tech, if below cheap tech
        -- cheap: 16965 tech items sold (76.96%)
        -- mid-range: 4005 tech items sold (18.17%)
        -- expensive: 1074 tech items sold (4.87%)
        
	SELECT
  CASE 
    WHEN oi.price > 500 THEN 'expensive'
    WHEN oi.price > 150 THEN 'mid_range'
    ELSE 'cheap'
  END AS price_category,
  COUNT(*) AS items_sold,
  ROUND(100.0 * COUNT(*) / (SELECT COUNT(*)
    FROM order_items oi2
    JOIN products p2 ON oi2.product_id = p2.product_id
    JOIN product_category_name_translation pct2
      ON p2.product_category_name = pct2.product_category_name
    WHERE pct2.product_category_name_english REGEXP 'aud|compu|elect|tablet|phon|watches'
  ), 2) AS sales_share_percent
FROM order_items oi
JOIN products p  
  ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
  ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english REGEXP 'aud|compu|elect|tablet|phon|watches'
GROUP BY price_category;