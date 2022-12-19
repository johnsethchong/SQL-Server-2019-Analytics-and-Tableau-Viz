USE [Human_Resources];

/*
	Scripts and exercises used in Chapter 21
	
	This script file (Chapter21_SQL_Script.sql) is available for download in this lecture resources 

*/
	
	-- Note: Database performance is a large topic and these few lectures serve to plant a seed of thought
	--       into your mind that will get you thinking about your query design and why it may not be performing
	--	     the way you hoped i.e. Takes a long time to return your result set.

/*

	SYNTAX using DDL
	-----------------

	CREATE INDEX idxName ON table1 (col1...); 					Create a nonclustered index on a table or view (> 1 non clustered indexes allowed on a table)

	CREATE CLUSTERED INDEX idxName ON table1 (col1...);			Create a clustered index on a table (Single Clustered index only allowed)

	Note : There are 2 Types of Index lookup mechanism considered by the query optimiser ...

	1: Index Seek (The most efficient and sought after)

		Typically results are returned faster than a scan as the optimizer will return all fields in the index
		instead of a few relevant ones.
		
	2: Index Scan 
		
		This is a more costly mechanism as the query optimiser will search each and every field in the index, 
		and tries to find the fields matching the criteria given in the query i.e. the condition in a Where clause.

	Note:

     For the most part the Query Optimizer will determine the best strategy for retrieval, although it helps to 
	 indexes defined strategically e.g. Closely aligned to the most common types of queries anticipated on the
	 database content.
	
*/

-- Demo

		select																		
			count(distinct sid_Employee) as PayrollEmpCount
		from
			Payroll.Employee_Payroll
		where
		    Pay_Date > '2019-07-15'	
					

-- Exercise 21.1	You want to prototype a query and test the chosen index is suitable for the production employees table, 
--					however there is not enough data to test this on as we are on the developer server.
--
--					Hence you will need to perform ...
--	
--					1: Create a new table named EmployeesIdxStudent
--
--					   The script file (EmployeesIdxStudent.sql) is available for download in this lecture resources
--					   Hence download and run the script to create the table
--
--					2: The table is a copy of the Employees table , hence you need to fill it with millions of rows
--					   sourced from the Employees table
--					   
--						a) Write an Insert statement that runs 10 times this will fill the table to ~3mil rows
--						   If you want to add more, go ahead :)
--
--						Hint: Use your knowledge of the WHILE loop to do this
--
--					3: Use the below query to check the Estimated Execution Plan 
--
--						a) Check the cost of the query
--						b) Evaluate an Index to create
--					
					select 
						count(distinct emp_no)
					from
						EmployeesIdxStudent
					where
						hire_date > '2000-02-02' 
--
--					4: Create the index recommended and check the new Cost, did you observe improvement ?
--
--
--	Solution 
--
--	1: Create the EmployeesIdxStudent Table

--	2: Create an Insert statement to insert to the new table (at least 3mil rows)

	declare @N int = 1
	while @N < 11
	begin
		insert into EmployeesIdxStudent
		select * from Employees

		select @N = @N +1

		if @N > 10 Break
	end;

--  3: Display the execution plan for the below query

		select count(distinct emp_no)
			from
				EmployeesIdxStudent
			where
				hire_date > '2000-02-02' 

--  4: Create the recommended index and check the execution plan for improvement



