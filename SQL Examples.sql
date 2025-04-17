--1. List the customers from California who bought red mountain bikes in September 2003. 
--Use order date as date bought. Multi-color bikes with red are considered red bikes.

--CustomerID	LastName	FirstName	ModelType	ColorList	OrderDate	SaleState

--select all columns that need listed
SELECT  
    C.CustomerID, 
    C.LastName, 
    C.FirstName, 
    B.ModelType, 
    P.ColorList, 
    B.OrderDate, 
    B.SaleState
FROM
    Customer AS C --main table for query
JOIN
    Bicycle AS B ON C.CustomerID = B.CustomerID --link Bicycle to Customer
JOIN
    PAINT AS P ON B.PaintID = P.PaintID --link Paint to Bicycle
JOIN
    ModelType AS M ON B.ModelType = M.ModelType --link ModelType to Bicycle
WHERE
    B.SaleState = 'California' --find California
    AND P.ColorList LIKE '%red%' --find colors that are red or multicolored
    AND M.Description = 'Mountain Bike' --find mountain bike
    AND YEAR(B.OrderDate) = 2003 --find year
    AND MONTH(B.OrderDate) = 9; --find month


--2. List the employees who sold race bikes shipped to Wisconsin without the help of a retail store in 2001, 
--Without help of retail store means rders completed without the help of a retail store are walk-in or direct sales.
--EmployeeID	LastName	SaleState	ModelType	StoreID	OrderDate

SELECT  --select all columns that need listed
    E.EmployeeID,
    E.LastName,
    B.SaleState,
    B.ModelType,
    B.StoreID,
    B.OrderDate
FROM 
    Employee AS E --main table for query
JOIN 
    Bicycle AS B ON E.EmployeeID = B.EmployeeID -- link Bicycle to Employee
WHERE 
    B.SaleState = 'Wisconsin' --find Wisconsin
    AND B.ModelType = 'Race Bike' -find race bikes
    AND YEAR(B.OrderDate) = 2001 --find orders in 2001
    AND (B.StoreID IS NULL OR B.StoreID = ''); --find sale where no retail store was used
 
--3. List all of the (distinct) rear derailleurs installed on road bikes sold in Florida in 2002.
--ComponentID	ManufacturerName	ProductNumber

SELECT DISTINCT --select all columns that need listed and unique values
    CP.ComponentID, 
    M.ManufacturerName, 
    CP.ProductNumber 
FROM
    BikeParts AS BP -- main table for query
JOIN
    Component AS CP ON BP.ComponentID = CP.ComponentID -- link BikeParts to Component
JOIN
    Bicycle AS B ON BP.SerialNumber = B.SerialNumber -- link BikeParts to Bicycle
JOIN
    Manufacturer AS M ON CP.ManufacturerID = M.ManufacturerID -- link Component to Manufacturer
WHERE
    CP.Category = 'Rear Derailleur' -- find rear derailleurs
    AND B.SaleState = 'Florida' -- find bikes sold in Florida
    AND YEAR(B.OrderDate) = 2002; -- find bikes sold in the year 2002

 
--4. Who bought the largest (frame size) full suspension mountain bike sold in Georgia in 2004?
--CustomerID	LastName	FirstName	ModelType	SaleState	FrameSize	OrderDate

SELECT TOP 1 --select all columns that need listed and only the largest 
    C.CustomerID,
    C.LastName,
    C.FirstName,
    B.ModelType,
    B.SaleState, 
    B.FrameSize, 
    B.OrderDate
FROM 
    Customer AS C -- main table for query
JOIN 
    Bicycle AS B ON C.CustomerID = B.CustomerID -- link Customer to Bicycle
WHERE 
    B.ModelType = 'Full Suspension Mountain Bike' -- find full suspension mountain bikes, assuming full suspension is part of the ModelType
    AND B.SaleState = 'Georgia' -- find bikes sold in Georgia
    AND YEAR(B.OrderDate) = 2004 -- find bikes sold in the year 2004
ORDER BY 
    B.FrameSize DESC; -- Order by frame size in descending order to get the largest

 
--5. Which manufacturer gave us the largest discount on an order in 2003?
--ManufacturerID	ManufacturerName


SELECT TOP 1 --select all columns that need listed and only the largest 
    M.ManufacturerID, 
    M.ManufacturerName 
FROM 
    Manufacturer AS M -- main table for query
JOIN 
    PurchaseOrder AS PO ON M.ManufacturerID = PO.ManufacturerID -- link Manufacturer to PurchaseOrder
WHERE 
    YEAR(PO.OrderDate) = 2003 -- find orders in 2003
ORDER BY 
    PO.Discount DESC; -- Order by discount in descending order to get the largest

--24. Which component that had no sales (installations) in 2004 has the highest inventory value (cost basis)?
--ManufacturerName	ProductNumber	Category	Value	ComponentID

SELECT TOP 1 --select all columns that need listed and only the highest value
    M.ManufacturerName, 
    CP.ProductNumber,
    CP.Category, 
    CP.ListPrice AS Value, -- no value attribute so ListPrice represents value as the cost basis
    CP.ComponentID 
FROM 
    Manufacturer AS M -- main table for query
JOIN 
    Component AS CP ON M.ManufacturerID = CP.ManufacturerID -- link Manufacturer to Component
LEFT JOIN 
    BikeParts AS BP ON CP.ComponentID = BP.ComponentID -- left join with BikeParts to check for installations. left join is used to ensure all components are found even if there are no installations
WHERE 
    (YEAR(BP.Datelnstalled) IS NULL OR YEAR(BP.Datelnstalled) <> 2004) -- filter for components with no installations or installations not in 2004
ORDER BY 
    CP.ListPrice DESC; -- Order by ListPrice in descending order to get the highest

 
--25. Create a vendor contacts list of all manufacturers and retail stores in California.
--Include only the columns for VendorName and Phone. 
--The retail stores should only include stores that participated in the sale of at least one bicycle in 2004
--Store Name Or Manufacturer Name	Phone

SELECT --select all columns that need listed 
    COALESCE(M.ManufacturerName, R.StoreName) AS VendorName, --use COALESCE to find non-null expressions and use multiple arguments
    COALESCE(M.Phone, R.Phone) AS Phone
FROM
    Manufacturer AS M -- main table for query
FULL JOIN
    RetailStore AS R ON M.ManufacturerID = R.ManufacturerID -- full join to include both manufacturers and retail stores
LEFT JOIN
    Bicycle AS B ON R.StoreID = B.StoreID --left join to check if a retail store participated in the sale of at least one bicycle in 2004
WHERE
    (M.ManufacturerID IS NOT NULL OR B.SaleState = 'California' AND YEAR(B.OrderDate) = 2004); --include only california and 2004

 
--26. List all of the employees who report to Venetiaan.
--LastName	EmployeeID	LastName	FirstName	Title


SELECT  --select all columns that need listed 
    E.LastName,
    E.EmployeeID,
    E.FirstName,
    E.Title
FROM
    Employee AS M -- assuming Venetiaan is a manager
JOIN
    Employee AS E ON M.EmployeeID = E.CurrentManager --self join because there is no manager table but a CurrentManager attribute
WHERE
    M.LastName = 'Venetiaan'; --check for last name that matches

 
--27. List the components where the company purchased at least 25 percent more units than it used through June 30, 2000.
--ComponentID	ManufacturerName	ProductNumber	Category	TotalReceived	TotalUsed	NetGain	NetPct	ListPrice

SELECT --select all columns that need listed 
    CP.ComponentID,
    M.ManufacturerName,
    CP.ProductNumber,
    CP.Category,
    PO.TotalList AS TotalReceived,
    SUM(BP.Quantity) AS TotalUsed,
    (PO.TotalList - SUM(BP.Quantity)) AS NetGain, --represents the net difference between TotalRecieved and TotalUsed
    (CASE WHEN SUM(BP.Quantity) > 0 THEN (PO.TotalList - SUM(BP.Quantity)) / SUM(BP.Quantity) * 100 ELSE 0 END) AS NetPct, --represents percentage increase between TotalRecieved and TotalUsed
    --CASE is used to prevent division by 0
    CP.ListPrice
FROM
    Component AS CP -main table for query
JOIN
    Manufacturer AS M ON CP.ManufacturerID = M.ManufacturerID -- link manufacturer to component
JOIN
    PurchaseOrder AS PO ON CP.ManufacturerID = PO.ManufacturerID --link purchase order to manufactuerer
LEFT JOIN
    BikeParts AS BP ON CP.ComponentID = BP.ComponentID --left join to find components used in bike parts. unused parts will be NULL in bike parts
WHERE
    (PO.TotalList >= SUM(BP.Quantity) * 1.25) -- At least 25% more units purchased than used
    AND PO.OrderDate <= '2000-06-30' -- Purchases until June 30, 2000
GROUP BY
    CP.ComponentID, M.ManufacturerName, CP.ProductNumber, CP.Category, PO.TotalList, CP.ListPrice; --not neccessary but provides better sorting when viewing the results


 
--28. In which years did the average build time for the year exceed the overall average build time for all years? 
--The build time is the difference between order date and ship date.
--Use the difference between OrderDate and ShipDate.
--Year	BuildTime

SELECT --select all columns that need listed 
    YEAR(B.OrderDate) AS Year, --use YEAR() to only grab the year and not month or day
    AVG(DATEDIFF(B.ShipDate, B.OrderDate)) AS BuildTime --calculates the difference between 2 dates then the average
FROM
    Bicycle AS B --main table for query
GROUP BY
    YEAR(B.OrderDate) --groups by OrderDate so the average build time is calculated seperately for each year
HAVING --filters results to only include where the build time for that year is greater than the average build for all years
    AVG(DATEDIFF(B.ShipDate, B.OrderDate)) > (
        SELECT AVG(DATEDIFF(ShipDate, OrderDate))
        FROM Bicycle);
