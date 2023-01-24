--1) Tulis query untuk mendapatkan jumlah customer tiap bulan yang melakukan order pada tahun 1997.

--SELECT DATENAME(MONTH, DATEADD(MONTH, MONTH(Orders.OrderDate), -1)) AS 'Month',
--	COUNT(DISTINCT Orders.CustomerID) AS CustomersTotal
--	FROM Northwind.dbo.Orders AS Orders
--	WHERE YEAR(Orders.OrderDate) = 1997
--	GROUP BY MONTH(Orders.OrderDate);


--2) Tulis query untuk mendapatkan nama employee yang termasuk Sales Representative.

--SELECT Employees.FirstName + ' ' + Employees.LastName AS 'Sales Representative Employee'
--	FROM Northwind.dbo.Employees AS Employees
--	WHERE Employees.Title = 'Sales Representative';


--3) Tulis query untuk mendapatkan top 5 nama produk yang quantitynya paling banyak diorder pada bulan Januari 1997.

--SELECT TOP 5 order_details.ProductName, SUM(order_details.Quantity) AS TotalQuantity
--	FROM Northwind.dbo.Orders AS orders
--	LEFT JOIN (
--		SELECT OrderDetails.OrderID, OrderDetails.Quantity, Products.ProductName
--		FROM Northwind.dbo.[Order Details] as OrderDetails
--		LEFT JOIN Northwind.dbo.Products as Products
--		ON OrderDetails.ProductID = Products.ProductID
--	) AS order_details
--	ON orders.OrderID = order_details.OrderID
--	WHERE YEAR(orders.OrderDate) = 1997 AND MONTH(orders.OrderDate) = 1
--	GROUP BY order_details.ProductName
--	ORDER BY TotalQuantity DESC;


--4) Tulis query untuk mendapatkan nama company yang melakukan order Chai pada bulan Juni 1997.

--SELECT Orders.OrderID, Customers.CompanyName, Orders.OrderDate, Products.ProductName
--	FROM Northwind.dbo.Orders AS Orders
--	LEFT JOIN Northwind.dbo.Customers AS Customers
--	ON Orders.CustomerID = Customers.CustomerID
--	RIGHT JOIN (
--		SELECT OrderDetails.OrderID, Product.ProductName
--		FROM Northwind.dbo.[Order Details] AS OrderDetails
--		LEFT JOIN Northwind.dbo.Products AS Product
--		ON OrderDetails.ProductID = Product.ProductID
--		WHERE Product.ProductName = 'Chai'
--	) AS Products
--	ON Orders.OrderID = Products.OrderID
--	WHERE YEAR(Orders.OrderDate) = 1997 AND MONTH(Orders.OrderDate) = 6;


--5) Tulis query untuk mendapatkan jumlah OrderID yang pernah melakukan sales (unit_price dikali quantity) <=100, 100<x<=250, 250<x<=500, dan >500.

--SELECT SalesCategory.Sales, COUNT(SalesCategory.OrderID) AS TotalOrder
--	FROM(
--		SELECT SUM(Details.Sales) AS TotalSales, Orders.OrderID,
--		CASE WHEN SUM(Details.Sales) <= 100 THEN '<=100'
--			WHEN SUM(Details.Sales) > 100 AND SUM(Details.Sales) <=250 THEN '100<x<=250'
--			WHEN SUM(Details.Sales) > 250 AND SUM(Details.Sales) <=500 THEN '250<x<=500'
--			WHEN SUM(Details.Sales) > 500 THEN '>500'
--			END AS Sales
--		FROM Northwind.dbo.Orders AS Orders
--		LEFT JOIN (
--			SELECT OrderDetails.OrderID, OrderDetails.Quantity * OrderDetails.UnitPrice AS Sales
--			FROM Northwind.dbo.[Order Details] AS OrderDetails
--			) AS Details
--		ON Orders.OrderID = Details.OrderID
--		GROUP BY Orders.OrderID
--	)
--	AS SalesCategory
--	GROUP BY SalesCategory.Sales
--	ORDER BY TotalOrder;


--6) Tulis query untuk mendapatkan Company name yang melakukan sales di atas 500 pada tahun 1997.

--SELECT * FROM (
--	SELECT CustomersData.CompanyName, SUM(SalesData.Sales) AS TotalSales
--		FROM Northwind.dbo.Orders AS Orders
--		LEFT JOIN (
--			SELECT Customers.CustomerID, Customers.CompanyName
--			FROM Northwind.dbo.Customers AS Customers
--		) AS CustomersData
--		ON Orders.CustomerID = CustomersData.CustomerID
--		LEFT JOIN (
--			SELECT OrderDetails.OrderID, SUM(OrderDetails.Quantity*OrderDetails.UnitPrice) AS Sales
--			FROM Northwind.dbo.[Order Details] AS OrderDetails
--			GROUP BY OrderDetails.OrderID
--		) AS SalesData
--		ON Orders.OrderID = SalesData.OrderID
--		WHERE YEAR(Orders.OrderDate) = 1997
--		GROUP BY CustomersData.CompanyName
--) AS CompanySales
--WHERE CompanySales.TotalSales > 500
--ORDER BY CompanySales.TotalSales;


--7) Tulis query untuk mendapatkan nama produk yang merupakan Top 5 sales tertinggi tiap bulan di tahun 1997.

--SELECT DATENAME(MONTH, DATEADD(MONTH, OrderMonth, -1)) AS 'Month', ProductName, Sales FROM (
--	SELECT ROW_NUMBER()
--	OVER(PARTITION BY OrderMonth
--	ORDER BY Sales DESC) AS SalesRank, * FROM 
--	(
--		SELECT MONTH(Orders.OrderDate) AS OrderMonth, Product.ProductName, SUM(Details.Sales) AS Sales
--		FROM Northwind.dbo.Orders AS Orders
--		INNER JOIN
--		(
--			SELECT OrderDetails.OrderID, OrderDetails.ProductID, OrderDetails.Quantity*OrderDetails.UnitPrice AS Sales
--			FROM Northwind.dbo.[Order Details] AS OrderDetails
--		) AS Details
--		ON Orders.OrderID = Details.OrderID
--		INNER JOIN
--		(
--			SELECT ProductID, ProductName
--			FROM Northwind.dbo.Products AS Products
--		) AS Product
--		ON Details.ProductID = Product.ProductID
--		WHERE YEAR(Orders.OrderDate) = 1997
--		Group By Product.ProductName, MONTH(Orders.OrderDate)
--	) AS SalesPerMonth
--	) n
--	WHERE SalesRank <= 5;


--8) Buatlah view untuk melihat Order Details yang berisi OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Harga setelah diskon.

--SELECT OrderDetails.OrderID, OrderDetails.ProductID, Products.ProductName, 
--	OrderDetails.UnitPrice, OrderDetails.Quantity, OrderDetails.Discount, 
--	(OrderDetails.UnitPrice-(OrderDetails.UnitPrice*OrderDetails.Discount)) AS UnitPriceAfterDiscount
--	FROM Northwind.dbo.[Order Details] AS OrderDetails
--	LEFT JOIN (SELECT ProductID, ProductName FROM Northwind.dbo.Products) AS Products
--	ON OrderDetails.ProductID = Products.ProductID;


--9) Buatlah procedure Invoice untuk memanggil CustomerID, CustomerName, OrderID, OrderDate, RequiredDate, ShippedDate
--jika terdapat inputan CustomerID tertentu.

--DROP PROCEDURE IF EXISTS Invoice
--GO
--CREATE PROCEDURE Invoice
--(@CustomerIDTarget NCHAR(5))
--AS
--	SELECT Orders.CustomerID, Customers.CompanyName as CustomerName, Orders.OrderID, Orders.RequiredDate, Orders.ShippedDate
--	FROM Northwind.dbo.Orders AS Orders 
--	LEFT JOIN (
--		SELECT Customers.CustomerID, Customers.CompanyName FROM Northwind.dbo.Customers AS Customers
--	) AS Customers
--	ON Orders.CustomerID = Customers.CustomerID
--	WHERE Customers.CustomerID = @CustomerIDTarget
--	RETURN;
--GO
--EXEC Invoice 'ALFKI'
