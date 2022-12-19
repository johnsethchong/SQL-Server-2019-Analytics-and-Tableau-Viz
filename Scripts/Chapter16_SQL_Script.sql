USE Human_Resources;

/*

	Scripts and exercises used in Chapter 16
	
	This script file (Chapter16_SQL_Script.sql) is available for download in this lecture resources 

	*** Warning to Student ***

	IT IS recommended you backup your database just in case Deletes go wrong and you destroy/corrupt your
	data which will affect future lecture presentations and exercises as well as your earlier work !

	We do backups a lot in our day to day work!

	USE Transactions for Delete operations where possible !

	Nb: There are no student exercises for this section, you can practice by following the code as demonstrated

*/

/*
			The Delete statement is used to delete existing records from a table.
			
			Begin Transaction

			DELETE FROM 
				table_name 
			WHERE 
				condition

			Rollback / Commit


*/
		select * from Salary_History where current_salary > 100000	

		begin transaction
		delete from Salary_History
		where current_salary>100000

		select * from Salary_History where current_salary > 100000	

		rollback;

		select * from Salary_History where current_salary > 100000	

/*
		TRUNCATE TABLE table_name

		Removes all rows from a table without logging the individual row deletions. 

		TRUNCATE TABLE is similar to the DELETE statement with no WHERE clause; 
		however, 
		
		TRUNCATE TABLE is faster as it does not delete row by row like a Delete does
		hence it uses fewer system and transaction log resources.

		Caveat : This cannot be run inside a transaction hence it can be a disaster if you do not have a backup.


*/

		truncate table [employees copy]

		select * from [Employees Copy]



