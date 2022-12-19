USE Human_Resources;

/*

	Scripts and exercises used in Chapter 15
	
	This script file (Chapter15_SQL_Script.sql) is available for download in this lecture resources 

	*** Warning to Student ***

	IT IS recommended you backup your database just in case Updates go wrong and you destroy/corrupt your
	data which will affect future lecture presentations and exercises as well as your earlier work !

	We do backups a lot in our day to day work!

*/

/*

	UPDATE table1
	SET
		table1.Column = table2.value
	FROM
		table1 alias1 INNER JOIN
		table2 alias2 on alias1.column = alias2.column
	WHERE
		table1 = condition

	Tip : Leave the SET statement column reference until the last thing to code 
		  Just in case you run the update and forget the Where condition as this
		  results in the whole table being updated and then you need to restore
		  the backup!

*/

-- Scenario - The column sid_Location for employee 10021 in Current_Personnel has a NULL
--			  value we have been tasked with rectifying the issue.
-- 
--			  How to do this ?

--		      Step 1 : Review the attributes of the target table i.e. Current Personnel

--			  Step 2 : Review tables in the database to reveal the Source of Truth for sid_Location i.e. Geography

--			  Step 3 : Evaluate if there is a column in the target table that can be the key to querying the 
--					   Source of Truth table , yes there is ; current_location; which is the city value in Geography

--			  Step 4 : Does the current_location value exist in the Geography table ?

				select * from Current_Personnel where sid_Employee=21;
				select * from Geography where City = 'Dunkerque';

--			  Step 5 : Construct & Test a Join Query to reveal the sid_Location from the Geography table which cane be used
--					   for the update

			 select
			 
			 *
			 from
				Current_Personnel cp inner join
				Geography geo on geo.City = cp.current_location
			 where 
				sid_Employee = 21;
	
--			  Step 6 : Bring it all together in an Update script to repair the column in Current_Personnel

			 update Current_Personnel
			 set sid_location = geo.sid_Location

			 from
				Current_Personnel cp inner join
				Geography geo on geo.City = cp.current_location
			 where 
				sid_Employee = 21;

--			  Step 7 : Check the update worked !

			select * from Current_Personnel where sid_Employee=21;

	-- Exercise 15.1 The Payroll manager has profiled the NEW_PAY_RUN table and has noted
	--				 the sid_Date is not correct for the Pay_Date value, she has requested it should 
	--				 be updated. 
	--
	--				 Tip : Use a Join to update the sid_date to the correct value
	--					   Think like an analyst :) Use the steps !


--			  Thinking like an analyst solves this scenario ...

--		      Step 1 : Review the attributes of the target table i.e. NEW_PAY_RUN

--			  Step 2 : Review tables in the database to reveal the Source of Truth for the sid_date value

--			  Step 3 : Evaluate if there is a column in the target table that can be the key to querying the 
--					   Source of Truth table 

--			  Step 4 : Does the sid_date value exist in the SOT ?
			  select top 5 * from NEW_PAY_RUN;
			  select * from Calendar where sid_date=72830;
			  select * from Calendar where Cal_Date = '2019-12-07'; 

--			  Step 5 : Construct & Test a Join Query to reveal the sid_date from the SOT table which can be used
--					   for the update

			  select 
				*
			  from
				NEW_PAY_RUN nr inner join
				Calendar cal on cal.Cal_Date = nr.Pay_Date;

--			  Step 6 : Bring it all together in an Update script to repair the column in NEW_PAY_RUN

			  Update NEW_PAY_RUN 
			  set sid_Date = cal.sid_date
			  from
				NEW_PAY_RUN nr inner join
				Calendar cal on cal.Cal_Date = nr.Pay_Date;

--			  Step 7 : Check the update worked !
		
			select * from NEW_PAY_RUN;

/*

			We can change the data type of a value to another data type as we query the data by using the Cast() function

			You will encounter this when extracting data from different sources and the data types are not conformed to 
			the target table e.g. A table column in a Data Warehouse
			
			Select
				column(s),
				cast(column as datatype) as alias
			from
				table
			where 
				condition

*/

	-- Scenario : A request has been received to modify the Employee_Movements_History table and add a new
	--			  column of integer data type named sid_EmpDepLookup that will contain a concatenation of the sid_Employee 
	--			  and sid_Department
	--
	--			  These columns are both integer values and the resulting value should not be an aggregation 
	--

	update Employee_Movements_History
	set sid_EmpDepLookup = cast(cast(sid_Employee as varchar(8)) + cast(sid_Department as varchar(8)) as int)

	select top 1 * from [dbo].[Employee_Movements_History]

-- Exercise 15.2 The Payroll manager has reviewed the sid_Date value in the New_Pay_Run table but has
--				 noted the sid_Payrun_Ref_Key is not correct and requires the key to be updated for all
--				 payrun records 
--
--				 Tip: Use the Cast function to update the key value
--					  Ensure you cast to the correct data type of the target column

	update NEW_PAY_RUN 
	set sid_Payrun_Ref_Key =  cast(cast(sid_employee as varchar(8)) + cast(sid_Date as varchar(8)) as bigint)

	select top 5 * from NEW_PAY_RUN; 

/*
		TCL - Transaction Control Language
	
		Begin Transaction	(Explicitly start a transaction aka Get Ready, Get Set , Go ... )					
		update 
			Table 
			set Column = a value
			.
			.
		where
			condition ...

		Commit		(e.g. No error or other condition that affects the outcome of the Transaction)
		Rollback	(e.g. If an error encountered then rollback)

*/

		begin transaction
		update NEW_PAY_RUN
		set Pay_Amount = 7014
		where 
			sid_employee=21
		commit;

		select top 5 * from NEW_PAY_RUN;


-- Exercise 15.3 The HR manager has requested all of the records in the Employee Location table
--				 that have a sid_Location of Null should be updated to be the value 0 , just before the
--				 change is made we should call him and get the go ahead for the change!
--				 
--				 HR manager made an error and requested it should not be changed after all
					
		
		begin transaction
		update Employee_Location
		set sid_Location = 0
		where sid_Location is null;
		rollback;

		select top 10 * from Employee_Location;

		begin transaction
		update Employee_Location
		set sid_Location = 0
		where sid_Location is null;
		commit;

		select top 10 * from Employee_Location;






















--				 Then they called back and said ok make the change after all !



