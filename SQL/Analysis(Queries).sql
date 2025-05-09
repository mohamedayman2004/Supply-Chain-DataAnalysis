-- 1. متوسط مدة توريد الموردين وإجمالي الإيرادات
SELECT 
    s.Supplier_name,
    AVG(s.Supplier_LeadTime) AS Avg_LeadTime,
    SUM(o.Revenue_generated) AS Total_Revenue
FROM Suppliers s
JOIN Orders o ON s.SupplierID = o.SupplierID
GROUP BY s.Supplier_name
ORDER BY Total_Revenue DESC;

-- 2. أعلى 5 منتجات مبيعًا
SELECT TOP 5
    p.Product_type,
    p.SKU,
    SUM(o.Number_of_products_sold) AS Total_Sold
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Product_type, p.SKU
ORDER BY Total_Sold DESC;

-- 3. تكلفة الشحن الإجمالية لكل شركة شحن
SELECT 
    sh.Shipping_carriers,
    SUM(sh.Shipping_costs) AS Total_Shipping_Costs,
    SUM(sh.TransportationCost) AS Total_Transportation_Costs
FROM Shipping sh
GROUP BY sh.Shipping_carriers
ORDER BY Total_Shipping_Costs DESC;

-- 4. متوسط وقت الشحن حسب وسيلة النقل
SELECT 
    sh.Transportation_modes,
    AVG(sh.Shipping_times) AS Avg_Shipping_Time
FROM Shipping sh
GROUP BY sh.Transportation_modes;

-- 5. نسبة العيوب حسب نوع المنتج
SELECT 
    p.Product_type,
    AVG(p.Defect_rates) AS Avg_Defect_Rate,
    COUNT(i.InspectionID) AS Inspection_Count
FROM Products p
LEFT JOIN Inspections i ON p.ProductID = i.ProductID
GROUP BY p.Product_type
ORDER BY Avg_Defect_Rate DESC;

-- 6. إجمالي الكميات المطلوبة حسب المورد
SELECT 
    s.Supplier_name,
    SUM(o.Order_quantities) AS Total_Order_Quantities
FROM Suppliers s
JOIN Orders o ON s.SupplierID = o.SupplierID
GROUP BY s.Supplier_name
ORDER BY Total_Order_Quantities DESC;

-- 7. متوسط مدة معالجة الطلبات
SELECT 
    AVG(o.OrderProcessingLeadTime) AS Avg_Processing_LeadTime
FROM Orders o;

-- 8. عدد الطلبات لكل نوع منتج 
SELECT 
    p.Product_type,
    COUNT(o.OrderID) AS Order_Count
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Product_type
ORDER BY Order_Count DESC;

-- 9. متوسط سعر المنتج حسب النوع 
SELECT 
    p.Product_type,
    AVG(p.Price) AS Avg_Product_Price
FROM Products p
GROUP BY p.Product_type
ORDER BY Avg_Product_Price DESC;

-- 10.إجمالي تكلفة التصنيع لكل مورد
SELECT 
    s.Supplier_name,
    SUM(p.Manufacturing_costs) AS Total_Manufacturing_Costs
FROM Suppliers s
JOIN Orders o ON s.SupplierID = o.SupplierID
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY s.Supplier_name
ORDER BY Total_Manufacturing_Costs DESC;

-- 11. متوسط تكلفة الشحن حسب المسار 
SELECT 
    sh.Routes,
    AVG(sh.Shipping_costs + sh.TransportationCost) AS Avg_Total_Shipping_Cost
FROM Shipping sh
GROUP BY sh.Routes
ORDER BY Avg_Total_Shipping_Cost DESC;