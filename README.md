## 🛠️ Bike Shop Relational Database (Microsoft Access & SQL)

This SQL project demonstrates the ability to build and query a normalized relational database for a fictional bike shop. It includes practical business scenarios and showcases advanced querying techniques.

### 🗃️ Features

- Normalized table design for core business entities: Customers, Bicycles, Paint, Models, Manufacturers, Orders, and Employees.
- Advanced SQL queries featuring:
  - Multi-table joins
  - Date and string filtering
  - Aggregation and ordering
  - Subqueries and distinct filtering

### 🧠 Example Use Cases

1. **Customer Reports**: List customers from California who bought red mountain bikes in Sept 2003.
2. **Sales Tracking**: Find employees who sold race bikes directly in Wisconsin in 2001.
3. **Component Inventory**: Display unique rear derailleurs used in Florida road bikes sold in 2002.
4. **Largest Frame Sold**: Determine the buyer of the largest full suspension mountain bike in Georgia (2004).
5. **Discount Analysis**: Identify the manufacturer that gave the highest order discount in 2003.

### 📄 Technologies

- Microsoft Access
- SQL Server
- Relational Schema Design
- ERD principles

### Relational Database
This ERD visualizes the relational schema of the Bike Shop database.
- Key relationships demonstrate:
  - **Customer orders and transactions** tied to employees and bicycles
  - **Bicycles** composed of various parts, sizes, and paint options
  - **Component tracking** through purchase orders, inventory, and usage
  - **Manufactuer** and **Store Locations** mapped by city and state
  - Full normalization to reduce redundancy and enforce data integrity
![Relational Database](Bike_ERD.png)

### SQL Snippet Overview
```sql
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

