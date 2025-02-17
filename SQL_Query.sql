-- Problem Statements

SELECT * FROM coffee_shop_sales;
-- 1. Calculate the Total_sales for Each Month 

SELECT ROUND(SUM(transaction_qty*unit_price),0) as Total_Sales
FROM coffee_shop_sales
Where 
month(transaction_date)= 5; -- May month

-- 2. Calculate the diff in sales b/w the selected month and the previous month

SELECT
		MONTH(transaction_date) as Month,
        ROUND(SUM(transaction_qty*unit_price),0) as Total_Sales, -- Total_Sales
        (SUM(transaction_qty*unit_price) - LAG(SUM(transaction_qty*unit_price),1) -- Month_sales_Differance
        OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty*unit_price),1) -- Divided by previos month sales
        OVER (ORDER BY MONTH(transaction_date))*100 AS mom_increase_percentage -- Percentage
FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) IN (4,5) -- For month of April(PM) and May(CM)
GROUP BY
	MONTH(transaction_date)
ORDER BY
	month(transaction_date);
        
-- 3. Calculate the Total Number of Order for Each months

SELECT MONTH(transaction_date) AS order_month ,count(transaction_id) AS Total_order
FROM coffee_shop_sales
GROUP BY
	MONTH(transaction_date);
    
-- 4. Calculate the diff in Number Of Orders b/w the selected month and the previous month
SELECT
		MONTH(transaction_date) as Month,
        ROUND(COUNT(transaction_qty*unit_price),2) as Total_Sales, -- Total_Ordes
        (COUNT(transaction_qty*unit_price) - LAG(COUNT(transaction_qty*unit_price),1) -- Month_Order_Differance
        OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_qty*unit_price),1) -- Divided by previos month Order
        OVER (ORDER BY MONTH(transaction_date))*100 AS mom_increase_percentage -- Percentage
FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) IN (4,5) -- For month of April(PM) and May(CM)
GROUP BY
	MONTH(transaction_date)
ORDER BY
	month(transaction_date);

-- 5.Calculate the Total Quantity Sold for Each months
SELECT MONTH(transaction_date) AS Months,SUM(transaction_qty) AS Total_Quantity_Sold
FROM coffee_shop_sales
GROUP BY
MONTH(transaction_date);

-- 6. Calculate the diff in Number Of Orders b/w the selected month and the previous month
SELECT
		MONTH(transaction_date) as Months,
        ROUND(SUM(transaction_qty),2) as Total_Quantity_sold, -- Total_Quantity_sold
        (SUM(transaction_qty) - LAG(SUM(transaction_qty),1) 
        OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty),1) -- Divided by previos month Order
        OVER (ORDER BY MONTH(transaction_date))*100 AS mom_increase_percentage -- Percentage
FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) IN (4,5) -- For month of April(PM) and May(CM)
GROUP BY
	MONTH(transaction_date)
ORDER BY
	month(transaction_date);
    
-- 7. On Daily Basis Sales,Quantity and Orders

 SELECT 
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1),'K') AS total_sales,
    CONCAT(ROUND(COUNT(transaction_id) / 1000, 1),'K') AS total_orders,
    CONCAT(ROUND(SUM(transaction_qty) / 1000, 1),'K') AS total_quantity_sold
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18';

-- 8. Sales on Weekdays and Weekend

SELECT 
	CASE WHEN dayofweek(transaction_date) IN (1,7) THEN 'WEEKDAYS'
    ELSE 'WEEKEND'
    END AS day_type,
    CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),'K') AS Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5
GROUP BY 
	CASE WHEN dayofweek(transaction_date) IN (1,7) THEN 'WEEKDAYS'
    ELSE 'WEEKEND'
    END;
    
-- 9. Sales by Store Location for respective months

SELECT 
	store_location,
    CONCAT(ROUND(SUM(transaction_qty*unit_price)/1000,2),'k') AS total_Sales
FROM 
	coffee_shop_sales
WHERE
	MONTH(transaction_date) = 6
GROUP by
	store_location
ORDER BY
	total_Sales desc;
    
-- 10. Sales Trends Over a Periods
SELECT 
	CONCAT(ROUND(AVG(total_sales)/1000,2),'k') AS Avg_sales
FROM 
	(
		SELECT SUM(transaction_qty*unit_price) AS total_sales
        FROM coffee_shop_sales
        WHERE MONTH(transaction_date)=5
        GROUP BY transaction_date
	) AS Internal_query;

-- 11. Total Sales on Daily Basis for respective Months
SELECT 
    DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- For May month
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);

-- 12. COMPARING DAILY SALES WITH AVERAGE SALES –
-- IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”	

SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffee_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;
    
-- 13. Total Sales by Product Category

SELECT 
	product_category,
	CONCAT(ROUND(SUM(unit_price * transaction_qty),1),'k') as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY Total_Sales DESC;

-- 14. Total Sales by Product-Type

SELECT 
	product_type,
	CONCAT(ROUND(SUM(unit_price * transaction_qty),1),'k') as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY Total_Sales DESC
LIMIT 10;


-- 15. Total Sales, Quantity Sold and Order by Day and Hours for respective Months

SELECT
	SUM(transaction_qty*unit_price) AS totl_Sales,
    SUM(transaction_qty) AS total_qnt_Sold,
    COUNT(*) AS Total_Orders
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date)= 5 AND
    DAYOFWEEK(transaction_date)= 1 AND
    HOUR(transaction_time) = 14
GROUP BY MONTH(transaction_date);

-- 16. Total Sales for All Hours for Respective Months

SELECT
	HOUR(transaction_time),
    SUM(transaction_qty * unit_price) AS Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5
GROUP BY HOUR(transaction_time)
ORDER BY transaction_time DESC ;

-- 17 Total_Sales From Monday To Sunday for Respective Months
    
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- for May Month
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;


    
