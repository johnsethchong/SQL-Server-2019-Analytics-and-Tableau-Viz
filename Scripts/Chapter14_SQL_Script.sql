USE Human_Resources;

/*

	Scripts and exercises used in Chapter 14
	
	This script file (Chapter14_SQL_Script.sql) is available for download in this lecture resources 

*/

/*

	As analysts we can use the Insert statement to our advantage ; most particularly if we are analysing
	a set of data that we want to save for a short while for further analysis.

	Hence we can combine Insert and Select and Create Table all in one sql script

	SELECT 
		column(s)...
	INTO 
		table_name
	FROM
		table1(s)						! Nb: A Join can be used like any query
	WHERE 
		condition;

*/

select
	emp_no,
	birth_date,
	first_name,
	hire_date,
	gender_name
INTO
	DemoAnalysisOfFemaleBirthdays
from
	Employees emp inner join
	Gender gen on emp.gender = gen.gender
where
	gen.gender='F'
order by
	emp.birth_date

select * from [dbo].[DemoAnalysisOfFemaleBirthdays];

-- Exercise 14.1	The payroll manager would like to extract payroll data from the employee payroll	
--					for the paydate of 2019-11-30 and insert the data to a new table NEW_PAY_RUN
--
--				    As part of the extract and load she wants 7 days added to the Pay_Date value
--					
--					The new table will be the same column structure as the Payroll table
--				    Hints: Use dateadd() to calculate the new Pay_Date value which is replacing the 2019-11-30 value
--
--						   Ensure when building the FROM statement you specify the fully qualified name of the payroll
--					       table i.e. Select ... from Payroll.Employee_Payroll
--

select
	sid_Payrun_Ref_Key,
	sid_Employee,
	Pay_Amount,
	dateadd(d,7,Pay_Date) as Pay_Date,
	sid_Date
INTO
	NEW_PAY_RUN
from
	Payroll.Employee_Payroll
where
	Pay_Date = '2019-11-30';

select * from NEW_PAY_RUN;

/*
	    Syntax - Basically is quite straight forward  !
		      
		INSERT INTO table2 (column1, column2, column3, ...)
		SELECT 
			column1, column2, column3, ...
		FROM 
			table1
		WHERE 
			condition;

		<< >>

	    As data analysts we often end up writing sql code to insert changed/new data to an existing table that
		most probably has it's source in existing tables e.g. such a task maybe coding SQL for an Extract Transform Load (ETL) routine.

		It can be complex ! 
		
		But when approached in a step by step methodology then complex code is just the sum of the smaller steps.

		In this lesson scenario we will look at how to think and analyse what tables to use to perform this task. 
		
		As such the task is the re-instatement of an employee (Emp No 10021) to be currently employed.

		The employee needs to be inserted into the Current Personnel table using the last known position data

		What do we need from other tables to do this ? 
		
		Profiling your data is key here !

		*** Below are the basic steps to get started with ***

			1: Analyse the target table to establish the record attributes required 
		
			2: Search the data source(s) for a source of truth table i.e. Employee 10021 should exist in the Employees

			3: Search for remaining tables that will be used to build the source for the attributes required
			   It is easy when tables have names that appear to support the data subject but if this is not 
			   the case then more analysis is required e.g. Data Model

			4: Query the source table(s) for the subject matter to establish the subject data exists

			5: Any broken data ? (can this be rectified in a data fix later ? If Not then stake holder to be notified ) 

			6: Build the basic query to establish a record that will suffice to insert to the target table

			7: Test the query and establish if anything else is required to complete the query before to adding the record to the target table

			8: Create and run the INSERT script and test the success of this

*/

-- Steps 1 to 5

select 'Employees' as T1,* from Employees where emp_no in (10021);
select 'Emp Location' as T2,* from [dbo].[Employee_Location] where emp_no in (10021);
select 'Emp Movements' as T3,* from [dbo].[Employee_Movements_History] where emp_no in (10021);
select 'Emp Position' as T4,* from [dbo].[Employee_Position_History] where emp_no in (10021);
select 'Emp Salary' as T5,* from [dbo].[Salary_History] where emp_no in (10021) order by 5 desc;

select
	emp.sid_Employee,
	emp.emp_no,
	sh.current_salary,
	el.City,
	emh.sid_Department,
	el.sid_Location,
	eph.sid_Position
from
	Employees emp inner join
	Employee_Location el on emp.sid_Employee = el.sid_Employee inner join
	Employee_Movements_History emh on emp.sid_Employee = emh.sid_Employee inner join
	Employee_Position_History eph on emp.sid_Employee = eph.sid_Employee inner join
	Salary_History sh on emp.sid_Employee = sh.sid_Employee
where
	emp.emp_no='10021' ;

-- Steps 6 & 7

--	Introducing MAX() and the correlated sub query

-- 1: The MAX() function will return the maximum value of something 
--
--    Select 
--		Max(column) as alias
--	  from 
--		Table 
--	   where 
--		condition...
--
-- 2: A correlated sub query is just a query nested inside a query that uses values from the
--    outer query to return a value that we are seeking to complete the row (record) data
--

select
	emp.sid_Employee,
	emp.emp_no,
	(select max(current_salary) from Salary_History where emp_no = emp.emp_no) as current_salary,
	el.City,
	emh.sid_Department,
	el.sid_Location,
	eph.sid_Position
from
	Employees emp inner join
	Employee_Location el on emp.sid_Employee = el.sid_Employee inner join
	Employee_Movements_History emh on emp.sid_Employee = emh.sid_Employee inner join
	Employee_Position_History eph on emp.sid_Employee = eph.sid_Employee 
where
	emp.emp_no='10021' ;

select
	max(current_salary) 
from
	Salary_History
where
	emp_no = '10021'

-- Insert the row to Current_Personnel

/*
		INSERT INTO table2 (column1, column2, column3, ...)
		SELECT 
			column1, column2, column3, ...
		FROM 
			table1
		WHERE 
			condition;

*/

	insert into Current_Personnel (sid_Employee,emp_no,current_salary,current_location,sid_Department,sid_Location,sid_position)
	select
	emp.sid_Employee,
	emp.emp_no,
	(select max(current_salary) from Salary_History where emp_no = emp.emp_no) as current_salary,
	el.City,
	emh.sid_Department,
	el.sid_Location,
	eph.sid_Position
from
	Employees emp inner join
	Employee_Location el on emp.sid_Employee = el.sid_Employee inner join
	Employee_Movements_History emh on emp.sid_Employee = emh.sid_Employee inner join
	Employee_Position_History eph on emp.sid_Employee = eph.sid_Employee 
where
	emp.emp_no='10021' ;

select * from [dbo].[Current_Personnel] where emp_no = '10021'

 /*
	Exercise 14.2 

	Scenario : The Hiring Manager has requested that employee 10021 is to be recorded in
			   the NEW_PAY_RUN table ready for payroll processing.

		 Tip : Use the newly created personnel record from the previous lecture
		 
			   You will need 2 correlated subqueries with a MAX() function

			   The sid_Payrun_Ref_key is the concatenation of sid_Employee and sid_Date
			   hence one of the correlated subqueries can be used to make a value for the column				 

  */

-- 1: Analyse the target table to establish the record attributes required 


-- 2: Search the data source(s) for a source of truth table i.e. Employee 10021 should exist in Current_Personnel


-- 3: Search for remaining tables that will be used to build the source for the attributes required

 
-- 4: Query the source table(s) for the subject matter to establish the subject data exists


-- 5: Any broken data ? (can this be rectified in a data fix later ? If Not then stake holder to be notified ) 


-- 6: Build the basic query to establish a record that will suffice to insert to the target table

select
	sid_Employee + (select max(sid_Date) from NEW_PAY_RUN) as sid_Payrun_Ref_Key,
	sid_Employee,
	current_salary/12 as Pay_Amount,
	(select max(Pay_Date) from NEW_PAY_RUN) as Pay_Date,
	(select max(sid_Date) from NEW_PAY_RUN) as sid_Date
from
	Current_Personnel
where
	sid_Employee=21

select top 5 * from [dbo].[NEW_PAY_RUN];

-- 7: Test the query and establish if anything else is required to complete the query before to adding the record to the target table

select
	sid_Employee + (select max(sid_Date) from NEW_PAY_RUN) as sid_Payrun_Ref_Key,
	sid_Employee,
	current_salary/12 as Pay_Amount,
	(select max(Pay_Date) from NEW_PAY_RUN) as Pay_Date,
--	(select top 1 Pay_Date from NEW_PAY_RUN) as Pay_Date,		-- You can also use Top 1 instead of Max() if you can verify all column values are the same i.e. Pay_Date
	(select max(sid_Date) from NEW_PAY_RUN) as sid_Date
from
	Current_Personnel
where
	sid_Employee=21;

-- 8: Create and run the INSERT script and test the success of this

insert into NEW_PAY_RUN (sid_Payrun_Ref_Key,sid_Employee,Pay_Amount,Pay_Date,sid_Date)
select
	sid_Employee + (select max(sid_Date) from NEW_PAY_RUN) as sid_Payrun_Ref_Key,
	sid_Employee,
	current_salary/12 as Pay_Amount,
	(select max(Pay_Date) from NEW_PAY_RUN) as Pay_Date,
	(select max(sid_Date) from NEW_PAY_RUN) as sid_Date
from
	Current_Personnel
where
	sid_Employee=21;

select * from NEW_PAY_RUN where sid_Employee=21;