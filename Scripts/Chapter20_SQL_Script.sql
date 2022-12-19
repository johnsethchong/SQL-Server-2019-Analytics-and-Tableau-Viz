USE [Human_Resources];

/*
	Scripts and exercises used in Chapter 20
	
	This script file (Chapter20_SQL_Script.sql) is available for download in this lecture resources 

*/

/*
		Note : The WHILE statement sets a condition for a repeated execution of an SQL Statement or statement block
			   The statements are executed repeatedly as long as the specified condtions is true	

		SYNTAX
		======

		WHILE Boolean_expression							* Is an expression that returns TRUE or FALSE.
			 { sql_statement | statement_block				* Is any Transact-SQL statement or statement grouping as defined with a statement block (i.e. BEGIN ... END)
			 | BREAK |										* Causes an exit from the innermost WHILE loop
			 CONTINUE }									    * Causes the WHILE loop to restart, ignoring any statements after the CONTINUE keyword

        
		* Introducing the TABLE Variable	

		SYNTAX
		======

		Declare @VariableName TABLE (fieldlist)


		* Introducing the IF statement

		SYNTAX
		======

		IF Boolean_expression   
			 { sql_statement | statement_block }   
		[ ELSE   
			 { sql_statement | statement_block } ]   



*/

		-- Basic while loop using a variable to track the loop progress

		declare @Counter int = 1

		while @Counter <= 25
		begin
			print @Counter
			set @Counter = @Counter + 1;
		end;

go;
					
		-- Scenario : Insert a list of week numbers and the start dates into a Table Variable
		--            Steps to assist with work flow


	    -- Step 1: Declare the TABLE Variable with required columns
		declare @myTable TABLE(WeekNum int,WeekStartedOn date)
			
		-- Step 2: Declare the working variables

		declare @n int = 1                          -- Week 1 will start in January 2019 hence the below date is the starting base date is end of december 2018
		declare @FirstWeek date = '2018-12-31'
			
		-- Step 3: Set the WHILE Statement and variable to test
		WHILE @n > -1								-- Loop until the counter reaches 52 , starting at week 1	

		-- Step 4: Open a BEGIN ... END block

		BEGIN
				Insert into @myTable (WeekNum,WeekStartedOn)
				select
					@n,
					DATEADD(wk,@n,@FirstWeek)	    -- Adding 1 week to '2018-12-31' results in 2019-01-07 
				
				select @n = @n + 1					-- Increment the counter the WHILE condition is based on

				If @n > 52 BREAK					-- Once we reach 52 weeks then stop the loop

		END ;

		select * from @myTable;						-- Once we reach 52 weeks then stop the loop

		go;
		-- Step 5: Write the INSERT into the TABLE vairable Nb: Same as a normal insert
		-- Step 6: Increment the Counter for out WHILE loop
		-- Step 7: Test the counter and if condition is met then exit (BREAK)
		-- Step 8: Select from the TABLE Variable to observe the results

   
    /* Introducing the EOMONTH() function

		Note: This function returns the last day of the month containing a specified date, with an optional offset.		

	   SYNTAX
       ------- 
	   EOMONTH ( start_date [			 	A Date expression that specified the date for which to return the last day of the month
				, month_to_add ] )		    An optional integer expression that specifies the number of months to add to start_date
										    e.g. 1 then EOMONTH adds the specified number of months to start_date, and then returns 
											       the last day of the month for the resulting date.
    */

	select top 1 eomonth(sal_from_date) from Salary_History
	

go;
/*
	Exercise 20.1	
	Scenario		The DA team leader has requested a TABLE Function be created

					Requirements for the Table Function ...

					1: A Single date input param for MonthEnd e.g. 2016-01-31	Parameter name suggested e.g. @MonthEnd
				    
					2: A single column that is the Sum of Salary (in dollars) from the Salary History table, the Column Name suggested e.g  TotalSalary

					3: The selection predication for the query ...

						a) Month End (as this is supplied by the caller) & you'll need to use EOMONTH() for the condition
						   The date field to test the month end must be the salary from date

						b) The year() of salary from date = 2016 and 
							   year()   of salary to date = 2016             -- We are only interested in 2016 overall i.e. Salary levels for 2016

				    Tip : Build up a query first of all then tackle theTable function then if anything does not work properly
					      at least you know it's not the query component.

					Hint : If your rowset matches the below then you are solving the requirement

*/	

	-- 20.1 TABLE Function Solution 

	-- 1: Create the function and param
		CREATE Function udfTableTotalSalary2016 (
					    @MonthEnd date		    )
		RETURNS TABLE
		AS
		RETURN

	-- 2: Write the Query Body

	   select 
		 EOMONTH (sal_from_date) as MonthEnded,
		 format(sum(current_salary),'C0') as TotalSalary
		from
		  [dbo].[Salary_History]
		where
		  EOMONTH (sal_from_date) = @MonthEnd and
		  year(sal_from_date) = 2016 and
		  year(sal_to_date) = 2016
		group by
		 EOMONTH (sal_from_date);

go;

	  select * from dbo.udfTableTotalSalary2016('2016-01-31');

go;

/*
	Exercise 20.2	
	Scenario		The DA team leader has requested that the TABLE function be added to a WHILE loop
					as part of a rowset to populate a Table Variable that holds the total salaries 
					for each month of the year of 2016. 

					Requirements for the WHILE loop are ...

					1: Table variable with 3 fields to accommodate

							a. Month Number
							b. Month End Date
							c. Salary
					
					Tips:

					a) The WHILE Loop code will be very close to the one you were shown in the lecture
					   except we use months not weeks 
					
					b) To call the TABLE function as part of the INSERT you will need to do it 
					   as a Sub-Query & use the date function as the input argument (Parameter)

				    c) Use the Money data type for the Salary column
					
					d) Take note the format of the Salary that has been output 

*/	

			-- 20.2 WHILE Loop Solution 

				-- Step 1: Declare the TABLE Variable with required columns		
					DECLARE @mySalaryTable TABLE(MonthNumber int,
												 MonthEnded date,
								                 TotalSalary Money)

				-- Step 2: Declare the working variables
					DECLARE @n int = 1								-- Month 1 end will be in January 2016 hence the below date 31 Dec 2015 is the base date
					DECLARE @EndOfMonth date = '2015-12-31'

				-- Step 3: Set the WHILE Statement and variable to test
					WHILE @n > -1									-- Loop until the counter reaches 12 , starting at Month 1		

				-- Step 4: Open a BEGIN ... END block
					BEGIN

				-- Step 5: Write the INSERT into the TABLE variable Nb: Same as a normal insert
					 INSERT INTO @mySalaryTable (MonthNumber,MonthEnded,TotalSalary)	
					 SELECT
						   @n, 
			  			   DATEADD(MM,@n,@EndOfMonth) ,		-- Adding 1 month to '2015-12-31' results in 2016-01-31 			
						  (select TotalSalary from dbo.udfTableTotalSalary2016(DATEADD(m,@n,@EndOfMonth)));  -- Query the Total Salary from the TABLE Function							 

				-- Step 6: Increment the Counter for our WHILE loop
						  SELECT @n = @n + 1								-- Loop until the counter reaches 12 , starting at Month 1	

				-- Step 7: Test the counter and if condition is met then exit (BREAK)

						  if @n > 12 Break

					END


				-- Step 8: Select from the TABLE Variable to observe the results

					select MonthNumber,MonthEnded,format(TotalSalary,'C0') from @mySalaryTable;


/*
				
				Note : The EXISTS operator is a logical operator that will check whether a sub-query contains any rows,
				       the operator will return TRUE if the sub-query contains any rows
			  
				   
			    SYNTAX
				======

				Select
					column ...
				From
					Table
				where
					EXISTS (sub-query)
			    Group by
				  ...
				Order By
				  ...

*/

		-- Scenario : The company Career Strategy Consultant has requested a list of employees who have held more than
		--			  one position during their career with the company


		select
			emp_no,
			first_name,
			last_name
		from
			Employees emp
		where
			exists ( 

				select
					count(sid_Employee)
				from
					Employee_Position_History
				where
					sid_Employee = emp.sid_Employee
				having
					count(sid_Employee) > 1
			);
		
		select * from Employee_Position_History where emp_no=10012;


		-- Exercise 20.3 
		
		-- Scenario : The CEO has requested insight into employees that have had more than 3 salary movements 
		--			  during their time with the company 
		
		--			  List the emp no, full name, salary start and end dates, salary amount in $
				
		--			  Ordered by the Employee Number (or ID) and Salary Start Date descending so that we can see 
		--			  the highest salary first


		select
		 emp.emp_no,
		 first_name + ' ' + last_name as FullName,
		 sh.sal_from_date as SalDateFrom,
		 sh.sal_to_date as SalDateTo,
		 format(sh.current_salary,'C0') as Salary
		from
			Employees emp inner join
			Salary_History sh on emp.sid_Employee = sh.sid_Employee
		where
			exists ( 
					
					select
						count(sid_employee)
					from
						Salary_History
					where 
						sid_Employee = emp.sid_Employee
					having 
						count(sid_Employee) > 3
			
			)
		order by
			emp.sid_Employee,
			sh.sal_from_date desc,
			sh.sal_to_date