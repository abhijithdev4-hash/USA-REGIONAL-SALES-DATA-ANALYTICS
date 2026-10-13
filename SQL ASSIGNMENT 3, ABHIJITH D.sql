use northwind_db;
-- use NTILE(5) to bucket employees based on the number of order they handeled
WITH EmployeeOrderCounts AS (
    SELECT 
        e.FirstName, 
        e.LastName, 
        COUNT(o.OrderID) AS TotalOrders
    FROM Employees e
    LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT 
    FirstName, 
    LastName, 
    TotalOrders,
    NTILE(5) OVER (ORDER BY TotalOrders DESC) AS OrderBucket
FROM EmployeeOrderCounts;
-- use NTILE(2) to split product into higher price and lower price group
SELECT 
    ProductName, 
    Price,
    NTILE(2) OVER (ORDER BY Price DESC) AS PriceGroup
FROM Products;
-- use NTILE(10) to assign deciles to products by revenue generated
WITH ProductRevenue AS (
    SELECT 
        p.ProductName, 
        SUM(p.Price * od.Quantity) AS TotalRevenue
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT 
    ProductName, 
    TotalRevenue,
    NTILE(10) OVER (ORDER BY TotalRevenue DESC) AS RevenueDecile
FROM ProductRevenue;
-- for each order, show total quantity and also display the overall average quantity across all order (avg order)
SELECT 
    OrderID, 
    SUM(Quantity) AS TotalQuantity,
    AVG(SUM(Quantity)) OVER() AS AvgOrderQuantity
FROM OrderDetails
GROUP BY OrderID;
-- USE LAG () TO COMPARE EACH EMPLOYEE'S ORDER COUNT WITH THE PREVIOUS EMPLOYEE'S ORDER COUNT
WITH EmployeeOrderCount AS (
    SELECT 
        e.FirstName, 
        e.LastName, 
        COUNT(o.OrderID) AS OrderCount
    FROM Employees e
    LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT 
    FirstName, 
    LastName, 
    OrderCount,
    LAG(OrderCount) OVER (ORDER BY OrderCount DESC) AS PreviousOrderCount,
    (LAG(OrderCount) OVER (ORDER BY OrderCount DESC) - OrderCount) AS Difference
FROM EmployeeOrderCount
ORDER BY OrderCount DESC;
-- USE LEAD () TO DISPLAY EACH PRODUCT WITH THE NEXT HIGHER PRICED PRODUCT
SELECT 
    ProductName, 
    Price,
    LEAD(ProductName) OVER (ORDER BY Price ASC) AS NextHigherPricedProduct,
    LEAD(Price) OVER (ORDER BY Price ASC) AS NextPrice
FROM Products
ORDER BY Price ASC;
-- USE LAG() TO SHOW REVENUE PER ORDER AND THE REVENUE FROM PRIOR FOR COMPARISON
WITH OrderRevenue AS (
    SELECT 
        od.OrderID, 
        SUM(p.Price * od.Quantity) AS TotalRevenue
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY od.OrderID
)
SELECT 
    OrderID,
    TotalRevenue,
    LAG(TotalRevenue) OVER (ORDER BY OrderID) AS PriorOrderRevenue
FROM OrderRevenue
ORDER BY OrderID ASC;
-- ASSIGN A UNIQUE ROW NUMBER TO EACH PRODUCT WITHIN ITS CATEGORY, ORDERED BY PRICE ( LOWEST TO HIGHEST)
SELECT 
    c.CategoryName,
    p.ProductName,
    p.Price,
    ROW_NUMBER() OVER (
        PARTITION BY p.CategoryID 
        ORDER BY p.Price ASC
    ) AS ProductRankInCategory
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;
-- RANK EMPLOYEES BASED ON THE TOTAL REVENUE GENERATED FROM THE ORDERS THET HANDELED
WITH EmployeeRevenue AS (
    SELECT 
        e.FirstName, 
        e.LastName, 
        SUM(p.Price * od.Quantity) AS TotalRevenue
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT 
    FirstName, 
    LastName, 
    TotalRevenue,
    RANK() OVER (ORDER BY TotalRevenue DESC) AS RevenueRank
FROM EmployeeRevenue;
-- RANK SUPPLIERS BY THE NUMBER OF PRODUCT THET SUPPLY, WITHOUT SKIPPING RANK FOR TIES
SELECT 
    s.SupplierName, 
    COUNT(p.ProductID) AS ProductCount,
    DENSE_RANK() OVER (ORDER BY COUNT(p.ProductID) DESC) AS SupplierRank
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName;
-- FOR EACH CATEGORY, SHOW ALL PRODUCTS ALONSIDE THGE CHEAPEST PRODUCT IN THE CATEGORY
SELECT 
    c.CategoryName,
    p.ProductName,
    p.Price,
    FIRST_VALUE(p.ProductName) OVER (
        PARTITION BY p.CategoryID 
        ORDER BY p.Price ASC
    ) AS CheapestProductInCategory,
    FIRST_VALUE(p.Price) OVER (
        PARTITION BY p.CategoryID 
        ORDER BY p.Price ASC
    ) AS MinPriceInCategory
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;
-- FOR EACH CATEGORY, SHOW ALL PRODUCT ALONGSIDE THE MOST EXPENSIVE PRODUCT IN THAT CATEGORY
SELECT 
    c.CategoryName,
    p.ProductName,
    p.Price,
    FIRST_VALUE(p.ProductName) OVER (
        PARTITION BY p.CategoryID 
        ORDER BY p.Price DESC
    ) AS MostExpensiveProduct,
    FIRST_VALUE(p.Price) OVER (
        PARTITION BY p.CategoryID 
        ORDER BY p.Price DESC
    ) AS MaxPriceInCategory
FROM Products P
JOIN Categories c ON p.CategoryID = c.CategoryID;
-- FOR EACH CUSTOMERS, DISPLAY EACH OF THEIRR ORDER ALONG WITH A RUNNING TOTAL OF QUANTITIES ORDERED (PARTITIONED BY CUSTOMERS)_
WITH OrderTotals AS (
    SELECT 
        o.CustomerID,
        o.OrderID,
        o.OrderDate,
        SUM(od.Quantity) AS TotalOrderQuantity
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID, o.OrderID, o.OrderDate
)
SELECT 
    CustomerID,
    OrderID,
    OrderDate,
    TotalOrderQuantity,
    SUM(TotalOrderQuantity) OVER (
        PARTITION BY CustomerID 
        ORDER BY OrderDate, OrderID
    ) AS RunningTotalQuantity
FROM OrderTotals;
-- SHOW EACH PRODUCT PRICE ALONG WITH THE MAXIMUM PRICE IN ITS CATEGORY
SELECT 
    c.CategoryName,
    p.ProductName,
    p.Price,
    MAX(p.Price) OVER (PARTITION BY p.CategoryID) AS MaxCategoryPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;
-- SHOW EACH ORDER'S TOTAL QUANTITY ALONG WITH THE MINIMUM QUANTITY ORDERED ACROSS ALL ORDERS 
WITH OrderTotals AS (
    SELECT 
        OrderID, 
        SUM(Quantity) AS TotalOrderQuantity
    FROM OrderDetails
    GROUP BY OrderID
)
SELECT 
    OrderID, 
    TotalOrderQuantity,
    MIN(TotalOrderQuantity) OVER() AS GlobalMinOrderQuantity
FROM OrderTotals;