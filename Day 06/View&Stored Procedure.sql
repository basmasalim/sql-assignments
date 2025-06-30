--===========================================================================
---------------------------- Part 01 (Views) --------------------------------
--===========================================================================
-- Use ITI DB:
--------------------------------------------------------------------------------------------------------------------------------------
-- 1.	 Create a view that displays the student's full name, course name if the student has a grade more than 50. 
--------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW VStudentsCourses
AS
	SELECT CONCAT(S.St_Fname,' ', S.St_Lname) [Full Name], Crs.Crs_Name [Course Name]
	FROM Student S, Stud_Course StdCrs, Course Crs
	WHERE StdCrs.Grade > 50 AND S.St_Id = StdCrs.St_Id AND StdCrs.Crs_Id = Crs.Crs_Id
GO
SELECT * FROM VStudentsCourses
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 2.	 Create an Encrypted view that displays manager names and the topics they teach. 
--------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW VMangaersTopices
WITH ENCRYPTION
AS
	SELECT DISTINCT Ins.Ins_Name [Manager Name], T.Top_Name [Topic Name]
	FROM Instructor Ins, Ins_Course InsCrs, Course Crs, Topic T
	WHERE Ins.Ins_Id = InsCrs.Ins_Id AND InsCrs.Crs_Id = Crs.Crs_Id AND Crs.Top_Id = T.Top_Id

GO
SELECT * FROM VMangaersTopices
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding
--------------------------------------------------------------------------------------------------------------------------------------
-- Schema Binding ==>  the tables and columns it depends on cannot be changed without first dropping or altering the view/function.

CREATE VIEW dbo.VInstructorsDepartment
WITH SCHEMABINDING
AS 
	SELECT Ins.Ins_Name, D.Dept_Name
	FROM dbo.Instructor AS Ins, dbo.Department AS D
	WHERE Ins.Dept_Id = D.Dept_Id AND (D.Dept_Name = 'Java' OR D.Dept_Name = 'SD');

GO
SELECT * FROM VInstructorsDepartment
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 4.	 Create a view “V1” that displays student data for students who live in Alex or Cairo. 
--------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW VCairoAlexStudents
AS
	SELECT *
	FROM Student
	WHERE St_Address IN ('Cairo', 'Alex') WITH CHECK OPTION

GO
SELECT * FROM VCairoAlexStudent

Update VCairoAlexStudents set St_Address ='Tanta'
Where St_Address ='Alex';
GO
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- Use Company DB:
--------------------------------------------------------------------------------------------------------------------------------------
-- 0.	Create a view that will display the project name and the number of employees working on it.
--------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW VProjectsWithNumberOfEmployees
AS
	SELECT P.Pname, COUNT(E.SSN) [Number Of Employees]
	FROM Project P, Employee E, Departments D
	WHERE E.Superssn = D.MGRSSN AND D.Dnum = P.Dnum
	GROUP BY P.Pname
GO
SELECT * FROM VProjectsWithNumberOfEmployees
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- use IKEA_Company_DB:
--------------------------------------------------------------------------------------------------------------------------------------
-- 1.	Create a view named “v_clerk” that will display employee Number, project Number, the date of hiring of all the jobs of the type 'Clerk'.
--------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW v_clerk 
AS
	SELECT W.EmpNo [Employee Number], W.ProjectNo [Project Number], W.Enter_Date
	FROM Works_on W
	WHERE W.Job = 'Clerk'

GO
SELECT * FROM v_clerk
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 2.	 Create view named  “v_without_budget” that will display all the projects data without budget
--------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW v_without_budget
AS
	SELECT P.ProjectName, P.ProjectNo
	FROM HR.Project P

GO
SELECT * FROM v_without_budget
GO	
--------------------------------------------------------------------------------------------------------------------------------------
-- 3.	Create view named  “v_count “ that will display the project name and the Number of jobs in it
--------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW v_count
AS
	SELECT P.ProjectName [Project Name], COUNT(W.Job) [The Number of jobs]
	FROM HR.Project P, Works_on W
	WHERE P.ProjectNo = W.ProjectNo
	GROUP BY P.ProjectName

GO
SELECT * FROM v_count
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 4. Create a view named” v_project_p2” that will display the emp# s for the project# ‘p2’. (use the previously created view  “v_clerk”)
--------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW v_project_p2
AS
	SELECT V.[Employee Number]
	FROM v_clerk V
	WHERE V.[Project Number] = 2

GO
SELECT * FROM v_project_p2
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 5.	modify the view named “v_without_budget” to display all DATA in project p1 and p2.
--------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW v_without_budget
AS
	SELECT P.ProjectName, P.ProjectNo
	FROM HR.Project P
	WHERE P.ProjectNo IN (1, 2)

GO
SELECT * FROM v_without_budget
GO	

--------------------------------------------------------------------------------------------------------------------------------------
-- 6.	Delete the views  “v_ clerk” and “v_count”
--------------------------------------------------------------------------------------------------------------------------------------
DROP VIEW v_clerk
DROP VIEW v_count

GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 7.	Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
--------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW VEmployeesWorksOnDept
AS
	SELECT E.EmpNo [Employee Number], E.EmpLname [Employee Last Name], E.DeptNo [Depatment Number]
	FROM HR.Employee E
	WHERE E.DeptNo =  2

GO
SELECT * FROM VEmployeesWorksOnDept
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 8.	Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)
--------------------------------------------------------------------------------------------------------------------------------------
SELECT V.[Employee Last Name]
FROM VEmployeesWorksOnDept V
WHERE V.[Employee Last Name] like '%J%'

GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 9.	Create view named “v_dept” that will display the department# and department name
--------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW v_dept
AS
	SELECT D.DeptNo [Department Number], D.DeptName [Department Name]
	FROM Department D
	 
GO
SELECT * FROM v_dept
GO

--------------------------------------------------------------------------------------------------------------------------------------
-- 10.	using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
--------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO v_dept
VALUES(4,'Development')

GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 11.	Create view name “v_2006_check” that will display employee Number, 
--	the project Number where he works and the date of joining the project which must be from the first of January and
--	the last of December 2006.this view will be used to insert data so make sure that the coming new data must match the condition
--------------------------------------------------------------------------------------------------------------------------------------
CREATE VIEW v_2006_check
AS
	SELECT E.EmpNo [Employee Number], P.ProjectNo [Project Number], W.Enter_Date [Date]
	FROM HR.Employee E, HR.Project P, Works_on W
	WHERE W.EmpNo = E.EmpNo AND W.ProjectNo = P.ProjectNo
	AND W.Enter_Date  BETWEEN '2006-01-01' AND '2006-12-31'

GO
SELECT * FROM v_2006_check
GO

--===========================================================================
---------------------------- Part 02 ----------------------------------------
--===========================================================================
-- Use ITI DB:
--------------------------------------------------------------------------------------------------------------------------------------
-- 1. Create a stored procedure to show the number of students per department.
--------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC SPStudentsPerDepartment
With Encryption
AS
	SELECT COUNT(S.St_Id) [Number Of Student], D.Dept_Name [Department Name]
	FROM Student S, Department D
	WHERE S.Dept_Id = D.Dept_Id
	Group By D.Dept_Name

GO
SPStudentsPerDepartment
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- Use MyCompany DB:
--------------------------------------------------------------------------------------------------------------------------------------
-- 2. Create a stored procedure that will check for the Number of employees in the project 100 
--	if they are more than 3 print message to the user “'The number of employees in the project 100 is 3 or more'”
--	if they are less display a message to the user “'The following employees work for the project 100'” in addition to the first name and last name of each one
--------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC SPCheckEmployeesInProject
WITH ENCRYPTION
AS
	DECLARE @EmployeeCount int

	SELECT @EmployeeCount = COUNT(*) 
	FROM Works_for W
	WHERE W.Pno = 100

	IF (@EmployeeCount >= 3)
		PRINT 'The number of employees in the project 100 is 3 or more'
	ELSE
		PRINT 'The following employees work for the project 100'

		SELECT CONCAT (E.Fname,' ', E.Lname) 'Full Name'
		FROM Employee E, Works_for W
		WHERE E.SSN = W.ESSn AND W.Pno = 100

GO
SPCheckEmployeesInProject
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 3. Create a stored procedure that will be used in case an old employee has left the project and a new one becomes his replacement. 
--		The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and
--		it will be used to update works_on table. 
--------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC SPReplaceEmployeeInProject
@OldEmployeeNo INT,
@NewEmployeeNo INT,
@ProjectNo INT

WITH ENCRYPTION
AS
BEGIN
	UPDATE Works_for
	SET ESSn = @NewEmployeeNo
	WHERE ESSn = @OldEmployeeNo AND Pno = @ProjectNo
END

GO
SPReplaceEmployeeInProject 112233, 669955, 100
GO
--===========================================================================
---------------------------- Part 03 ----------------------------------------
--===========================================================================
-- 1. Create a stored procedure that calculates the sum of a given range of numbers
--------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC SPGetSumInRange
@StartNum INT,
@EndNum INT
AS
BEGIN
	DECLARE @Sum INT;
	SET @Sum = 0
	WHILE @EndNum >= @StartNum 
		BEGIN
			SET @Sum += @StartNum
			SET @StartNum = @StartNum + 1
		END

	SELECT @Sum 'TotalSum'
END

GO
EXEC SPGetSumInRange @StartNum = 10 , @EndNum = 20
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 2. Create a stored procedure that calculates the area of a circle given its radius
--------------------------------------------------------------------------------------------------------------------------------------
CREATE PROC SPGetCalcAreaOfCircle
@Radius DECIMAL(10,2)
AS
BEGIN
	 DECLARE @Pi DECIMAL(10,2);
	 DECLARE @Area DECIMAL(10,2);

	 SET @Pi = 3.14159;
	 SET @Area = @Radius * @Radius * @Pi

	SELECT	@Area [CircleArea]
END

GO
SPGetCalcAreaOfCircle 5.5
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 3. Create a stored procedure that calculates the age category based on a person's age 
--	( Note: IF Age < 18 then Category is Child and
--			if  Age >= 18 AND Age < 60 then Category is Adult otherwise  Category is Senior)
--------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC SPGetAgeCategory
@Age INT
AS
BEGIN
	DECLARE @Category VARCHAR(20)
	IF (@Age < 18)
		SET @Category = 'Child'

	ELSE IF (@Age >= 18 AND @Age < 60)
		SET @Category = 'Adult'

	ELSE 
		SET @Category = 'Senior'

		SELECT @Category [Category]	
END

GO
SPGetAgeCategory @Age = 19
GO
--------------------------------------------------------------------------------------------------------------------------------------
-- 4. Create a stored procedure that determines the maximum, minimum,
--	and average of a given set of numbers ( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')
--------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC SPGetMaxMinAvg
@Numbers VARCHAR(max)
AS
BEGIN
Create Table #TempTable ([value] int)

	Insert into #TempTable
	Select Value
	From string_split(@Numbers, ',')

	Select Max(Value) As [Maximum Value], Min(Value) As [Minimum Value] , Avg(Value) As [Average Value]
	From #TempTable

	Drop Table #TempTable
END;

EXEC SPGetMaxMinAvg '5,10,15,20,25';
