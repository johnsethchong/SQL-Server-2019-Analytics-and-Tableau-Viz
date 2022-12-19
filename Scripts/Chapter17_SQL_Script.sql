USE Human_Resources;

/*

	Scripts and exercises used in Chapter 17
	
	This script file (Chapter17_SQL_Script.sql) is available for download in this lecture resources 
	
*/


/*

		Note : The Primary Key constraint is defined to uniquely identify each record in a table
		
			   The key will have 1 or more columns to define the uniqueness and this is based on a 
			   use case that has been identified as part of the data model design.

			   Multiple columns can also be concatenated into a single value (to build the uniqueness) this is 
			   known as a Compound Key which can then be set as a Primary key.

			   The Compound key value is usually precalculated and written to the Primary column as part of 
			   an insert statement in a OLTP database or data warehouse for example.

			   How do we create primary keys ?

			  1:	CREATE TABLE TableName (
						  ColumnName <type> NOT NULL PRIMARY KEY,
						  Column(s)...
								  		   );
			  2:	Using the Database Diagrams feature (This is buggy and unreliable)												
	
			  3:	The Design options (Right Mouse menu) for the table

				Tip: A primary key will always have a NOT NULL Constraint
					 There is only 1 Primary key permitted on a table
					 A primary key must be defined on a table in order to be part of a relationship i.e. PK-FK

*/

--			Exercise 17.1 As part of a rationalisation of the database model design and data integrity project
--						  the Data Architect has asked for a Primary key to be created on the Departments table
--						  but has not specified which column as such is it up to you to think about a candidate
--						  column and then create a PK.

			-- Introducing the INFORMATION_SCHEMA , use these views to discover your SQL Server metadata :)

			select
			*
			from 
				INFORMATION_SCHEMA.COLUMNS
			where
				COLUMN_NAME IN ('sid_Department','dept_no','dept_name') and
				TABLE_NAME <> 'Departments'
			order by
				TABLE_NAME;


--			Exercise 17.2 As part of the current rationalisation of the database model design and data integrity project
--						  the Data Architect has asked for...
--
--					  1: A Foreign key constraint to be created on the Current_Personnel
--						 to ensure the department value is correct whenever an Insert or Update takes place.
--
--					  2: The Data Architect has requested that the Customer Service department be removed from the Departments 
--						 table
--
--			Tip : Ensure the Foreign Key constraint is defined first !!

			select * from Departments;
			
			-- Demonstrates the foerign key protects data in the Parent table as well as the child

			begin transaction
			delete from Departments
			where sid_Department=9;
			rollback;

/*

			The DEFAULT constraint is used to populate a column value when no other
			value has been specified.

			CREATE TABLE Table1 (
			 Column1 datatype NOT NULL,
			 .
			 .
			 Column4 datatype DEFAULT value
								);

			ALTER TABLE Table1
			ADD CONSTRAINT name DEFAULT value FOR column ;

			ALTER TABLE Table1
			ALTER COLUMN column DROP DEFAULT;

*/

			select * from managers;

			insert into managers(sid_Employee,to_date)
			values(100617,'9999-01-01')

			select * from managers order by 1;

--			Exercise 17.3 The HR Manager has request the following new employee is added to the Employees table
--						  EmpNo = 500000 , birthdate = '1970-10-04' , last name = 'Jones' , gender = 'M' 
--
--			Note : The HR manager did not specify the First Name and Hire Date as she was in a hurry
--		
--				   As such you have decided to specify a DEFAULT constraint to place a value in these columns
--				   you have decided the DEFAULT for First Name = 'Not Provided' and the Hire Date = Today
--
--			Tip:	Ignore sid_Employee in your INSERT as this will be created by the system
--					Ignore the sid_Date value for now unless see below ... 
--
--			Extra Curricular : If you like to practice and who doesn't then update the sid_Date value by 
--							   building a JOIN in the INSERT as we have seen in Advanced Inserts to the
--							   calendar table for todays date and share your code with the class cohort in
--							   lecture solution Q&A, showcase your skills :)

			insert into Employees(emp_no,birth_date,last_name,gender)
			values(500000,'1970-10-04','Jones','M')

			select * from Employees where emp_no=500000;

/*

			The CHECK constraint is used to specify the data values that are acceptable in 1 or more columns ;  this is useful when a business rule
			must be enforced for a column e.g. A value range. 

			CREATE TABLE Table1 (
			 Column1 datatype NOT NULL,
			 .
			 .
			 Column4 datatype CHECK (condition) value
								);

			ALTER TABLE Table1
			ADD CONSTRAINT name CHECK (condition) ;

			ALTER TABLE Table1
			DROP CONSTRAINT name;

*/
			insert into NEW_PAY_RUN(sid_employee,Pay_Amount,Pay_Date)
			values(300025,-1,'2020-02-19')

--			Exercise 17.4 The Data Manager has requested there is a business rule applied to the table
--						  Current Personnel to ensure the Current Salary does not exceed $200,000
--
--						  The new employee 300025 should be added to the Current Personnel with the following detail
--
--						  Emp No = 500000 , current salary = 150000 , sid_Department = 12 
--
--						  Outcome ?
--						

			insert into Current_Personnel(sid_Employee,emp_no,current_salary,sid_Department)
			values(300025,500000,150000,12);

			select * from Current_Personnel where sid_Employee= 300025;

/*

			By default a column (of any data type) can contain a NULL value

			Sometimes we want to ensure column never contains a NULL as such we can
			specify a NOT NULL constraint on a table column.

			Note : There is no exercise for this lecture!

			CREATE TABLE table1(
			 column1 datatype NOT NULL
			 .
			 .
			 );

			 alter table table1
			 alter column column1 datatype NOT NULL;


*/

			insert into NEW_PAY_RUN(sid_employee,Pay_Amount,Pay_Date)
			values(300025,9000,'2020-02-19')