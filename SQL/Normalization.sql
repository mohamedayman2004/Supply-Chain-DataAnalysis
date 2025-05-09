
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    Supplier_name NVARCHAR(100),
    Location NVARCHAR(100),
    Supplier_LeadTime TINYINT NULL
);

INSERT INTO Suppliers (Supplier_name, Location, Supplier_LeadTime)
SELECT DISTINCT Supplier_name, Location, SupplierLeadTime
FROM dbo.supply_chain_data;

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    SKU NVARCHAR(50),
    Product_type NVARCHAR(50),
    Price FLOAT NULL,
    Availability TINYINT NULL,
    Stock_levels TINYINT NULL,
    Manufacturing_costs FLOAT NULL,
    Defect_rates FLOAT NULL,
    Manufacturing_Lead_time TINYINT NULL
);

INSERT INTO Products (SKU, Product_type, Price, Availability, Stock_levels, Manufacturing_costs, Defect_rates, Manufacturing_Lead_time)
SELECT SKU, Product_type, Price, Availability, Stock_levels, Manufacturing_costs, Defect_rates, Manufacturing_Lead_time
FROM dbo.supply_chain_data;

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    SupplierID INT,
    Order_quantities TINYINT NULL,
    Number_of_products_sold SMALLINT NULL,
    Revenue_generated FLOAT NULL,
    OrderProcessingLeadTime TINYINT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);


INSERT INTO Orders (ProductID, SupplierID, Order_quantities, Number_of_products_sold, Revenue_generated, OrderProcessingLeadTime)
SELECT 
    p.ProductID,
    s.SupplierID,
    sc.Order_quantities,
    sc.Number_of_products_sold,
    sc.Revenue_generated,
    sc.OrderProcessingLeadTime
FROM dbo.supply_chain_data sc
JOIN Products p ON sc.SKU = p.SKU
JOIN Suppliers s ON sc.Supplier_name = s.Supplier_name AND sc.Location = s.Location;

CREATE TABLE Shipping (
    ShippingID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    Shipping_carriers NVARCHAR(50),
    Shipping_times TINYINT NULL,
    Shipping_costs FLOAT NULL,
    Transportation_modes NVARCHAR(50),
    Routes NVARCHAR(50),
    TransportationCost FLOAT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);


INSERT INTO Shipping (OrderID, Shipping_carriers, Shipping_times, Shipping_costs, Transportation_modes, Routes, TransportationCost)
SELECT 
    o.OrderID,
    sc.Shipping_carriers,
    sc.Shipping_times,
    sc.Shipping_costs,
    sc.Transportation_modes,
    sc.Routes,
    sc.TransportationCost
FROM dbo.supply_chain_data sc
JOIN Products p ON sc.SKU = p.SKU
JOIN Orders o ON o.ProductID = p.ProductID;

CREATE TABLE Inspections (
    InspectionID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    Inspection_results NVARCHAR(50),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


INSERT INTO Inspections (ProductID, Inspection_results)
SELECT 
    p.ProductID,
    sc.Inspection_results
FROM dbo.supply_chain_data sc
JOIN Products p ON sc.SKU = p.SKU;

SELECT 
    s.Supplier_name,
    s.Location,
    s.Supplier_LeadTime,
    p.Product_type,
    p.Price,
    o.Order_quantities,
    o.Revenue_generated,
    o.OrderProcessingLeadTime,
    sh.Shipping_carriers,
    sh.Shipping_costs,
    sh.TransportationCost
FROM Orders o
JOIN Suppliers s ON o.SupplierID = s.SupplierID
JOIN Products p ON o.ProductID = p.ProductID
JOIN Shipping sh ON o.OrderID = sh.OrderID;