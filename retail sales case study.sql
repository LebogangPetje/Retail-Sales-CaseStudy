--columns : customer_id, age, gender, item_purchased, location, size, color, season, review rating, subscription status, shipping type, discount_applied, promo code used, pervious purchases, payment method, frequency of purchases

SELECT 
    customer_id,
    gender,
    subscription_status,
    discount_applied,
    promo_code_used,
    
--- Age bucket
    CASE
        WHEN age < 18 THEN 'Underage'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        WHEN age BETWEEN 61 AND 70 THEN '61-70'
        ELSE 'Over 70'
    END AS age_group,

    -- PURCHASE AMOUNT BUCKET
    CASE
        WHEN purchase_amount < 30 THEN 'Low'
        WHEN purchase_amount BETWEEN 30 AND 60 THEN 'Medium'
        WHEN purchase_amount BETWEEN 61 AND 80 THEN 'High'
        WHEN purchase_amount > 80 THEN 'Very High'
        ELSE 'Unspecified'
    END AS purchase_amount_category,

    -- REVIEW RATING BUCKET
    CASE
        WHEN review_rating < 3 THEN 'Poor'
        WHEN review_rating >= 3 AND review_rating <= 3.5 THEN 'Average'
        WHEN review_rating > 3.5 AND review_rating <= 4.5 THEN 'Good'
        WHEN review_rating > 4.5 THEN 'Excellent'
        ELSE 'Unspecified'
    END AS review_category,

    -- PREVIOUS PURCHASE BUCKET (numeric-safe)
    CASE
        WHEN previous_purchases BETWEEN 1 AND 10 THEN 'Low'
        WHEN previous_purchases BETWEEN 11 AND 30 THEN 'Average'
        WHEN previous_purchases BETWEEN 31 AND 50 THEN 'High'
        ELSE 'No Previous Purchase'
    END AS previous_purchase_category,

    -- FREQUENCY CATEGORY (case-insensitive)
    CASE
        WHEN LOWER(frequency_of_purchases) IN ('weekly','fortnightly','bi-weekly','monthly') THEN 'Frequent Buyer'
        WHEN LOWER(frequency_of_purchases) IN ('every 3 months','annual quarterly') THEN 'Occasional Buyer'
        ELSE 'Unspecified'
    END AS purchase_frequency_category,

    -- SHIPPING BUCKET (case-insensitive)
    CASE
        WHEN LOWER(shipping_type) IN ('standard','store pick up','free shipping') THEN 'Normal Shipping'
        WHEN LOWER(shipping_type) IN ('express','next day air','2 day shipping') THEN 'Fast Shipping'
        ELSE 'Unspecified'
    END AS shipping_category,

    -- CLEAN NULLS (strings only)
    COALESCE(season, 'Unspecified') AS season_category,
    COALESCE(item_purchased, 'Unspecified') AS item_purchase_category,
    COALESCE(location, 'Unspecified') AS location_category,
    COALESCE(color, 'Unspecified') AS color_category,
    COALESCE(size, 'Unspecified') AS size_category,
    COALESCE(frequency_of_purchases, 'Unspecified') AS frequency_category,
    COALESCE(shipping_type, 'Unspecified') AS shipping_category,
    COALESCE(payment_method, 'Unspecified') AS payment_category,

    -- CLEAN NULLS (numeric columns)
    COALESCE(purchase_amount, 0) AS purchase_amount_clean,
    COALESCE(previous_purchases, 0) AS previous_purchases_clean,
    COALESCE(review_rating, 0) AS review_rating_clean,
    COALESCE (age, 0) AS age_clean,
FROM shop.public.trends;

--replace null in the data /// replace all of this coalesce, note to self (nb to use coalesce in such instances, no need to take the long route)

---looking at ranges for buckets 

SELECT 
min(previous_purchases)
from shop.public.trends;

select max(previous_purchases)
from shop.public.trends;
;

select avg(previous_purchases) 
from shop.public.trends;

select distinct frequency_of_purchases 
from shop.public.trends;
--age  min 18, max 70, avg 44.9
---purchase_amount  min 20, max 100, avg 59, 
--review_rating min 2.5, max 5.0, avg 3.68
--previous_purchase min 1.0, max 50.0, avg 25.6





---case statements:


---- frequency bucket 


---age bucket 
-- review bucket 
--- total spend bucket (previous purchases+ purchase amount)


---graph ideas: clothing category by sales, top 3 of items purchase, bottom 3 of items purchased, sales by size, sales by colour
--- sales by gender, category sales by gender, 
--- age bucket by sales, age bucket category 
---sales by location in desc, customer count by loaction, sales by season, shipping type by customer count 
---review bucket by customer count,
--subscription by sales ,
--- sales by prmom code used 
---sales by payment method, sales by frequency of purchases, 
--- nb purchase price is the seeling price 





---we have previous purchases and current purchase price and frequency of purchases. average spending amount per purchase 

---metrics we needed:1. What is the daily sales price per unit? 2. What is the average unit sales price of this product? 3. What is the daily % gross profit? 4. What is the daily % gross profit per unit? 
--profit = selling price (purchase price)*quantity 
--