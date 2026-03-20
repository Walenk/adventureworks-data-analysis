-- ============================================
-- File: 02_data_validation.sql
-- Description: Validate data quality in FactInternetSales
-- ============================================

-- 1. Check total records
SELECT COUNT(*) AS TotalRecords
FROM dbo.FactInternetSales;

-- 2. Check for NULL values
SELECT *
FROM dbo.FactInternetSales
WHERE CustomerKey IS NULL
   OR ProductKey IS NULL
   OR OrderDateKey IS NULL
   OR SalesAmount IS NULL;

-- 3. Check for duplicate sales orders
SELECT SalesOrderNumber, COUNT(*) AS Count
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber
HAVING COUNT(*) > 1;

-- 4. Check for negative or zero sales
SELECT *
FROM dbo.FactInternetSales
WHERE SalesAmount <= 0;

-- 5. Check date range
SELECT 
    MIN(OrderDateKey) AS MinDate,
    MAX(OrderDateKey) AS MaxDate
FROM dbo.FactInternetSales;
