-- ============================================
-- File: 04_kpi_queries.sql
-- Purpose: Business KPIs for reporting
-- ============================================

-- 1. Total Revenue
SELECT SUM(SalesAmount) AS TotalRevenue
FROM dbo.FactInternetSales;

-- 2. Total Orders
SELECT COUNT(DISTINCT SalesOrderNumber) AS TotalOrders
FROM dbo.FactInternetSales;

-- 3. Average Order Value
SELECT 
    SUM(SalesAmount) * 1.0 / COUNT(DISTINCT SalesOrderNumber) AS AvgOrderValue
FROM dbo.FactInternetSales;

-- 4. Total Units Sold
SELECT SUM(OrderQuantity) AS TotalUnitsSold
FROM dbo.FactInternetSales;

-- 5. Revenue by Year
SELECT 
    d.CalendarYear,
    SUM(f.SalesAmount) AS Revenue
FROM dbo.FactInternetSales f
JOIN dbo.DimDate d 
    ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;

-- 6. Top 10 Products
SELECT TOP 10
    p.EnglishProductName,
    SUM(f.SalesAmount) AS Revenue
FROM dbo.FactInternetSales f
JOIN dbo.DimProduct p 
    ON f.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY Revenue DESC;