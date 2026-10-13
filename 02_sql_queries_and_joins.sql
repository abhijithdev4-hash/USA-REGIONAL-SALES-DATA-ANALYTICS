use northwind_db;
-- find total numbers of orders placed by each coustomers
SELECT 
    customerid,
    COUNT(orderid) AS total_orders
FROM orders
GROUP BY customerid;
-- find all categories and how many products belongs to each category
   select categoryid , categoryname from categories;
select categoryid,
 count( productid) as total_products from products
    group by categoryid;
-- calculate the total sales ( price* quantity) for each order
use northwind_db;
SELECT 
    od.OrderID, 
    SUM(p.Price * od.Quantity) AS TotalSales
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY od.OrderID;
-- show the total quantity of products ordered by each customers
use northwind_db;
SELECT 
    c.CustomerName, 
    SUM(od.Quantity) AS TotalQuantityOrdered
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerName;
-- list customers along with the number of order theyb placed ( including those with 0 orders)
SELECT 
    c.CustomerName, 
    o.OrderID, 
    o.OrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerName;
-- display employee along with the number of order thet handeled
SELECT 
    e.FirstName, 
    e.LastName, 
    COUNT(o.OrderID) AS NumberOfOrders
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY NumberOfOrders DESC;
-- show all products along with their supplier name
SELECT 
    p.ProductName, 
    s.SupplierName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
ORDER BY p.ProductName;
-- retrieve all orders along with customer name
SELECT 
    o.OrderID, 
    c.CustomerName, 
    o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderID;
-- show all orders with employee first and last name who handeled them
SELECT 
    o.OrderID, 
    e.FirstName, 
    e.LastName, 
    o.OrderDate
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
ORDER BY o.OrderID;
-- retrive product name, their category name, ans supplier name in single query
SELECT 
    p.ProductName, 
    c.CategoryName, 
    s.SupplierName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Suppliers s ON p.SupplierID = s.SupplierID;
-- list all orders with supplier name included
SELECT DISTINCT
    o.OrderID,
    s.SupplierName
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
ORDER BY o.OrderID;
-- show all the number of order shipped by each shipper
SELECT 
    s.ShipperName, 
    COUNT(o.OrderID) AS NumberOfOrders
FROM Shippers s
LEFT JOIN Orders o ON s.ShipperID = o.ShipperID
GROUP BY s.ShipperName;
-- retrive the name of employee who have handled more than 50 orders
SELECT 
    e.FirstName, 
    e.LastName, 
    COUNT(o.OrderID) AS OrderCount
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(o.OrderID) > 50;

