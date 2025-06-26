--=================================================================
-------------------- Assignment07 -----------------------
--=================================================================
-- Use ITI DB:
USE ITI;
-------------------------------------------------------------------
GO
-------------------------------------------------------------------
--1. Create a scalar function that takes a date and returns the  Month name of that date.
CREATE FUNCTION dbo.GetMonthName (@InputDate DATE)
RETURNS VARCHAR(Max)
AS
BEGIN
    DECLARE @MonthName VARCHAR(Max);
    
    SET @MonthName = DATENAME(MONTH, @InputDate);
    
    RETURN @MonthName;
END;
go
SELECT dbo.GetMonthName('2024-05-30') AS MonthName;

--2Create a multi-statements table-valued function that takes  2 integers and returns the values between them.
go
CREATE FUNCTION dbo.GetValuesBetween (
    @StartValue INT,
    @EndValue INT
)
RETURNS @ResultTable TABLE (Value INT)
AS
BEGIN
    DECLARE @CurrentValue INT;
    
    SET @CurrentValue = @StartValue;
    
    WHILE @CurrentValue <= @EndValue
    BEGIN
        INSERT INTO @ResultTable (Value) VALUES (@CurrentValue);
        SET @CurrentValue = @CurrentValue + 1;
    END;

    RETURN;
END;
go
SELECT * FROM dbo.GetValuesBetween(5, 10);
--3Create a table-valued function that takes Student No and  returns Department Name with Student full name.
use ITI
go
CREATE FUNCTION dbo.GetStudentDepartmentFullName (
    @StudentNo INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT D.Dept_Name, CONCAT(S.St_Fname, ' ', S.St_Lname) AS FullName
    FROM  Student s , Department D
    where S.Dept_Id = D.Dept_Id
    and S.St_Id = @StudentNo
);
go
SELECT * FROM dbo.GetStudentDepartmentFullName(2);
--4 Create a scalar function that takes Student ID and returns  a message to user.
go
CREATE FUNCTION dbo.CheckStudentName (
    @StudentID INT
)
RETURNS VARCHAR(Max)
AS
BEGIN
    DECLARE @Message VARCHAR(Max);
    DECLARE @FirstName VARCHAR(Max);
    DECLARE @LastName VARCHAR(Max);

    SELECT @FirstName = s.St_Fname, @LastName = s.St_Lname
    FROM Student s
    WHERE s.St_Id = @StudentID;

    IF @FirstName IS NULL AND @LastName IS NULL
        SET @Message = 'First name & last name are null.';
    ELSE IF @FirstName IS NULL
        SET @Message = 'First name is null.';
    ELSE IF @LastName IS NULL
        SET @Message = 'Last name is null.';
    ELSE
        SET @Message = 'First name & last name are not null.';

    RETURN @Message
END
go
SELECT dbo.CheckStudentName(1) 

--5 Create a function that takes an integer which represents  the format of the Manager hiring date and displays  department name, Manager Name and hiring date with  this format.
go
CREATE FUNCTION dbo.GetManagerHiringDate (
    @Format INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        d.Manager_hiredate,
        d.Dept_Name,
		CONVERT(NVARCHAR(50), d.Manager_hiredate, @Format) AS HiringDateFormatted
        
    FROM Department d 
);
go
SELECT * FROM dbo.GetManagerHiringDate(101); 

--6 Create a multi-statement table-valued function that takes a  string.
go

CREATE FUNCTION getstddatebasedonformat (@format VARCHAR(MAX))
RETURNS @t TABLE (Std_id INT, std_name VARCHAR(MAX))
AS
BEGIN
    IF @format = 'first'
    BEGIN
        INSERT INTO @t
        SELECT St_id, s.St_Fname
        FROM Student s;
    END
    ELSE IF @format = 'last'
    BEGIN
        INSERT INTO @t
        SELECT St_id, s.St_Lname
        FROM Student s;
    END
    ELSE IF @format = 'full'
    BEGIN
        INSERT INTO @t
        SELECT St_id, CONCAT(s.St_Fname, ' ', s.St_Lname)
        FROM Student s;
    END

    RETURN;
END;
go
SELECT * FROM getstddatebasedonformat('first');
SELECT * FROM getstddatebasedonformat('last');
SELECT * FROM getstddatebasedonformat('full');

--7. Create function that takes project number and display all  employees in this project
use MyCompany
go
CREATE FUNCTION dbo.GetEmployeesInProjectbynumber (
    @ProjectNumber INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        E.SSN,
        E.Fname,
        E.Lname
    FROM 
        Employee E , Project p , Departments d
  
    
       
    WHERE  p.Dnum=d.Dnum and e.Dno=d.Dnum and
        P.Pnumber = @ProjectNumber 
);
go

SELECT * FROM dbo.GetEmployeesInProjectbynumber(1);










