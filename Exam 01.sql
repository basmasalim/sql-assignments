--===================================================================================
----------------------------------- Exam 01 ----------------------------------------
--===================================================================================
------------------------ Try To Write The Following Queries : -----------------------
---------------------------------------------------------------------------------------------------------------
-- 1. Write a query that displays Full name of an employee who has more than 3 letters in his/her First Name
---------------------------------------------------------------------------------------------------------------
SELECT CONCAT(E.Fname, ' ', E.Lname) 'Full Name'
FROM Employee E
WHERE E.Fname LIKE '____%'

---------------------------------------------------------------------------------------------------------------
-- 2. Write a query to display the total number of Programming books available in the library with alias name ‘NO OF PROGRAMMING BOOKS’
---------------------------------------------------------------------------------------------------------------
SELECT COUNT(*) 'NO OF PROGRAMMING BOOKS'
FROM Category C, Book B
WHERE C.Id = B.Cat_id AND C.Cat_name = 'programming'

---------------------------------------------------------------------------------------------------------------
-- 3. Write a query to display the number of books published by (HarperCollins) with the alias name 'NO_OF_BOOKS'.
---------------------------------------------------------------------------------------------------------------
SELECT COUNT(P.Name) 'NO_OF_BOOKS'
FROM  Publisher P
WHERE P.Name = 'HarperCollins'

---------------------------------------------------------------------------------------------------------------
-- 4. Write a query to display the User SSN and name, date of borrowing and due date of the User whose due date is before July 2022.
---------------------------------------------------------------------------------------------------------------
SELECT DISTINCT U.SSN, U.User_Name, B.Borrow_date, B.Due_date
FROM Borrowing B, Users U 
WHERE U.SSN = B.User_ssn AND B.Due_date < '2022-7-01'

---------------------------------------------------------------------------------------------------------------
-- 5. Write a query to display book title, author name and display in the following format, ' [Book Title] is written by [Author Name].
---------------------------------------------------------------------------------------------------------------
SELECT CONCAT(B.Title, ' is written by ', A.Name) 'Book title and hir Author'
FROM Book B, Book_Author BAuth, Author A
WHERE B.Id = BAuth.Book_id AND BAuth.Author_id = A.Id

---------------------------------------------------------------------------------------------------------------
-- 6. Write a query to display the name of users who have letter 'A' in their names. 
---------------------------------------------------------------------------------------------------------------
SELECT *
FROM Users U
WHERE U.User_Name LIKE '%A%'

---------------------------------------------------------------------------------------------------------------
-- 7. Write a query that display user SSN who makes the most borrowing
---------------------------------------------------------------------------------------------------------------
SELECT TOP(1) B.User_ssn
FROM Borrowing B
GROUP BY B.User_ssn
ORDER BY COUNT(B.User_ssn) DESC

---------------------------------------------------------------------------------------------------------------
-- 8. Write a query that displays the total amount of money that each user paid for borrowing books. 
---------------------------------------------------------------------------------------------------------------
SELECT B.User_ssn, SUM(B.Amount) 'The Total Amount Of Money'
FROM Borrowing B
GROUP BY B.User_ssn

---------------------------------------------------------------------------------------------------------------
-- 9.  write a query that displays the category which has the book that has the minimum amount of money for borrowing.
---------------------------------------------------------------------------------------------------------------
SELECT TOP(1)C.Cat_name
FROM Borrowing Bor, Book B, Category C
WHERE Bor.Book_id = B.Id AND C.Id = B.Cat_id
ORDER BY Bor.Amount 

---------------------------------------------------------------------------------------------------------------
-- 10.  write a query that displays the email of an employee if it's not found, display address if it's not found, display date of birthday. 
---------------------------------------------------------------------------------------------------------------
SELECT Coalesce(E.Email, E.Address, Convert(varchar(20), E.DOB), 'Not Found') 'Employees Data'
FROM Employee E

---------------------------------------------------------------------------------------------------------------
-- 11.  Write a query to list the category and number of books in each category with the alias name 'Count Of Books'.
---------------------------------------------------------------------------------------------------------------
SELECT C.Cat_name, COUNT(B.Title) 'Count Of Books'
FROM Category C, Book B
GROUP BY C.Cat_name

---------------------------------------------------------------------------------------------------------------
-- 12.  Write a query that display books id which ***is not found in*** ( floor num = 1 and shelf-code = A1)
---------------------------------------------------------------------------------------------------------------
SELECT B.Id
FROM Book B
WHERE B.Id NOT IN (SELECT B.Id
					FROM Book B, Shelf S
					WHERE B.Shelf_code = S.Code AND S.Code = 'A1' AND S.Floor_num = 1)

---------------------------------------------------------------------------------------------------------------
-- 13.  Write a query that displays the floor number , Number of Blocks and number of employees working on that floor.
---------------------------------------------------------------------------------------------------------------
SELECT F.Number, F.Num_blocks, COUNT(E.Id) 'Number Of Employees'
FROM Employee E, Floor F
WHERE E.Floor_no = F.Number
GROUP BY F.Number, F.Num_blocks

---------------------------------------------------------------------------------------------------------------
-- 14.  Display Book Title and User Name to designate Borrowing that occurred within the period ‘3/1/2022’ and ‘10/1/2022’
---------------------------------------------------------------------------------------------------------------
SELECT B.Title, U.User_Name, Bro.Borrow_date
FROM Book B, Users U, Borrowing Bro
WHERE Bro.Book_id = B.Id AND Bro.User_ssn = U.SSN AND Bro.Borrow_date BETWEEN '3/1/2022' AND '10/1/2022'

---------------------------------------------------------------------------------------------------------------
-- 15.  Display Employee Full Name and Name Of his/her Supervisor as Supervisor Name.
---------------------------------------------------------------------------------------------------------------
SELECT CONCAT(E.Fname, ' ', E.Lname) 'Employee Full Name', CONCAT(Super.Fname, ' ', Super.Lname) 'Supervisor'
FROM Employee E, Employee Super
WHERE E.Super_id = Super.Id

---------------------------------------------------------------------------------------------------------------
-- 16.  Select Employee name and his/her salary but if there is no salary display Employee bonus.
---------------------------------------------------------------------------------------------------------------
SELECT CONCAT(E.Fname, ' ', E.Lname) 'Full Name', Coalesce(E.Salary, E.Bouns, 'Not Found') 'Employees Data'
FROM Employee E

---------------------------------------------------------------------------------------------------------------
-- 17.  Display max and min salary for Employees
---------------------------------------------------------------------------------------------------------------
SELECT MAX(E.Salary) 'Max Salary', MIN(E.Salary) 'Min Salary'
FROM Employee E

---------------------------------------------------------------------------------------------------------------
-- 18.  Write a function that take Number and display if it is even or odd 
---------------------------------------------------------------------------------------------------------------
GO
CREATE FUNCTION TakeNumberAndDisplayEvenOdd (@Num INT)
RETURNS VARCHAR(Max)
AS
BEGIN
	DECLARE @Msg VARCHAR(Max)
	IF (@Num % 2 = 0)
		SELECT @Msg = 'Even'
	ELSE
		SELECT @Msg = 'Odd'

	RETURN @Msg
END
GO

--Run
SELECT DBO.TakeNumberAndDisplayEvenOdd(7) 'Odd OR Even!'

---------------------------------------------------------------------------------------------------------------
-- 19.  write a function that take category name and display Title of books in that category
---------------------------------------------------------------------------------------------------------------
GO
CREATE FUNCTION GetCategoryNameAndDisplayTitleOfBooks(@CategoryName VARCHAR(Max))
Returns TABLE
AS
RETURN (SELECT B.Title
		FROM Category C, Book B
		WHERE C.Id = B.Cat_id AND C.Cat_name = @CategoryName )
GO

--Run
SELECT * FROM GetCategoryNameAndDisplayTitleOfBooks('Programming')

---------------------------------------------------------------------------------------------------------------
-- 20.  write a function that takes the phone of the user and displays Book Title ,user-name, amount of money and due-date.
---------------------------------------------------------------------------------------------------------------
GO
CREATE FUNCTION TakesPhoneAndDisplayBookTitleUserNameAmountOfMoneyAndDue(@Phone VARCHAR(Max))
RETURNS TABLE
AS
RETURN (SELECT B.Title, U.User_Name, Bro.Amount, Bro.Due_date
		FROM Users U, User_phones UPhone, Book B, Borrowing Bro
		WHERE U.SSN = UPhone.User_ssn AND B.Id = Bro.Book_id AND Bro.User_ssn = U.SSN AND UPhone.Phone_num = @Phone)
GO

--Run
SELECT * FROM TakesPhoneAndDisplayBookTitleUserNameAmountOfMoneyAndDue('0102585555')

---------------------------------------------------------------------------------------------------------------
-- 21.  Write a function that take user name and check if it's duplicated
--	return Message in the following format ([User Name] is Repeated [Count] times) 
--	if it's not duplicated display msg with this format [user name] is not duplicated,
--	if it's not Found Return [User Name] is Not Found 
---------------------------------------------------------------------------------------------------------------
GO
CREATE FUNCTION TakeUserNameTOCheckDuplicated (@UserName VARCHAR(Max))
RETURNS VARCHAR(Max)
AS
BEGIN
	DECLARE @Msg VARCHAR(Max)
	DECLARE @Count INT

	SELECT @Count = COUNT(U.User_Name)
	FROM Users U
	WHERE @UserName = U.User_Name
	GROUP BY U.User_Name

	IF (@Count > 1)
		SELECT @Msg = CONCAT(@UserName , ' is Repeated ', @Count, ' times ')
	ELSE IF(@Count = 1)
		SELECT @Msg = CONCAT(@UserName , ' is not duplicated')
	ELSE
		SELECT @Msg = CONCAT(@UserName , ' is Not Found')

	RETURN @Msg
END
GO

--Run
SELECT DBO.TakeUserNameTOCheckDuplicated('Amr ahmed') 'Massage'

---------------------------------------------------------------------------------------------------------------
-- 22.  Create a scalar function that takes date and Format to return Date With That Format.
---------------------------------------------------------------------------------------------------------------
GO
CREATE OR ALTER FUNCTION GetDataWithFormat(@Date DATE, @Format INT)
RETURNS NVARCHAR(50)
AS
BEGIN
	RETURN CONVERT(NVARCHAR(50), @Date, @Format)
END
GO

--Run
SELECT DBO.GetDataWithFormat(GETDATE(), 130) 'Date'

---------------------------------------------------------------------------------------------------------------
-- 23. Create a stored procedure to show the number of books per Category.
---------------------------------------------------------------------------------------------------------------
GO
CREATE PROC SPShowNumberOfBooks
WITH ENCRYPTION
AS
BEGIN
	SELECT C.Cat_name, COUNT(B.Cat_id) 'Number Of Books'
	FROM Category C, Book B
	WHERE C.Id = B.Cat_id
	GROUP BY C.Cat_name
END
GO

--Run
SPShowNumberOfBooks

---------------------------------------------------------------------------------------------------------------
-- 24. Create a stored procedure that will be used in case there is an old manager 
--	who has left the floor and a new one becomes his replacement. The procedure should take 3 parameters
--	(old Emp.id, new Emp.id and the floor number) and it will be used to update the floor table. 
---------------------------------------------------------------------------------------------------------------
GO
CREATE OR ALTER PROC SPReplaceManagerInFloor
@OldManagerNo INT,
@NewManagerNo INT,
@FloorNo INT

WITH ENCRYPTION
AS
BEGIN
	UPDATE Floor 
	SET MG_ID = @NewManagerNo
	WHERE MG_ID = @OldManagerNo AND Number  = @FloorNo
END
GO
--Run
SPReplaceManagerInFloor 1, 2, 3
SELECT * FROM Floor

---------------------------------------------------------------------------------------------------------------
-- 25. Create a view AlexAndCairoEmp that displays Employee data for users who live in Alex or Cairo. 
---------------------------------------------------------------------------------------------------------------
GO
CREATE VIEW VAlexAndCairoEmp
AS
	SELECT *
	FROM Employee E
	WHERE E.Address IN('Cairo', 'Alex') AND E.Address IS NOT NULL
GO

--Run
SELECT * FROM VAlexAndCairoEmp

---------------------------------------------------------------------------------------------------------------
-- 26. create a view "V2" That displays number of books per shelf
---------------------------------------------------------------------------------------------------------------
GO
CREATE VIEW V2
AS
	SELECT B.Shelf_code, COUNT(B.Title) 'Number Of Books'
	FROM Book B
	GROUP BY B.Shelf_code
GO

--Run
SELECT * FROM V2

---------------------------------------------------------------------------------------------------------------
-- 27. create a view "V3" That display the shelf code that have maximum number of books using the previous view "V2"
---------------------------------------------------------------------------------------------------------------
GO
CREATE VIEW V3
AS
	SELECT TOP(1)Shelf_code
	FROM V2
	ORDER BY [Number Of Books] DESC
GO

--Run
SELECT * FROM V3

---------------------------------------------------------------------------------------------------------------
-- 28. Create a table named ‘ReturnedBooks’ With the Following Structure :
--	then create A trigger that instead of inserting the data of returned book checks 
--	if the return date is the due date or not 
--	if not so the user must pay a fee and it will be 20% of the amount that was paid before.
---------------------------------------------------------------------------------------------------------------
GO
CREATE TABLE ReturnedBooks
(
	UserSSN INT ,
	Bookid INT , 
	DueDate DATE,
	ReturnDate DATE ,
	Fees MONEY 
);

GO
CREATE OR ALTER TRIGGER InsertInReturn
on ReturnedBooks
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO ReturnedBooks (UserSSN, Bookid, DueDate, ReturnDate, Fees)
    SELECT I.UserSSN, I.Bookid, I.DueDate, I.ReturnDate,
        CASE 
            WHEN B.Due_date < I.ReturnDate THEN B.Amount * 0.2
            ELSE 0
        END AS Fees
    FROM inserted I, Borrowing B
    WHERE I.UserSSN = B.User_ssn AND I.Bookid = B.Book_id AND I.DueDate = B.Due_date;
END;
GO
	
--Run
INSERT INTO ReturnedBooks 
VALUES (1, 3, '2021-02-27', '2025-07-09', NULL);

SELECT * FROM ReturnedBooks

---------------------------------------------------------------------------------------------------------------
-- 29. In the Floor table insert new Floor With Number of blocks 2 , 
--	employee with SSN = 20 as a manager for this Floor, 
--	The start date for this manager is Now.

--	Do what is required if you know that : 
--	Mr.Omar Amr(SSN=5) moved to be the manager of the new Floor (id = 7), and
--	they give Mr. Ali Mohamed(his SSN =12) His position .
---------------------------------------------------------------------------------------------------------------
SELECT * FROM Floor

INSERT INTO Floor
VALUES(7, 2, 20,GETDATE())

UPDATE Floor
SET MG_ID = 12
WHERE MG_ID = 5

UPDATE Floor
SET MG_ID = 5
WHERE MG_ID = 7

---------------------------------------------------------------------------------------------------------------
-- 30. Create view name (v_2006_check) that will display Manager id, Floor Number where he/she works ,
--	Number of Blocks and the Hiring Date which must be from the first of March and the end of May 2022.
--	this view will be used to insert data so make sure that the coming new data must match the condition 
--	then try to insert this 2 rows and Mention What will happen
---------------------------------------------------------------------------------------------------------------
GO
CREATE VIEW v_2006_check
AS
	SELECT F.*
	FROM Floor F
	WHERE F.Hiring_Date BETWEEN '2022-03-01' AND '2022-05-31' WITH CHECK OPTION
GO

--Run
SELECT * FROM Floor

INSERT INTO v_2006_check
VALUES(8,2,20,'2023-07-09')

INSERT INTO v_2006_check
VALUES(8,2,20,'2022-04-01')

---------------------------------------------------------------------------------------------------------------
-- 31. Create a trigger to prevent anyone from Modifying or Delete or Insert in the Employee table 
--	( Display a message for user to tell him that he can’t take any action with this Table)
---------------------------------------------------------------------------------------------------------------
GO
CREATE TRIGGER TR_PreventChangesOnEmployee
ON Employee
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    PRINT('You are not allowed to Insert, Update, or Delete data in the Employee table.');
END;
GO

UPDATE Employee
SET Fname = 'Basme'
WHERE Id = 1

INSERT INTO Employee (Id, Fname) 
VALUES (21, 'Basma');

SELECT * FROM Employee

---------------------------------------------------------------------------------------------------------------
-- 32. Testing Referential Integrity , Mention What Will Happen When:
---------------------------------------------------------------------------------------------------------------
--	A. Add a new User Phone Number with User_SSN = 50 in User_Phones Table
---------------------------------------------------------------------------------------------------------------
SELECT * FROM User_phones

INSERT INTO User_phones
VALUES(50, '01097997765')
-- The INSERT statement conflicted with the FOREIGN KEY constraint "FK_User_phones_User". The conflict occurred in database "Library", table "dbo.Users", column 'SSN'.

---------------------------------------------------------------------------------------------------------------
--	B. Modify the employee id 20 in the employee table to 21 
---------------------------------------------------------------------------------------------------------------
UPDATE Employee
SET Id = 21
WHERE Id = 20
-- Cannot update identity column 'Id'.

---------------------------------------------------------------------------------------------------------------
--	C. Delete the employee with id 1 
---------------------------------------------------------------------------------------------------------------
DELETE FROM Employee WHERE Id = 1
-- The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee". The conflict occurred in database "Library", table "dbo.Borrowing", column 'Emp_id'.

---------------------------------------------------------------------------------------------------------------
--	D. Delete the employee with id 12 
---------------------------------------------------------------------------------------------------------------
DELETE FROM Employee WHERE Id = 12
-- The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee". The conflict occurred in database "Library", table "dbo.Borrowing", column 'Emp_id'.

---------------------------------------------------------------------------------------------------------------
--	E. Create an index on column (Salary) that allows you to cluster the data in table Employee.
---------------------------------------------------------------------------------------------------------------
GO
CREATE CLUSTERED INDEX IXSalary
ON Employee(Salary)
GO

-- Cannot create more than one clustered index on table 'Employee'. Drop the existing clustered index 'PK_Employee' before creating another.
GO
CREATE NONCLUSTERED INDEX IXSalary
ON Employee(Salary);
GO


-----------
--OR
-----------
DROP INDEX PK_Employee ON Employee;

GO
CREATE CLUSTERED INDEX IXSalary
ON Employee(Salary)
GO


---------------------------------------------------------------------------------------------------------------
--	33. Try to Create Login With Your Name And give yourself access Only to Employee and
--	Floor tables then allow this login to select and insert data into tables and
-- deny Delete and update (Don't Forget To take screenshot to every step)
---------------------------------------------------------------------------------------------------------------

-- Done ScreenShot 