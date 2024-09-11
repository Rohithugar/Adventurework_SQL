# Adventurework Shop Project

## Project Objective
To utilize SQL scripts for analyzing sales, customer, and product data from the AdventureWorks repository to address key business questions and derive actionable insights aimed at improving business performance.

## Project Overview
## Business Questions Addressed
1. List Products by Category Name.
2. Total sales in 2020, 2021, 2022.
3. Find Total Sales per Product in 2020, 2021, 2022.
4. Total Sales by Region in 2020, 2021, 2022.
5. Find the top 5 products by sales quantity in 2020, 2021, 2022.
6. Determine Product Cost Margin (Profit Margin) by Product.
7. Calculate Average Product Price by Category.
8. Identify customers who have made purchases every year from 2020 to 2022.
9. Analyze Sales Performance by Product Category and Customer Demographics.
10. Identify the top 3 Months with the Highest Sales in 2020, 2021, 2022.
11. Total Revenue.
12. Total Profit.
13. Monthly Revenue.
14. Monthly Orders.
15. Find the total revenue generated per year.
16. Count the total number of orders returned per territory.
17. Average Profit by categories.
18. The total returned items by each category and country

## SQL SCRIPT TO SOLVE BUSINESS QUESTION

1. List Products by Category Name.
``` sql
SELECT c.CategoryName, p.ProductName
FROM product_lookup p
JOIN product_subcategories_lookup s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN product_categories_lookup c ON s.ProductCategoryKey = c.ProductCategoryKey
ORDER BY c.CategoryName;
```
2. Total sales in 2020, 2021, 2022.
``` sql
SELECT SUM(OrderQuantity) AS TotalSales2020
FROM sales_data_2020;

SELECT SUM(OrderQuantity) AS TotalSales2021
FROM sales_data_2021;

SELECT SUM(OrderQuantity) AS TotalSales2022
FROM sales_data_2022;
```
3. Find Total Sales per Product in 2020, 2021, 2022.
``` sql
SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2020 s
JOIN product_lookup p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductName;

SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2021 s
JOIN product_lookup p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductName;

SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2022 s
JOIN product_lookup p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductName;
```
4. Total Sales by Region in 2020, 2021, 2022.
``` sql
SELECT t.Region, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2020 s
JOIN territory_lookup t ON s.TerritoryKey = t.SalesTerritoryKey
GROUP BY t.Region;

SELECT t.Region, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2021 s
JOIN territory_lookup t ON s.TerritoryKey = t.SalesTerritoryKey
GROUP BY t.Region;

SELECT t.Region, SUM(s.OrderQuantity) AS TotalSales
FROM sales_data_2022 s
JOIN territory_lookup t ON s.TerritoryKey = t.SalesTerritoryKey
GROUP BY t.Region;
```
5. Find the top 5 products by sales quantity in 2020, 2021, 2022.
``` sql
SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalQuantity 
FROM sales_data_2020 s 
JOIN product_lookup p ON s.ProductKey = p.ProductKey 
GROUP BY p.ProductName 
ORDER BY TotalQuantity DESC 
LIMIT 5;

SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalQuantity 
FROM sales_data_2021 s 
JOIN product_lookup p ON s.ProductKey = p.ProductKey 
GROUP BY p.ProductName 
ORDER BY TotalQuantity DESC 
LIMIT 5;

SELECT p.ProductName, SUM(s.OrderQuantity) AS TotalQuantity 
FROM sales_data_2022 s 
JOIN product_lookup p ON s.ProductKey = p.ProductKey 
GROUP BY p.ProductName 
ORDER BY TotalQuantity DESC 
LIMIT 5;
```
6. Determine Product Cost Margin (Profit Margin) by Product.
``` sql
SELECT ProductName, ROUND((ProductPrice - ProductCost) / ProductPrice * 100 ,2) AS ProfitMargin
FROM product_lookup
ORDER BY ProfitMargin DESC;
```
7. Calculate Average Product Price by Category.
``` sql
SELECT c.CategoryName, ROUND(AVG(p.ProductPrice), 2) AS AvgPrice
FROM product_lookup p
JOIN product_subcategories_lookup s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN product_categories_lookup c ON s.ProductCategoryKey = c.ProductCategoryKey
GROUP BY c.CategoryName;
```
8. Identify customers who have made purchases every year from 2020 to 2022.
``` sql
SELECT c.CustomerKey, c.FirstName, c.LastName 
FROM customer_lookup c
WHERE EXISTS (SELECT 1 FROM sales_data_2020 s1 WHERE s1.CustomerKey = c.CustomerKey)
  AND EXISTS (SELECT 1 FROM sales_data_2021 s2 WHERE s2.CustomerKey = c.CustomerKey)
  AND EXISTS (SELECT 1 FROM sales_data_2022 s3 WHERE s3.CustomerKey = c.CustomerKey);
```
9. Analyze Sales Performance by Product Category and Customer Demographics.
``` sql
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
``` 
10. Identify the top 3 Months with the Highest Sales in 2020, 2021, 2022.
``` sql
SELECT MONTH(OrderDate) AS Month, SUM(OrderQuantity) AS TotalSales
FROM sales_data_2020
GROUP BY Month
ORDER BY TotalSales DESC
LIMIT 3;

SELECT MONTH(OrderDate) AS Month, SUM(OrderQuantity) AS TotalSales
FROM sales_data_2021
GROUP BY Month
ORDER BY TotalSales DESC
LIMIT 3;

SELECT MONTH(OrderDate) AS Month, SUM(OrderQuantity) AS TotalSales
FROM sales_data_2022
GROUP BY Month
ORDER BY TotalSales DESC
LIMIT 3;
``` 
11. Total Revenue.
``` sql

``` 
12. Total Profit.
13. Monthly Revenue.
14. Monthly Orders.
15. Find the total revenue generated per year.
16. Count the total number of orders returned per territory.
17. Average Profit by categories.
18. The total returned items by each category and country
