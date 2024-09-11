USE adventurework_store;
SELECT * FROM customer_lookup;
-- Handling the null values
SELECT
    COALESCE(TotalChildren, 0) AS TotalChildren
FROM
    customer_lookup;

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

UPDATE customer_lookup
SET TotalChildren = COALESCE(TotalChildren, 0);

-- List Products by Category Name
SELECT c.CategoryName, p.ProductName
FROM product_lookup p
JOIN product_subcategories_lookup s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN product_categories_lookup c ON s.ProductCategoryKey = c.ProductCategoryKey
ORDER BY c.CategoryName;

-- Find Customers with the Highest Annual Income
SELECT FirstName, LastName, AnnualIncome
FROM customer_lookup
ORDER BY AnnualIncome DESC
LIMIT 10;

-- Total sales in 2020
SELECT SUM(OrderQuantity) AS TotalSales2020
FROM sales_data_2020;

-- Total sales in 2021
SELECT SUM(OrderQuantity) AS TotalSales2021
FROM sales_data_2021;

-- Total sales in 2022
SELECT SUM(OrderQuantity) AS TotalSales2022
FROM sales_data_2022;

-- Find Total Sales per Product in 2020
SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2020 s
JOIN product_lookup p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductName;

-- Find Total Sales per Product in 2021
SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2021 s
JOIN product_lookup p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductName;

-- Find Total Sales per Product in 2022
SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2022 s
JOIN product_lookup p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductName;

-- Total Sales by Region in 2020
SELECT t.Region, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2020 s
JOIN territory_lookup t ON s.TerritoryKey = t.SalesTerritoryKey
GROUP BY t.Region;

-- Total Sales by Region in 2021
SELECT t.Region, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2021 s
JOIN territory_lookup t ON s.TerritoryKey = t.SalesTerritoryKey
GROUP BY t.Region;

-- Total Sales by Region in 2022
SELECT t.Region, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2022 s
JOIN territory_lookup t ON s.TerritoryKey = t.SalesTerritoryKey
GROUP BY t.Region;

-- Find the top 5 products by sales quantity in 2020.
SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalQuantity 
FROM sales_data_2020 s 
JOIN product_lookup p ON s.ProductKey = p.ProductKey 
GROUP BY p.ProductName 
ORDER BY TotalQuantity DESC 
LIMIT 5;

-- Find the top 5 products by sales quantity in 2021.
SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalQuantity 
FROM sales_data_2021 s 
JOIN product_lookup p ON s.ProductKey = p.ProductKey 
GROUP BY p.ProductName 
ORDER BY TotalQuantity DESC 
LIMIT 5;

-- Find the top 5 products by sales quantity in 2022.
SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalQuantity 
FROM sales_data_2022 s 
JOIN product_lookup p ON s.ProductKey = p.ProductKey 
GROUP BY p.ProductName 
ORDER BY TotalQuantity DESC 
LIMIT 5;

-- Determine Product Cost Margin (Profit Margin) by Product
SELECT ProductName, ROUND((ProductPrice - ProductCost) / ProductPrice * 100 ,2) AS ProfitMargin
FROM product_lookup
ORDER BY ProfitMargin DESC;

-- Calculate Average Product Price by Category
SELECT c.CategoryName, ROUND(AVG(p.ProductPrice), 2) AS AvgPrice
FROM product_lookup p
JOIN product_subcategories_lookup s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN product_categories_lookup c ON s.ProductCategoryKey = c.ProductCategoryKey
GROUP BY c.CategoryName;

-- Identify customers who have made purchases every year from 2020 to 2022.
SELECT c.CustomerKey, c.FirstName, c.LastName 
FROM customer_lookup c
WHERE EXISTS (SELECT 1 FROM sales_data_2020 s1 WHERE s1.CustomerKey = c.CustomerKey)
  AND EXISTS (SELECT 1 FROM sales_data_2021 s2 WHERE s2.CustomerKey = c.CustomerKey)
  AND EXISTS (SELECT 1 FROM sales_data_2022 s3 WHERE s3.CustomerKey = c.CustomerKey);
  
-- Analyze Sales Performance by Product Category and Customer Demographics
SELECT 
    c.Gender,
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, c.BirthDate, CURDATE()) < 25 THEN 'Under 25'
        WHEN TIMESTAMPDIFF(YEAR, c.BirthDate, CURDATE()) BETWEEN 25 AND 34 THEN '25-34'
        WHEN TIMESTAMPDIFF(YEAR, c.BirthDate, CURDATE()) BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS AgeGroup,
    cat.CategoryName,
    SUM(s.OrderQuantity) AS TotalSales
FROM 
    customer_lookup c
JOIN 
    sales_data_2022 s ON c.CustomerKey = s.CustomerKey
JOIN 
    product_lookup p ON s.ProductKey = p.ProductKey
JOIN 
    product_subcategories_lookup sub ON p.ProductSubcategoryKey = sub.ProductSubcategoryKey
JOIN 
    product_categories_lookup cat ON sub.ProductCategoryKey = cat.ProductCategoryKey
GROUP BY 
    c.Gender, AgeGroup, cat.CategoryName
ORDER BY 
    TotalSales DESC;
    
-- Identify the top 3 Months with the Highest Sales in 2020
SELECT MONTH(OrderDate) AS Month, SUM(OrderQuantity) AS TotalSales
FROM sales_data_2020
GROUP BY Month
ORDER BY TotalSales DESC
LIMIT 3;

-- Identify the top 3 Months with the Highest Sales in 2021
SELECT MONTH(OrderDate) AS Month, SUM(OrderQuantity) AS TotalSales
FROM sales_data_2021
GROUP BY Month
ORDER BY TotalSales DESC
LIMIT 3;

-- Identify the top 3 Months with the Highest Sales in 2022
SELECT MONTH(OrderDate) AS Month, SUM(OrderQuantity) AS TotalSales
FROM sales_data_2022
GROUP BY Month
ORDER BY TotalSales DESC
LIMIT 3;

-- Calculate the Monthly Sales Trend for Each Region (2020)
SELECT 
    t.Region,
    MONTH(s.OrderDate) AS Month,
    SUM(s.OrderQuantity) AS TotalSales
FROM 
    sales_data_2020 s
JOIN 
    territory_lookup t ON s.TerritoryKey = t.SalesTerritoryKey
GROUP BY 
    t.Region, Month
ORDER BY 
    t.Region, Month;

-- Calculate the Monthly Sales Trend for Each Region (2021)
SELECT 
    t.Region,
    MONTH(s.OrderDate) AS Month,
    SUM(s.OrderQuantity) AS TotalSales
FROM 
    sales_data_2021 s
JOIN 
    territory_lookup t ON s.TerritoryKey = t.SalesTerritoryKey
GROUP BY 
    t.Region, Month
ORDER BY 
    t.Region, Month;

-- Calculate the Monthly Sales Trend for Each Region (2022)
SELECT 
    t.Region,
    MONTH(s.OrderDate) AS Month,
    SUM(s.OrderQuantity) AS TotalSales
FROM 
    sales_data_2022 s
JOIN 
    territory_lookup t ON s.TerritoryKey = t.SalesTerritoryKey
GROUP BY 
    t.Region, Month
ORDER BY 
    t.Region, Month;
    
-- Total Revenue
SELECT 
    ROUND(SUM(s.OrderQuantity * p.ProductPrice),2) AS TotalRevenue
FROM 
    (
        SELECT OrderQuantity, ProductKey FROM sales_data_2020
        UNION ALL
        SELECT OrderQuantity, ProductKey FROM sales_data_2021
        UNION ALL
        SELECT OrderQuantity, ProductKey FROM sales_data_2022
    ) s
JOIN 
    product_lookup p ON s.ProductKey = p.ProductKey;

-- Total Profit
SELECT 
   ROUND(SUM(s.OrderQuantity * (p.ProductPrice - p.ProductCost)),2) AS TotalProfit
FROM 
    (
        SELECT OrderQuantity, ProductKey FROM sales_data_2020
        UNION ALL
        SELECT OrderQuantity, ProductKey FROM sales_data_2021
        UNION ALL
        SELECT OrderQuantity, ProductKey FROM sales_data_2022
    ) s
JOIN 
    product_lookup p ON s.ProductKey = p.ProductKey;


-- Monthly Revenue
SELECT 
    YEAR(s.OrderDate) AS Year,
    MONTH(s.OrderDate) AS Month,
    ROUND(SUM(s.OrderQuantity * p.ProductPrice),2) AS MonthlyRevenue
FROM 
    (
        SELECT OrderDate, OrderQuantity, ProductKey FROM sales_data_2020
        UNION ALL
        SELECT OrderDate, OrderQuantity, ProductKey FROM sales_data_2021
        UNION ALL
        SELECT OrderDate, OrderQuantity, ProductKey FROM sales_data_2022
    ) s
JOIN 
    product_lookup p ON s.ProductKey = p.ProductKey
GROUP BY 
    Year, Month
ORDER BY 
    Year, Month;

-- Monthly Orders
SELECT 
    YEAR(s.OrderDate) AS Year,
    MONTH(s.OrderDate) AS Month,
    SUM(s.OrderQuantity) AS MonthlyOrders
FROM 
    (
        SELECT OrderDate, OrderQuantity FROM sales_data_2020
        UNION ALL
        SELECT OrderDate, OrderQuantity FROM sales_data_2021
        UNION ALL
        SELECT OrderDate, OrderQuantity FROM sales_data_2022
    ) s
GROUP BY 
    Year, Month
ORDER BY 
    Year, Month;
    
-- Find the total revenue generated per year.
SELECT '2020' AS Year, ROUND(SUM(p.ProductPrice * s.OrderQuantity),2) AS TotalRevenue 
FROM sales_data_2020 s 
JOIN product_lookup p ON s.ProductKey = p.ProductKey
UNION
SELECT '2021', ROUND(SUM(p.ProductPrice * s.OrderQuantity),2)
FROM sales_data_2021 s 
JOIN product_lookup p ON s.ProductKey = p.ProductKey
UNION
SELECT '2022', ROUND(SUM(p.ProductPrice * s.OrderQuantity),2)
FROM sales_data_2022 s 
JOIN product_lookup p ON s.ProductKey = p.ProductKey;
    
-- Calculate the Sales Growth from 2020 to 2021
SELECT (SUM(s2021.OrderQuantity) - SUM(s2020.OrderQuantity)) / SUM(s2020.OrderQuantity) * 100 AS SalesGrowth
FROM sales_data_2020 s2020, sales_data_2021 s2021;

-- Count the total number of orders returned per territory.
SELECT t.Region, COUNT(r.ReturnDate) AS TotalReturns 
FROM returns_data r 
JOIN territory_lookup t ON r.TerritoryKey = t.SalesTerritoryKey 
GROUP BY t.Region;

-----------------------
-- Average Profit by categories
SELECT
    pc.CategoryName,
    ROUND(AVG((pl.ProductPrice - pl.ProductCost) / pl.ProductPrice * 100),2) AS AvgProfitMargin
FROM
    product_categories_lookup pc
JOIN
    product_subcategories_lookup ps ON pc.ProductCategoryKey = ps.ProductCategoryKey
JOIN
    product_lookup pl ON ps.ProductSubcategoryKey = pl.ProductSubcategoryKey
GROUP BY
    pc.CategoryName
LIMIT 0, 2000;


SELECT 
    YEAR(ReturnDate) AS Year,
    SUM(ReturnQuantity) AS TotalReturned
FROM 
    returns_data
GROUP BY 
    YEAR(ReturnDate)    
ORDER BY 
    Year;

-- The total returned items by each category and country   
SELECT
    pc.CategoryName,
    tl.Country,  -- Adjust this to the actual column name for country
    SUM(rd.ReturnQuantity) AS TotalReturned
FROM
    product_categories_lookup pc
JOIN
    product_subcategories_lookup ps ON pc.ProductCategoryKey = ps.ProductCategoryKey
JOIN
    product_lookup pl ON ps.ProductSubcategoryKey = pl.ProductSubcategoryKey
JOIN
    returns_data rd ON pl.ProductKey = rd.ProductKey
JOIN
    territory_lookup tl ON rd.TerritoryKey = tl.SalesTerritoryKey  -- Ensure correct table name and column
GROUP BY
    pc.CategoryName,
    tl.Country
ORDER BY
    pc.CategoryName,
    tl.Country
LIMIT 0, 2000;
    


