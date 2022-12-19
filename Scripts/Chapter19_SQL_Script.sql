USE [Human_Resources];

/*
	Scripts and exercises used in Chapter 19
	
	This script file (Chapter19_SQL_Script.sql) is available for download in this lecture resources 

*/

/*
	Note : SQL Variables are named containers that can hold a ** data typed ** value for consumption in our SQL Scripts
		   most commonly used as input parameters to Stored Procedures.
		   
		   ** Syntax 
		   
		   DECLARE @LOCAL_VARIABLE[AS] data_type [= value]  ;
		  
		   DECLARE @LOCAL_VARIABLE[AS] data_type ;
	       SET @Local_Variable = <value>
		   
		   **
		   Display a variable immediately after Declarative and value setting !

		   PRINT @LOCAL_VARIABLE
		   SELECT @LOCAL_VARIABLE

		   SELECT @@GlobalVariable


*/
		   declare @MyName as varchar(80) = 'Paul S';	
		   print @MyName;

		   declare @Number as Int;
		   set @Number = '12345';
		   select @Number;

		   select @@VERSION,@@SERVERNAME;

		   select * from Employees;
		   select @@ROWCOUNT;

-- Exercise 19.1	Create 2 local variables
--					
--					1: Country - Datatype varchar(50) Value = 'Australia'
--					2: Gender  - Datatype char(1) 
--					   SET value = 'M'			
--
--
			declare @Country as varchar(50) = 'Australia';
			print @Country;

			declare @Gender as char(1);
			set @Gender = 'M';
			select @Gender;

			GO;
/*
			Note : The Stored Procedure is a batch of statements grouped as a logical unit and stored within
				   the database.

				   The Stored Procedure will accept parameters thus influencing the underlying behaviour of the
				   batch e.g. Select ... where column1 = @Parameter1, of course SP's can be used with Insert,Delete,Update as well.

				   # Used: In analytics there are products that benefit from using Stored Procedures as the primary means
						   to extract row sets for presentation on the report or dashboard e.g. SQL Server Reporting Services 
						   is best served with Stored Procedures, another product I have used is Logi Analytics this product
						   performs direct queries to the underlying data tables hence Stored Procedures provide a better 
						   solution for the product.

				   Some immediate benefits of the Stored Procedure are ...

				   * Easily modified: A developer or other team members without the need for recompiling or redeployment
				   
				   * Reduced network traffic: A Stored Procedure is executed on the server hence the whole SQL Batch is 
				     not passed over the network only the name of the procedure to execute

				   * Reusable: They can be executed by multiple users or multiple client applications

				   * Security: Stored Procedures eliminate direct access to the tables. They can also be encrypted.

				   * Performance: First time execution of the Store Procedure SQL Server creates a query plan that is
				                  optimized for best performance and the plan is stored for reuse next time the procedure is
								  run.

				Syntax using DDL
				----------------

				CREATE PROCEDURE ProcName @Param1 <Datatype>, @Param2 <Datatype>
				AS
				 SELECT
					COUNT(column)
					.
					.
					.
				 FROM
					Table1
				 WHERE
					Column = @Param1
				 Group by
				   column(s); 
                 GO;

				 To Execute a Stored Procedure
				 -----------------------------
				
				EXEC ProcName @Param1 = @Variable (or direct value e.g. 'ABC')
				
*/
			create procedure EmployeeCountCountry @Country varchar(50)
			AS
			 select
			  city,
			  count(sid_Employee) as Emp_Count
			 from
			  Employee_Location
			 where
			  CountryRegionName = @Country
			 group by								
			  city
			 order by
			  Emp_Count desc ;

			  exec EmployeeCountCountry @Country = 'Australia';

			  declare @Country_Input varchar(50) = 'France'	
			  exec EmployeeCountCountry @Country = @Country_Input;

go;

-- Exercise 19.2	Refer to your exercise 18.1 { Section 18 } and create a stored procedure {name it as you think it appropriate}
--					and adapt the code from that exercise to accept parameters.	
--
--					Do not use direct value inputs! Use variables instead.
--
--					Test the stored procedure by executing it 
--

			create procedure genderCountsByCountryStateCity @Country varchar(50) , @Gender char(1)
			AS
			select
				City,
				StateProvinceName,
				count(el.sid_employee) as Emp_Count
			from
				Employee_Location el inner join
				Employees emp on el.sid_Employee = emp.sid_Employee
			where
				CountryRegionName = @Country and
				emp.gender = @Gender
			group by
				City,
				StateProvinceName
			order by
				Emp_Count desc;

		   declare @Country_In varchar(50) = 'France' , @Gender_In char(1) = 'F'
		   exec genderCountsByCountryStateCity @Country = @Country_In, @Gender=@Gender_In
GO;

/*

			Note: The SQL SCHEMA is defined as a logical collection of database objects.
			
			CREATE SCHEMA SCHEMA_NAME AUTHORIZATION database_user

				CREATE <TABLE1 (...)>

				GRANT SELECT ON SCHEMA::SCHEMA_NAME TO Username

				DENY SELECT ON SCHEMA::SCHEMA_NAME TO Username

			GO;

			Security
			--------

			User  - Staff_Audit
			User  - Staff_Biz

*/
			create schema SECURE_AUDIT AUTHORIZATION dbo

			create table EMPLOYEES_AUDIT (sid_Employee int not null)

			grant select on SCHEMA::SECURE_AUDIT to Staff_Audit
			deny select on SCHEMA::SECURE_AUDIT to Staff_Biz

			go; 
/*
			Note: A Trigger has many uses , the scope of use is significant and is commonly observed in databases
				  that for example require tracking of DML,DDL,DCL type transactions.

				  DBA Tip: Performance should be monitored as Triggers have the potential to affect database performance
				           most particularly in high transaction environments e.g. Banking in which case other auditing
						   layers would be implemented!

			BASIC SYNTAX
			------------

			CREATE TRIGGER trigger_name ON TABLE_NAME 
			AFTER UPDATE,INSERT,DELETE				    <<--- When should the trigger fire 

			AS
			BEGIN

				SET NOCOUNT ON;							<<--- Suppress rows affected messages when trigger is fired

			   <INSERT into TABLE_NAME values >			<<--- Inserting rows into our tracking table e.g. Employees_Audit

			   <SELECT FROM INSERTED,DELETED>		    <<--- Retrieve Inserted/Deleted row(s) to insert into the tracking table 

			END;


*/
		
		-- Step 1 : Modify the EMPLOYEES_AUDIT TABLE ready to receive trigger event rows
		--			from DML actions on the Employees table
			
		ALTER TABLE [SECURE_AUDIT].[EMPLOYEES_AUDIT]
		ADD	 emp_no int NOT NULL,										
			 birth_date date NOT NULL,
			 first_name varchar(14) NOT NULL,
			 last_name varchar(16) NOT NULL,
			 gender char(1) NOT NULL,
			 sid_Date int NULL,
			 hire_date date NOT NULL,
			 /*
			  The below columns are Audit tracking details to use when/if an investigation into changes
			  are required or for other analysis etc
			 */
			 Operation char(3) NOT NULL,									  -- What action is recorded INS,UPD,DEL
		     Username varchar(16) NOT NULL,									  -- Populated by security function User_Name() in the Trigger
			 AuditDate datetime NOT NULL,									  -- When Date & Time the action took place
			 AuditID int Identity,											  -- An ID for tracking a sequence of events
		     CHECK(Operation = 'UPD' or Operation='INS' or Operation='DEL') ; -- Ensure correct value entered for the operation via a CHECK constraint

GO; -- This just tells SQL the batch has ended , do not run this as part of the script it will error !			

	-- Step 2 : Create a Trigger on the Employees table	for INSERT and DELETE activity

		CREATE TRIGGER dbo.trg_Employees_Ins_Del_Audit
		ON dbo.Employees
		AFTER INSERT,DELETE
		AS
		BEGIN
		  SET NOCOUNT ON;														-- Suppress the number of rows affected messages from being returned whenever the trigger is fired
		  INSERT INTO SECURE_AUDIT.EMPLOYEES_AUDIT
           (
		    sid_Employee
		   ,emp_no
           ,birth_date
           ,first_name
           ,last_name
		   ,gender
           ,sid_Date
           ,hire_date
		   ,Operation
		   ,Username
		   ,AuditDate  
		   )
		SELECT [sid_Employee]
			  ,[emp_no]
			  ,[birth_date]
			  ,[first_name]
              ,[last_name]
              ,[gender]
              ,[sid_Date]
              ,[hire_date]
			  ,'INS'
			  ,(select User_Name())
			  ,Getdate()
		FROM 
			INSERTED as I

		UNION ALL

		SELECT [sid_Employee]
			  ,[emp_no]
			  ,[birth_date]
			  ,[first_name]
              ,[last_name]
              ,[gender]
              ,[sid_Date]
              ,[hire_date]
			  ,'DEL'
			  ,(select User_Name())
			  ,Getdate()
		FROM 
			DELETED as D
		END;

	select * from SECURE_AUDIT.EMPLOYEES_AUDIT;

	GO;
		-- Step 3 : Create a Trigger on the Employees table	for UPDATE activity

		CREATE TRIGGER dbo.trg_Employees_Upd_Audit
		ON dbo.Employees
		AFTER UPDATE
		AS
		BEGIN
		  SET NOCOUNT ON;														-- Suppress the number of rows affected messages from being returned whenever the trigger is fired
		  INSERT INTO SECURE_AUDIT.EMPLOYEES_AUDIT
           (
		    sid_Employee
		   ,emp_no
           ,birth_date
           ,first_name
           ,last_name
		   ,gender
           ,sid_Date
           ,hire_date
		   ,Operation
		   ,Username
		   ,AuditDate  
		   )
		
		SELECT [sid_Employee]
			  ,[emp_no]
			  ,[birth_date]
			  ,[first_name]
              ,[last_name]
              ,[gender]
              ,[sid_Date]
              ,[hire_date]
			  ,'UPD'
			  ,(select User_Name())
			  ,Getdate()
		FROM 
			DELETED 
UNION ALL
			SELECT [sid_Employee]
			  ,[emp_no]
			  ,[birth_date]
			  ,[first_name]
              ,[last_name]
              ,[gender]
              ,[sid_Date]
              ,[hire_date]
			  ,'UPD'
			  ,(select User_Name())
			  ,Getdate()
		FROM 
			INSERTED 
		END;

	select * from SECURE_AUDIT.EMPLOYEES_AUDIT;

--	Exercise 19.3	 -- Senior auditor has requested an Audit Tracking table be constructed to track if updates are 
--					    performed on the Current Personnel table 
--					 
--						Change to track is Updates to the Current_Salary
--					    Attributes to include in the Current_Personnel_Audit table are ...
--
--						sid_Employee, emp_no, current_salary , the tracking attributes as shown in the previous lecture
--
--					    Tip : Right mouse click on current personnel to generate a create table script for the basis 
--							  of the CREATE TABLE code
--						
--							  Make sure you replace the dbo. schema with SECURE_AUDIT schema in the create table code!

   
 
--  Solution Step 1: Create the Audit Table 
  
			CREATE TABLE SECURE_AUDIT.CURRENT_PERSONNEL_AUDIT(
			[sid_Employee] [int] NOT NULL,
			[emp_no] [int] NOT NULL,
			[current_salary] [int] NOT NULL,
			Operation char(3) NOT NULL,									      -- What action is recorded INS,UPD,DEL
			Username varchar(16) NOT NULL,									  -- Populated by security function User_Name() in the Trigger
			AuditDate datetime NOT NULL,									  -- When Date & Time the action took place
			AuditID int Identity,											  -- An ID for tracking a sequence of events
			CHECK(Operation = 'UPD' or Operation='INS' or Operation='DEL')	  -- Ensure correct value entered for the operation via a CHECK constraint 
			) ; 
  
 GO; 

   --	Solution Step 2: Create the Trigger

		CREATE TRIGGER dbo.trg_Current_Personnel_Audit
		ON [dbo].[Current_Personnel]
		AFTER UPDATE
		AS
		BEGIN
		  SET NOCOUNT ON;														-- Suppress the number of rows affected messages from being returned whenever the trigger is fired
		INSERT INTO [SECURE_AUDIT].[Current_Personnel_Audit]
           ([sid_Employee]
           ,[emp_no]
           ,[current_salary]
           ,[Operation]
           ,[Username]
           ,[AuditDate])

		
		SELECT [sid_Employee]
			  ,[emp_no]
			  ,current_salary
			  ,'UPD'
			  ,(select User_Name())
			  ,Getdate()
		FROM 
			DELETED 

		UNION ALL
	
		SELECT [sid_Employee]
			  ,[emp_no]
			  ,current_salary
			  ,'UPD'
			  ,(select User_Name())
			  ,Getdate()
		FROM 
			INSERTED 
		END;   
   

   select * from [SECURE_AUDIT].[CURRENT_PERSONNEL_AUDIT];
   GO;
   
/*
		*** NO EXERCISE FOR THIS LECTURE *** you are encouraged to try these out using the data provided.

		Note: So far in the course we have explored ...

			  Date functions		e.g. Datediff(),GetDate(),Datepart,Year(),Month()
			  Other functions		e.g. Cast(),@@Rowcount
			  Security functions	e.g. User_Name()
			  Aggregation functions	e.g. Count(),Sum(),Avg() etc

			  Hence you are now aware of the power of the System functions, lets review some String Functions that are
			  available to us that I commonly use when wrangling data for analysis.		
			  
			  Introducing String Functions ...

			  len(of what)									: Returns the number of characters in a given string
			  Left(of what, how many)						: Returns the left-most specified number of characters from a character expression 
			  Charindex(search for, search in, start at)	: Returns the Starting position of a specified expression in a given string 
			  Replace(search what,for what,replace with)	: Replaces all occurrences of the second expression in the first expression with a third expression 
															  I think a lawyer wrote these syntax help texts/popups :)	
*/
			  -- Len()										  Returns the number of characters in a given string   

			  select
				emp_no,
				len(last_name) as LengthOfName
			  from
				Employees;

			  select max(len(last_name)) from Employees;

			  -- Left()										  Returns the left-most specified number of characters from a character expression 

			  select
				emp_no,
				first_name,
				last_name,
				left(first_name,1) as Initial
			  from
				Employees;

			 select
				emp_no,
				first_name,
				last_name,
				left(first_name,1) as Initial,
				left(first_name,1) + '. ' + last_name as AbbreviatedFullName
			  from
				Employees;
  
			  -- Charindex()								  Returns the Starting position of a specified expression in a given string 

			  select
				*
			  from
				Current_Personnel
			  where
				CHARINDEX('N.',current_location) >0

			 
			 -- Replace()									   Replace(search what,for what,replace with)

			select
				emp_no,
				current_location,
				replace(current_location,'N.','North ') as AdjustedLocation
			from
				Current_Personnel
			where
				CHARINDEX('N.',current_location) >0

GO;

/*
		User Defined Function (UDF)
			
		Note : The SQL scalar function takes 1 or more parameters and returns a single value 
			   
		SYNTAX
		======

		CREATE FUNCTION [schema_name.]function_name (parameter_list)
		RETURNS data_type AS
		BEGIN
			RETURN value <<<--- This is the sql code that produces the output
		END;


*/

	  Select
		emp_no,
		first_name,
		last_name,
		datediff(YEAR,Birth_Date,GetDate()) as Age
	  from
		employees;

GO;

	create function udfEmpAgeYears (
		@Birthdate date
	) 
	returns Int
	as
	begin
		return datediff(YEAR,@Birthdate,GetDate()) 
	end;

	Select
	 emp_no,
	 first_name,
	 last_name,
	 dbo.udfEmpAgeYears(birth_date) as Age
	from
	 employees;

--	Exercise 19.4 The team leader has requested a udf to be created that calculates the number of years
--				  the employee has worked for the company
--
--				  Hint : Employee Hire Date


	  Select
		emp_no,
		first_name,
		last_name,
		datediff(YEAR,hire_date,GetDate()) as YearsInService
	  from
		employees;

GO;

	create function udfYearsInService (
		@Hiredate date
	) returns int
	as
	begin
		return datediff(YEAR,@Hiredate,GetDate())
	end;

	
	Select
	 emp_no,
	 first_name,
	 last_name,
	 dbo.udfYearsInService(hire_date) as YearsInService
	from
	 employees;

	 /*
		User Defined Function (UDF)
			
		Note : The SQL table function will return a table 

			 Why use one ?

							* More flexible than a view as it can be paramaterised 

							* Abstracts/Hides 

									- Underlying tables from user or application view (e.g. Web page)
									- Complex code
									- Reusablility and convenience

							* Treat it like any other table e.g can be included in joins
			   
		SYNTAX
		======

		CREATE FUNCTION [schema_name.]function_name (parameter_list)
		RETURNS TABLE 
		AS
		RETURN 
			<SQL Script>;

*/

		SELECT emp_no
			  ,first_name
			  ,last_name
			  ,emp.gender
			  ,gender_name
		  FROM 
			  Employees emp inner join
			  Gender gen on emp.gender = gen.gender 
		  where
			 emp.gender = 'M'
		  order by
			emp_no;

GO;

		create function udfGenderEmpTable (
			@Gender char(1)
		)
		RETURNS TABLE
		AS
		RETURN
		 SELECT emp_no
		 	   ,first_name
			   ,last_name
			   ,emp.gender
			   ,gender_name
		  FROM 
			  Employees emp inner join
			  Gender gen on emp.gender = gen.gender 
		  where
			 emp.gender = @Gender;

 go;

		select
		*
		from dbo.udfGenderEmpTable('F')

-- Exercise 19.5 You are at an interview to join the DA team and as part of the interview process
--				 they have requested that you convert the below query to be a Table function	
--
--				 The country and gender conditions must be parameterised 
--
--				 Tip : Function naming and param naming are open to your creativity
--					   Ensure your param datatypes match column data types precisely
--				 
	
		select
			City,
			StateProvinceName,
			count(el.sid_employee) as Emp_Count
		from
			Employee_Location el inner join
			Employees emp on el.sid_Employee = emp.sid_Employee
		where
			CountryRegionName = 'United States' and
			emp.gender = 'M'
		group by
			City,
			StateProvinceName
		order by
			Emp_Count desc;

go;

		create function udfEmpLocationCount (
			@Country nvarchar(50), @gender char(1)
		)
		RETURNS TABLE
		AS
		RETURN
		 select
			City,
			StateProvinceName,
			count(el.sid_employee) as Emp_Count
		from
			Employee_Location el inner join
			Employees emp on el.sid_Employee = emp.sid_Employee
		where
			CountryRegionName = @Country and
			emp.gender = @Gender
		group by
			City,
			StateProvinceName;
go;

	select * from dbo.udfEmpLocationCount('United States','M') order by 1