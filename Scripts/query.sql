SELECT *
FROM employee
LIMIT 10;

-- 1st query
SELECT emp.firstName as E_firstname, 
  emp.lastName as E_lastname, 
  emp.title as Title,
  man.firstName as M_firstname, 
  man.lastName as M_lastname
FROM employee emp
INNER JOIN employee man
  ON emp.managerId = man.employeeId;

SELECT *
FROM sales
LIMIT 10;

-- 2nd query
  SELECT emp.firstName,
    emp.lastName,
    emp.title,
    s.salesId,
    s.salesAmount
  FROM employee emp
  LEFT JOIN sales s ON
    emp.employeeId = s.employeeId
  WHERE emp.title = 'Sales Person'
  AND s.salesId IS NULL;

SELECT sql
FROM sqlite_schema
WHERE name = 'sales';

--3rd QUERY
SELECT s.salesId,
  s.inventoryId,
  s.customerId, 
  s.employeeId,
  s.salesAmount,
  s.soldDate,
  c.customerId,
  c.firstName,
  c.lastName,
  c.address,
  c.city,
  c.zipcode,
  c.email
FROM sales s
FULL JOIN customer c
ON s.customerId = c.customerId;

--4th QUERY
SELECT e.employeeId,
  e.firstName,
  e.lastname,
  count(*) as NumOfCarsSold
FROM sales s
INNER JOIN employee e
  ON s.employeeId = e.employeeId
GROUP BY e.employeeId, e.firstName, e.lastName
ORDER BY NumOfCarsSold DESC;

--5th QUERY
SELECT  e.employeeId,
  e.firstName,
  e.lastName,
  MIN(s.salesAmount) as LeastExpensive,
  MAX(s.salesAmount) as MostExpensive
FROM sales s 
INNER JOIN employee e
  ON s.employeeId = e.employeeId
WHERE s.soldDate >= date('now', 'start of year')
GROUP BY e.employeeId, e.firstName, e.lastName 
ORDER BY e.employeeId ASC;

--6th QUERY
SELECT  e.employeeId,
  e.firstName,
  e.lastName,
  count(*) as NumCarsSold
FROM sales s 
INNER JOIN employee e
  ON s.employeeId = e.employeeId
WHERE s.soldDate >= date('now', 'start of year') --filters BEFORE aggregation
GROUP BY e.employeeId, e.firstName, e.lastName 
HAVING count(*) > 5; --filters AFTER aggregation

--7th query 
WITH cte AS (
SELECT strftime('%Y', soldDate) AS soldYear,
  salesAmount
FROM sales
)
SELECT soldYear,
  FORMAT("$%.2f", sum(salesAmount)) AS AnnualSales
FROM cte 
GROUP BY soldYear
ORDER BY soldYear;

--8th QUERY
SELECT *
FROM sales
LIMIT 10;

SELECT e.firstName,
  e.lastName,
  s.soldDate,
  s.salesAmount
FROM sales s 
INNER JOIN employee e 
  ON s.employeeId = e.employeeId
WHERE s.soldDate >= '2021-01-01'
AND s.soldDate <= '2022-01-01';

SELECT emp.firstName, emp.lastName,
  CASE WHEN strftime('%m', soldDate) = '01'
      THEN salesAmount END AS JanSales,
  CASE 
      WHEN strftime('%m', soldDate) = '02'
      THEN salesAmount END AS FebSales,
  CASE 
      WHEN strftime('%m', soldDate) = '03'
      THEN salesAmount END AS MarSales,
  CASE 
      WHEN strftime('%m', soldDate) = '04' 
      THEN salesAmount END AS AprSales,
  CASE 
      WHEN strftime('%m', soldDate) = '05' 
      THEN salesAmount END AS MaySales,
  CASE 
      WHEN strftime('%m', soldDate) = '06' 
      THEN salesAmount END AS JunSales,
  CASE 
      WHEN strftime('%m', soldDate) = '07' 
      THEN salesAmount END AS JulSales,
  CASE 
      WHEN strftime('%m', soldDate) = '08' 
      THEN salesAmount END AS AugSales,
  CASE 
      WHEN strftime('%m', soldDate) = '09' 
      THEN salesAmount END AS SepSales,
  CASE 
      WHEN strftime('%m', soldDate) = '10' 
      THEN salesAmount END AS OctSales,
  CASE 
      WHEN strftime('%m', soldDate) = '11' 
      THEN salesAmount END AS NovSales,
  CASE 
      WHEN strftime('%m', soldDate) = '12' 
      THEN salesAmount END AS DecSales
FROM sales sls
INNER JOIN employee emp
  ON sls.employeeId = emp.employeeId
WHERE sls.soldDate >= '2021-01-01'
  AND sls.soldDate < '2022-01-01'
ORDER BY emp.lastName, emp.firstName;

SELECT emp.firstName, emp.lastName,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '01' 
        THEN salesAmount END) AS JanSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '02' 
        THEN salesAmount END) AS FebSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '03' 
        THEN salesAmount END) AS MarSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '04' 
        THEN salesAmount END) AS AprSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '05' 
        THEN salesAmount END) AS MaySales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '06' 
        THEN salesAmount END) AS JunSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '07' 
        THEN salesAmount END) AS JulSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '08' 
        THEN salesAmount END) AS AugSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '09' 
        THEN salesAmount END) AS SepSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '10' 
        THEN salesAmount END) AS OctSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '11' 
        THEN salesAmount END) AS NovSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '12' 
        THEN salesAmount END) AS DecSales
FROM sales sls
INNER JOIN employee emp
  ON sls.employeeId = emp.employeeId
WHERE sls.soldDate >= '2021-01-01'
  AND sls.soldDate < '2022-01-01'
GROUP BY emp.firstName, emp.lastName
ORDER BY emp.lastName, emp.firstName;

-- 9th QUERY
SELECT *
FROM model
LIMIT 10;

SELECT s.salesId,
  s.inventoryId,
  m.EngineType
FROM sales s
INNER JOIN inventory i 
ON s.inventoryId = i.inventoryId
INNER JOIN model m 
ON m.modelId = i.modelId
WHERE m.EngineType = 'Electric';

--with subquery (and selecting different fields, but same total rows)
SELECT sls.soldDate, sls.salesAmount, inv.colour, inv.year
FROM sales sls
INNER JOIN inventory inv
  ON sls.inventoryId = inv.inventoryId
WHERE inv.modelId IN (
  SELECT modelId
  FROM model
  WHERE EngineType = 'Electric'
);

--10th QUERY
SELECT e.firstName,
  e.lastName,
  m.model,
  count(model) as NumModelsSold,
  rank() OVER (PARTITION BY s.employeeId
              ORDER BY count(model) DESC) AS Rank
FROM sales s 
INNER JOIN employee e  
ON e.employeeId = s.employeeId
INNER JOIN inventory i
ON i.inventoryId = s.inventoryId
INNER JOIN model m 
on m.modelId = i.modelId
GROUP BY e.firstName, e.lastName, m.model;

--11th query (from answer)
-- get the needed data
SELECT strftime('%Y', soldDate) AS soldYear, 
  strftime('%m', soldDate) AS soldMonth, 
  salesAmount
FROM sales

-- apply the grouping
SELECT strftime('%Y', soldDate) AS soldYear, 
  strftime('%m', soldDate) AS soldMonth,
  SUM(salesAmount) AS salesAmount
FROM sales
GROUP BY soldYear, soldMonth
ORDER BY soldYear, soldMonth

-- add the window function - simplify with cte
with cte_sales as (
SELECT strftime('%Y', soldDate) AS soldYear, 
  strftime('%m', soldDate) AS soldMonth,
  SUM(salesAmount) AS salesAmount
FROM sales
GROUP BY soldYear, soldMonth
)
SELECT soldYear, soldMonth, salesAmount,
  SUM(salesAmount) OVER (
    PARTITION BY soldYear 
    ORDER BY soldYear, soldMonth) AS AnnualSales_RunningTotal
FROM cte_sales
ORDER BY soldYear, soldMonth;

--12th query (from the answer)
-- Get the data
SELECT strftime('%Y-%m', soldDate) AS MonthSold,
  COUNT(*) AS NumberCarsSold
FROM sales
GROUP BY strftime('%Y-%m', soldDate)

-- Apply the window function
SELECT strftime('%Y-%m', soldDate) AS MonthSold,
  COUNT(*) AS NumberCarsSold,
  LAG (COUNT(*), 1, 0 ) OVER calMonth AS LastMonthCarsSold
FROM sales
GROUP BY strftime('%Y-%m', soldDate)
WINDOW calMonth AS (ORDER BY strftime('%Y-%m', soldDate))
ORDER BY strftime('%Y-%m', soldDate);
