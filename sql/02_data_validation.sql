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

-- ============================================
-- SECTION 6: VALIDATION SUMMARY (PASS/FAIL)
-- ============================================

WITH ValidationResults AS (

    SELECT 'Null ProductKey' AS CheckName,
           COUNT(*) AS IssueCount
    FROM dbo.FactInternetSales
    WHERE ProductKey IS NULL

    UNION ALL

    SELECT 'Null OrderDateKey',
           COUNT(*)
    FROM dbo.FactInternetSales
    WHERE OrderDateKey IS NULL

    UNION ALL

    SELECT 'Duplicate SalesOrderNumber',
           COUNT(*)
    FROM (
        SELECT SalesOrderNumber
        FROM dbo.FactInternetSales
        GROUP BY SalesOrderNumber
        HAVING COUNT(*) > 1
    ) d

    UNION ALL

    SELECT 'Missing ProductKey in DimProduct',
           COUNT(*)
    FROM dbo.FactInternetSales f
    LEFT JOIN dbo.DimProduct p 
        ON f.ProductKey = p.ProductKey
    WHERE p.ProductKey IS NULL

    UNION ALL

    SELECT 'Missing DateKey in DimDate',
           COUNT(*)
    FROM dbo.FactInternetSales f
    LEFT JOIN dbo.DimDate d 
        ON f.OrderDateKey = d.DateKey
    WHERE d.DateKey IS NULL

    UNION ALL

    SELECT 'Invalid SalesAmount (<=0)',
           COUNT(*)
    FROM dbo.FactInternetSales
    WHERE SalesAmount <= 0

    UNION ALL

    SELECT 'Invalid OrderQuantity (<=0)',
           COUNT(*)
    FROM dbo.FactInternetSales
    WHERE OrderQuantity <= 0
)

SELECT 
    CheckName,
    IssueCount,
    CASE 
        WHEN IssueCount = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS Status
FROM ValidationResults
ORDER BY Status DESC, IssueCount DESC;
