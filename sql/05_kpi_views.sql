-- ============================================
-- View: vw_SalesSummary
-- Purpose: Core business KPIs
-- ============================================

CREATE VIEW vw_SalesSummary AS
SELECT 
    SUM(SalesAmount) AS TotalRevenue,
    COUNT(DISTINCT SalesOrderNumber) AS TotalOrders,
    SUM(OrderQuantity) AS TotalUnitsSold,
    SUM(SalesAmount) * 1.0 / COUNT(DISTINCT SalesOrderNumber) AS AvgOrderValue
FROM dbo.FactInternetSales;

CREATE VIEW vw_RevenueByYear AS
SELECT 
    d.CalendarYear,
    SUM(f.SalesAmount) AS Revenue
FROM dbo.FactInternetSales f
JOIN dbo.DimDate d 
    ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear;

CREATE VIEW vw_ProductPerformance AS
SELECT 
    p.EnglishProductName,
    SUM(f.SalesAmount) AS Revenue,
    SUM(f.OrderQuantity) AS TotalUnits
FROM dbo.FactInternetSales f
JOIN dbo.DimProduct p 
    ON f.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName;

CREATE VIEW vw_MonthlyRevenue AS
SELECT 
    d.CalendarYear,
    d.MonthNumberOfYear,
    SUM(f.SalesAmount) AS Revenue
FROM dbo.FactInternetSales f
JOIN dbo.DimDate d 
    ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear, d.MonthNumberOfYear;

