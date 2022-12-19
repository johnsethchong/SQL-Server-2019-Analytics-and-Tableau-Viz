USE Human_Resources;

/*

	Scripts and exercises used in Chapter 13
	
	This script file (Chapter13_SQL_Script.sql) is available for download in this lecture resources 

*/

/*

	A view is a Virtual Table based on the result set of an SQL-Statement (DML)

	i.e. The view will contain rows and columns just as a real table does.

		 The view can be made up of 1 or more tables depending on your requirements

		 The view can contain functions, predicates (Where conditions) , Joins & Views and as such
		 the output from the view will appear as if it were coming from a single table

		 Caveat : You cannot use the ORDER BY inside the view definition ! Normally you would use
				  and Order By at the end of your Select ... statement as you would with a Select from
				  a table for example.

		 We can create a view using SSMS or DDL (most often I would use DDL)

		 Lets look at the View UI first to get started ...

*/

select * from [dbo].[vwTestDemoEmpGender];

-- Exercise 13.1 A colleague data analyst has asked a favour to create a view that lists ...
--			
--				 Current Employees by Emp No, First and Last Name and their department they work in
--

select * from [dbo].[vwEmployeeDepartments];

GO;


/*
			We can use DDL to create a view, this is often faster than using the Create View UI but
			of course we need to be proficient in the design and coding of a query first

			CREATE VIEW view_name AS
			SELECT 
				column1, column2, ...
			FROM 
				table_name
			WHERE 
				condition;

*/
		create view DemoDDLView as
		select Top 10000
			emp1.first_name + ' ' + emp1.last_name as Emp1_Name,
			emp1.hire_date,
			DATEDIFF(year,emp1.hire_date,getdate()) as Emp1_YearsAtWork,
			emp2.first_name + ' ' + emp2.last_name as Emp2_Name,
			DATEDIFF(year,emp2.hire_date,GETDATE()) as Emp2_YearsAtWork
		from
			Employees emp1,
			Employees emp2
		where
			emp1.emp_no <> emp2.emp_no and
			emp1.hire_date = emp2.hire_date
		Order By 1	;
		go;

select * from [dbo].[DemoDDLView];

go;

-- Exercise 13.2 You are at an interview and the Team Leader has asked you to edit view vwEmployeeDepartments
--				 to extract the DML and use it to create a new view via DDL.
--
--				 But first the Team leader wants you to (Code) a filter (In the view itself) to only include 
--				 the current employees that work in Sales
--


