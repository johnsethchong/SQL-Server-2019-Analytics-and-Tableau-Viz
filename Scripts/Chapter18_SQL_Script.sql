USE Human_Resources;

/*

	Scripts and exercises used in Chapter 18
	
	This script file (Chapter18_SQL_Script.sql) is available for download in this lecture resources 

	Terminology : Quants (Jargon) - Quantitive Analyst 
	
				  When working as a Data Analyst, Data Scientist, BI Developer, ETL Engineer ... you will deal with these terms when working with
				  Data Warehouses for example.
				  	
				  Dimensions are attributes that categorise a fact (or object)
				  For example an Employee is located in a city, earns $x , has a job title etc

				  Facts are attributes that define some event e.g. The employee was paid $x on a pay day, they transferred from one department to another	  

*/

/*

				Notes: The Count() function will return the number of rows that matches some criteria, of course a criteria is not mandatory
				       a count can just simply be count with no condition(s).

			    SELECT
					COUNT(column)
					.
					.
					.
				FROM
					Table1
				WHERE
					condition
				Group by
				   column(s);


			Scenario : Provide insight into the number of employees working in Australian cities.	


*/
			select
				city,
				count(sid_Employee) as Emp_Count
			from
				Employee_Location
			where
				CountryRegionName = 'Australia'
			group by								--<<-- The GROUP BY statement groups rows that have the same values into summary rows, the summary row here will be the City !
				city
			order by
			--	count(sid_Employee) 
			Emp_Count desc;
	

--		Exercise 18.1	The HR Manager requires insight into the Male employees working in the United States   
--						by city and state
--
--					    Tip: Use your knowledge gained for joins 
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

/*

				Notes: The Count(distinct column) function will return the number of unique non-null values in a table. 

			    SELECT
					COUNT(distinct column)
					.
					.
					.
				FROM
					Table1
				WHERE
					condition
				Group by
				   column(s);
				   
			Scenario : How many unique employees are recorded in Salary History

*/
			
				select
					count(distinct emp_no) as Emp_Count
				from
					Salary_History;


--		Exercise 18.2 The Data Architect would like to view the unique counts of departments in the Employee Movements History
--				      compared to the department count in the departments table as he suspects dirty data exists 
--
--					  Tip: a) A join is required
--						   b) The departments sid_Department count will behave not as you expect it to


				select
					count(distinct emh.dept_no) as emh_dept_count,
					count(distinct dep.dept_no) as dep_dept_count
				from
					Employee_Movements_History emh inner join
					Departments dep on emh.sid_Department = dep.sid_Department;


				select distinct(dept_no) from Employee_Movements_History order by 1;
				select * from Departments;

/*

				Notes: The SUM(column) function will return the sum of all values (or only the Distinct values) in the expression 

			    SELECT
					SUM(column)						--<<<< Only a numeric column 
					.
					.
				FROM
					Table1
				WHERE
					condition
				Group by
				   column(s);
				   
			Scenario : What is the total salary value of all employees currently working for the company

*/
				select
					sum(cast(current_salary as decimal(18,2))) -
					sum(distinct cast(current_salary as decimal(18,2)))
				from	
					Current_Personnel;

				select
					sum(distinct cast(current_salary as decimal(18,2)))
				from	
					Current_Personnel;

--		Exercise 18.3 The Payroll manager has requested insight into the California (United States) Payroll for July,August,September that details 
--					  Full Employee Name, Pay Amount in $
--
--					  Tip : The data in Employee Payroll is for the year 2019 hence no requirement to 
--							specify a year for these months.
--
--							Pay attention to the Group By clause as it does not behave like the order by column references!
--
--
		
			select
				emp.first_name +  ' ' + emp.last_name as FullName,
				format(sum(ep.Pay_Amount),'C') as PayAmount
			from
				Payroll.Employee_Payroll ep inner join
				Employees emp on ep.sid_Employee = emp.sid_Employee inner join
				Employee_Location el on ep.sid_Employee = el.sid_Employee and
														  el.StateProvinceName = 'California'
			where
				datename(month,Pay_Date) in ('July','August','September')
			group by
				emp.first_name , emp.last_name 
			order by 
				FullName

/*

				Notes: The AVG(column) function will return the Average of the values in a group {or only the Distinct values} Nb: Nulls are ignored 	  

			    SELECT
					AVG(column)						--<<<< Only a numeric column 
					.
					.
				FROM
					Table1
				WHERE
					condition
				Group by
				   column(s);
				   
			Scenario : What is the average (Mean) of current salary on a Department basis across ** ALL ** departments in the company 
					   expose departments with no salaries

*/

			select
				avg(Pay_Amount) as All_Pays,
				avg(distinct pay_amount) Distinct_Pays
			from
				NEW_PAY_RUN;

	
			select
				dep.dept_name,
				format(avg(cast(current_salary as decimal(18,2))),'C0') as AvgSalary
			from
				Current_Personnel cp right join
				Departments dep on cp.sid_Department = dep.sid_Department
			group by 
				dep.dept_name
			order by
				AvgSalary desc

--		Exercise 18.4 The Payroll Analyst has requested insight about the average salary across ALL countries & states
--					  insight should be ordered by Country and Average Salary 	
--					  	

--	Do not use an alias column for Order By when the format() function is part of the expression

			select
				dep.dept_name,
				format(avg(cast(current_salary as decimal(18,2))),'C0') as AvgSalary
			from
				Current_Personnel cp right join
				Departments dep on cp.sid_Department = dep.sid_Department
			group by 
				dep.dept_name
			order by
				avg(cast(current_salary as decimal(18,2))) desc
				--AvgSalary desc

-- Scenario solution

			select
				geo.CountryRegionName,
				geo.StateProvinceName,
				format(avg(cast(current_salary as decimal(18,2))),'C0') as AvgSalary
			from	
				Current_Personnel cp right join
				Geography geo on cp.sid_Location = geo.sid_Location
			group by
				geo.CountryRegionName,
				geo.StateProvinceName
			order by
				geo.CountryRegionName,
				avg(cast(current_salary as decimal(18,2))) desc;


/*

				Notes: The MIN(column) returns the minimum value in the expression - ignores NULL values. With character data columns, MIN finds the value that is lowest in the sort sequence. 
					   
					   The MAX(column) returns the maximum value in the expression - ignores NULL values. For character columns, MAX finds the highest value in the collating sequence.
																										  Collation refers to a set of rules that determine how data is sorted and compared

			    SELECT
					MIN(column)						
					MAX(column)
					.
					.
				FROM
					Table1
				WHERE
					condition
				Group by
				   column(s);
				   
			Scenario : What are the Minimum and Maximum salaries paid according to salary history data; provide insight
					   about salary movement 
					   

*/

			select
				emp_no,
				min(current_salary) as MinSal,
				max(current_salary) as MaxSal,
				abs(min(current_salary) - max(current_salary)) as Movement
			from
				Salary_History
			group by
				emp_no;
			
			

--		Exercise 18.5 : The CEO requires insight about historical salary range and movement for the managers of the organisation
--						this insight must include the employee full name and ordered by the movement high to low. 
--
--						The CEO has also requested an indicator be provided to class the movement into buckets i.e. also know as Discretization
--						The rules for the buckets are <= 3000 as Low Growth
--													  >  3000 and <= 5000 as Medium Growth 	
--												      >  5000 as Best Growth
--
--						Tip : Joins are required ensure you are profiling which tables to use 
--							  Case statement to test the range to arrive at the bucket(s) (Lecture 95 covered this topic)
--
--								

			select
				emp.emp_no,
				first_name + ' ' + last_name as FullName,
				min(current_salary) as MinSal,
				max(current_salary) as MaxSal,
				abs(min(current_salary) - max(current_salary)) as Movement,
				case
					when abs(min(current_salary) - max(current_salary)) <= 3000 then 'Low Growth'
					when abs(min(current_salary) - max(current_salary)) > 3000 and abs(min(current_salary) - max(current_salary)) <=5000 then 'Medium Growth'
					when abs(min(current_salary) - max(current_salary)) > 5000 then 'Best Growth'
				end as GroupTrend 
			from
				Salary_History sh inner join
				Employees emp on sh.sid_Employee = emp.sid_Employee inner join
				Managers man on emp.sid_Employee = man.sid_Employee
			group by
				emp.emp_no,
				first_name,
				last_name
			order by
				Movement desc;
				
/*
		
				Notes: Typically we cannot specify an aggregation (e.g. Sum(Current_Salary)) as a condition in a WHERE clause, hence this is what the
					   HAVING clause is used for. The HAVING clause can be used as a search condition for a Group and is typically used with the Group By clause.

			    SELECT
					column1						
					.
					.
					.
				FROM
					Table1
				WHERE
					condition
				Group by
				   column(s)
				Having 
					<aggregate> condition 
				Order by
					column(s);
				   
			Scenario : Profile the Managers table to establish if duplicate employees exist				   

*/

			select
				[emp_no]
			from
				[dbo].[Salary_History]
			group by 
				emp_no
			Having 
			    sum(current_salary) > 600000;
	
			
			select * from managers order by sid_Employee;

			select
				sid_Employee,
				count(sid_Employee) as EmpCount
			from
				managers
			group by
				sid_Employee
			having
				count(sid_Employee) > 1;

			
--		Exercise 18.6 : As part of a data audit the managing auditor has requested a check of the Employees table
--					    to ensure no duplicates are present.

		select
			sid_employee,
			count(sid_employee) as EmpCount
		from
			Employees
		group by
			sid_Employee
		having 
			count(sid_employee) >1;

		select
			emp_no,
			count(emp_no) as EmpCount
		from
			Employees
		group by
			emp_no
		having 
			count(emp_no) >1;
