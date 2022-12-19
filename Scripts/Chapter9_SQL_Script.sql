
USE Human_Resources;

/*

	Scripts and exercises used in Chapter 9
	
	This script file (Chapter9_SQL_Script.sql) is available for download in this lecture resources 

*/

/*

SELECT	
	column1, 
	column2, ...
FROM	
	table_name;

*/


SELECT
	Cal_Date,
	Cal_Year
FROM
	[dbo].[Calendar];

-- Exercise 9.1 Display the values of Gender Name from the Gender table

SELECT
	[gender_name]
FROM
	Gender;

/*

SELECT	
	column1, 
	column2, ...
FROM	
	table_name
WHERE
	Condition;

*/

SELECT
	[emp_no],
	[City],
	[StateProvinceName]
FROM
	Employee_Location
WHERE
	[PostalCode] = '98107';

-- Exercise 9.2 Extract a set of data from the Employee Position History that are Engineers

select [position] from [dbo].[Employee_Position_History];
select * from [dbo].[Position_Title];

SELECT 
	[emp_no],
	[pos_from_date]
FROM
	[dbo].[Employee_Position_History]
WHERE
	[position] = 'Engineer';

/*

	Note :	The AND operator is used to filter rows based on 2 or more conditions
			The AND operator displays a record if all the conditions separated by AND are TRUE
	
			Introduction to Order By and the logical operator > i.e Greater than
						
	
SELECT	
	column1, 
	column2, ...
FROM	
	table_name
WHERE
	Condition AND
	Condition ... e.g. a Logical operator as a condition

ORDER BY
	Column1,Column2, ... ;

*/

select
	[emp_no],
	[current_salary],
	[current_location]
from
	[dbo].[Current_Personnel]
where
	current_location = 'Burbank' AND
	[current_salary] > 100000

ORDER BY
	[current_salary] desc;
	--[current_location];

-- Exercise 9.3 Extract a set of data from the Current Personnel table listing employees that have a salary > $50,000 and are located in Beverly Hills 

select
	[emp_no],
	[current_salary],
	[current_location]
from
	[dbo].[Current_Personnel]
where
	[current_salary] > 50000 	AND
	current_location = 'Beverly Hills' 
ORDER BY
	[current_salary] desc;


/*

	Note :	The OR operator is used to filter rows based on 2 or more conditions
			The OR operator displays a record if any of the conditions separated by OR are TRUE
	
			Introduction to Order By Ordinal and the logical operator < i.e Less Than than
						
			Lets also combine the AND with OR conditions

SELECT	
	column1, 
	column2, ...
FROM	
	table_name
WHERE
	Condition OR
	Condition ... e.g. a Logical operator as a condition

ORDER BY
	Ordinal 1, 2, 3 ... ;

*/

select 
	[emp_no],
	[current_salary],
	[current_location]
from
	[dbo].[Current_Personnel]
where
	(current_location = 'Beverly Hills' OR 
	 current_location = 'Palo Alto'			) AND 
	[current_salary] < 50000
ORDER BY
	 3,2;
	 --[current_location],[current_salary]

-- Exercise 9.4 Our user wants to know how many (total count that is) employees have a salary < 45000 and are located in Springwood,Salem,Roncq
--			    she also wants to know what is the lowest salary for Springwood


select 
	[emp_no],
	[current_salary],
	[current_location]
from
	[dbo].[Current_Personnel]
where
	(current_location = 'Springwood' OR 
	 current_location = 'Salem'		 OR current_location ='Roncq'	) AND 
	[current_salary] < 45000
ORDER BY
	 3,2;

/*

	Note : The IN operator allows you to specify multiple values in a WHERE clause.
		   The IN operator is another way to use the OR operator

SELECT 
	column_name(s)
FROM 
	table_name
WHERE 
	column_name IN (value1, value2, ...);

*/

select 
	[emp_no],
	[current_salary],
	[current_location]
from
	[dbo].[Current_Personnel]
where
	current_location IN ('Springwood','Salem','Roncq') AND
--	(current_location = 'Springwood' OR 
--	 current_location = 'Salem'		 OR current_location ='Roncq'	) AND 
	[current_salary] < 45000
ORDER BY
	 3,2;

select 
	[emp_no],
	[current_salary],
	[current_location]
from
	[dbo].[Current_Personnel]
where
	current_location NOT IN (select city from Geography) 
ORDER BY
	 3,2;

-- Exercise 9.5 The HR Manager has asked us to test the Current Personnel employees have a corresponding entry in the Employees table 
-- (note emp_no is common to these tables and Employees is the source of truth)

select
	[emp_no]
from
	Current_Personnel
where
	emp_no not in (select emp_no from [dbo].[Employees]);


/*

	Note : The BETWEEN operator selects values within a given range. The values can be numbers, text, or dates.
		   The BETWEEN operator is inclusive which means the Begin and End values are included in selection	

SELECT 
	column_name(s)
FROM 
	table_name
WHERE 
	column_name BETWEEN value1 AND value2;

*/

select
	emp_no,
	current_salary,
	current_location
from
	Current_Personnel
Where
	current_salary between 45000 and 47500
order by
	3,2

select * from Employees;

select
	[emp_no],
	[last_name],
	[birth_date]
from
	Employees
where
	birth_date between '1973-06-01' and '1974-06-01'
order by
	3;

-- Exercise 9.6 The HR Manager has asked us to supply a list of Female Employees that were hired between 31st Dec 2014 and 31st Dec 2016 
--              the list should include : emp_no, Gender, First Name, Last Name, Hire Date and sorted by Last Name

select
	[emp_no],
	gender,
	first_name,
	last_name,
	hire_date
from
	[dbo].[Employees]
where
	gender = 'F' and
	hire_date between '2014-12-31' and  '2016-12-31'
order by
	5;

/*

	Note : A NULL value is a field with no value !

		   If a field contains a blank i.e. Space(s) it is no longer a NULL value
	
		   Records can contain NULL's if the column constraint allows this

		   We cannot use normal operators such as = , < ,> to test for NULL's

		   We use the operator IS NULL or IS NOT NULL to test for NULL's

	SELECT 
		column_names
	FROM 
		table_name
	WHERE 
		column_name IS NULL;

*/

select
	[emp_no],
	current_location
from
	[dbo].[Current_Personnel]
where
	[current_location] is not null;

-- Exercise 9.7 The Data Manager is executing a project to check the data integrity of our database 
--				The task is to check that the employee location table does not have nulls where a value is 
--				expected in the sid_employee column

select
	emp_no,
	sid_employee
from
	[dbo].[Employee_Location]
where
	sid_Employee is null;

/*

	Note: The LIKE operator is used in a WHERE clause to search for a specified pattern in a column of Character data type.
		  Combinations of the wildcard symbol can be used   	

	%	Any string of zero or more characters e.g. Where last_name like '%ba%' finds all last names 'ba' in them

	_ (Underscore) Any single character e.g Where first_name like '_ary' finds all first names that end with 'ary'

	[]  Any single character within the specified range ([a-f]) or set ([abcdef]). e.g. first_name like 'Ale[j-s]%' finds all first names starting with Ale and any single character
																													from 'j' to 's' e.g. Aleksandar

	^   Any single character not within the specified range ([^a-f]) or set ([^abcdef]). e.g. first_name like 'Ale[^k]%' finds all first names starting with Ale and the following letter is
																												         not 'k' e.g. Alejandra	

	Syntax :

	SELECT 
		column_names
	FROM 
		table_name
	WHERE 
		column_name LIKE 'insert wildcard pattern here'

*/
select
	emp_no,
	first_name,
	last_name
from
	Employees
where
	first_name not like '%ba%';

-- Exercise 9.8 The Data Analyst is searching for all males with a first name that begins with Elv  

select
	emp_no,
	first_name,
	last_name,
	gender
from
	Employees
where
	gender = 'M' and
	first_name like 'Elv%'

/*
	Note : The results of a comparison operator has the Boolean data type i.e. True, False, Unknown 
		   Expressions that return a Boolean data type are also know as Boolean Expressions 

		= (Equals)			Equal to
		> (Greater Than)	Greater than
		< (Less Than)		Less than

		>= (Greater Than or Equal To)	Greater than or equal to
		<= (Less Than or Equal To)		Less than or equal to
		<> (Not Equal To)				Not equal to

		!= (Not Equal To)				Not equal to (not ISO standard)
		!< (Not Less Than)				Not less than (not ISO standard)
		!> (Not Greater Than)			Not greater than (not ISO standard)

	SELECT 
		column_names
	FROM 
		table_name
	WHERE 
		column_name {insert operator here} value ;

*/

select 
	emp_no,
	current_salary
from
	Salary_History
where
	current_salary != 58482
order by
	2;

-- Exercise 9.9 The Payroll Analyst requires a data set of all employees with a salary of $55,000 to $60,000 inclusive

select
	emp_no,
	current_salary
from
	Salary_History
where
	current_salary >= 55000 and
	current_salary <= 60000
order by
	2;

select
	emp_no,
	current_salary
from
	Salary_History
where
	current_salary between 55000 and 60000
order by 2;

/*
	Note : The SELECT DISTINCT statement is used to return only distinct (unique) values.
		 
	SELECT 
		DISTINCT column1, column2, ...
	FROM 
		table_name;	 

*/

select
	distinct current_location
from
	Current_Personnel
order by 1 desc;

-- Exercise 9.10 The HR manager requires a list of distinct First and Last names from the employees table ordered by First Name, Last Name

select
	distinct first_name,
	last_name
from
	Employees
order by
	1,2;

/*

	Note : We use SQL Aliases to make column names more readable i.e. User friendly
		   An alias exists only for the life of the query 

	SELECT 
		column_name AS alias_name
	FROM 
		table_name;

	Note : Aliases can also be assigned to a Table (This is something we do when performing table joins)

	SELECT 
		column_name(s)
	FROM 
		table_name AS alias_name;

*/

select
	distinct first_name as [First Name],
	last_name as [Last Name]
from
	Employees
order by
	1,2;

select
	distinct first_name as [First Name],
	last_name as [Last Name]
from
	Employees as dimEmpName
order by
	1,2;

-- Exercise 9.11 The Data Visualisation analyst has requested a list of Cities and State Provinces are extracted
--               from the Geography table , the output name for State Province should be aliased to State and the
--			     output table aliased to dimGeo , the list should be ordered by Country

select
	city,
	StateProvinceName as [State],
	CountryRegionName
from
	Geography as dimGeo
order by
	CountryRegionName;

/*

	Note: Sometimes where tables contain multi million rows and performance can be affected by your test/profiling
		  query then we can limit the number of rows returned from query

		  We can specify the number or percentage of rows returned

	SELECT TOP number|percent column_name(s)
	FROM 
		table_name
	WHERE 
		condition;

*/

select
	top 1000 Pay_Amount
from
	[Payroll].[Employee_Payroll];

select
	top 5 PERCENT Pay_Amount
from
	[Payroll].[Employee_Payroll];


-- Exercise 9.12 The DBA has requested you test your query against the Salary History table , she says it takes many seconds and 
--				 requires that the query uses a reduced row set e.g. 50,000 
--				 What times did you observe between the raw query and the top n query ?

select
	top 50000 current_salary
from
	Salary_History;