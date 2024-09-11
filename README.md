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
