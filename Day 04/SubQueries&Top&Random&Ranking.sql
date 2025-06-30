---------------------------------------------------------------------
------------------------- Use ITI DB ---------------------------------
--===================================================================
use ITI;
-- 1.	Display instructors who have salaries less than the average salary of all instructors.
SELECT *
FROM Instructor
WHERE Salary < (SELECT AVG(Salary) FROM Instructor) AND Salary IS NOT NULL

-- 2.	Display the Department name that contains the instructor who receives the minimum salary
SELECT D.Dept_Name
FROM Department D join (SELECT TOP(1)*
						FROM Instructor
						WHERE Salary IS NOT NULL
						ORDER BY Salary) [InstructorMinSalary]
On D.Dept_Id = InstructorMinSalary.Dept_Id

-- 3.	Select max two salaries in instructor table.
SELECT TOP(2)Salary
FROM Instructor
ORDER BY Salary DESC

---------------------------------------------------------------------
------------------------- Use MyCompany DB ---------------------------------
--===================================================================
use MyCompany;

-- 4.	Display the data of the department which has the smallest employee ID over all employees' ID.
SELECT D.*
FROM Departments D, (SELECT TOP(1)* FROM Employee WHERE Dno IS NOT NULL ORDER BY SSN ) [SmallestEmployeeID]
WHERE D.Dnum = SmallestEmployeeID.Dno 

-- 5.	List the last name of all managers who have no dependents
SELECT DISTINCT M.Lname
FROM Employee E JOIN Employee M
ON E.Superssn = M.SSN 
WHERE M.Dno IS NULL

-- 6.	For each department
	-- if its average salary is less than the average salary of all employees displays its number, 
	-- name and number of its employees.



SELECT D.Dname, D.Dnum, LessEmployeesSalary.SSN
FROM Departments D , (SELECT *
						FROM Employee
						WHERE Salary < (SELECT AVG(Salary) FROM Employee)) [LessEmployeesSalary]
WHERE D.Dnum = LessEmployeesSalary.Dno

-- 7.	Try to get the max 2 salaries using subquery.
SELECT DISTINCT Salary
FROM Employee
WHERE Salary >= (SELECT MAX(Salary)
				FROM Employee
				WHERE Salary < (SELECT MAX(Salary) FROM Employee)
				)
ORDER BY Salary DESC;

-- 8.	Display the employee number and name if he/she has at least one dependent (use exists keyword) self-study.
SELECT E.SSN, E.Fname
FROM Employee E  
WHERE EXISTS( SELECT * FROM Dependent D WHERE E.SSN = D.ESSN  )

-- ============================ USE ITI ============================
USE ITI;
-- 9.	Write a query to select the highest two salaries in Each Department for instructors who have salaries.
		--“Using one of Ranking Functions”
SELECT *
FROM (SELECT Salary, ROW_NUMBER() OVER (PARTITION BY D.Dept_Id  ORDER BY Salary DESC) [ROW_NUMBER]
		FROM Instructor Ins JOIN Department D
		ON D.Dept_Id = Ins.Dept_Id
		WHERE Salary IS NOT NULL ) [OrderSalary]
WHERE ROW_NUMBER  IN (1,2)

-- 10.	 Write a query to select a random student from each department.  “Using one of Ranking Functions”
SELECT *
FROM (SELECT * , ROW_NUMBER() OVER(PARTITION BY S.Dept_Id ORDER BY NEWID()) [ROW_NUMBER]
					FROM Student S
					WHERE S.Dept_Id IS NOT NULL) [Ranking]
WHERE ROW_NUMBER = 1

---------------------------------------------------------------------
-------------------------  adventureworks2012 Database  ---------------------------------
--===================================================================
use AdventureWorks2012;

-- 1.	Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders
--		 that occurred within the period ‘7/28/2002’ and ‘7/29/2014’

SELECT DISTINCT SO.SalesOrderID, SH.ShipDate
FROM Sales.SalesOrderDetail SO JOIN Sales.SalesOrderHeader SH 
ON SO.SalesOrderID = SH.SalesOrderID
WHERE SH.ShipDate BETWEEN '2002-07-28' AND '2014-07-29';

-- 2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
SELECT P.ProductID, P.Name
FROM Production.Product P
WHERE P.StandardCost < 110.00

-- 3.	Display ProductID, Name if its weight is unknown
SELECT P.ProductID, P.Name
FROM Production.Product P
WHERE P.Weight IS NULL

-- 4.	 Display all Products with a Silver, Black, or Red Color
SELECT *
FROM Production.Product P
WHERE P.Color IN ('Silver','Black', 'Red' )

-- 5.	 Display any Product with a Name starting with the letter B
SELECT P.Name
FROM Production.Product P
WHERE P.Name LIKE 'B%'

-- 6.	Run the following Query
-- 7.	UPDATE Production.ProductDescription
--		SET Description = 'Chromoly steel_High of defects'
--		WHERE ProductDescriptionID = 3

-- Then write a query that displays any Product description with underscore value in its description.

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3


SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%[_]%';

-- 8. Display the Employees HireDate (note no repeated values are allowed)
SELECT DISTINCT HE.HireDate
FROM HumanResources.Employee HE

--	9. Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following format
--		"The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)

SELECT	CONCAT('The ', P.Name , ' is only! ', P.ListPrice) [ListPrice]
FROM Production.Product P
WHERE P.ListPrice BETWEEN 100 AND 120
ORDER BY P.ListPrice
