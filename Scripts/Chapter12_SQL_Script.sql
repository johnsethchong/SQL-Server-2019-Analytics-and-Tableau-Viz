USE Human_Resources;

/*

	Scripts and exercises used in Chapter 12
	
	This script file (Chapter12_SQL_Script.sql) is available for download in this lecture resources 

*/


/*

		Note: When performing an Inner Join with 3 or more tables ensure that the alias for the table(s)
		      clearly named to ensure the join is well defined and obvious to the reader

	SELECT 
		alias.column_name(s)
		.
		.
		.
	FROM 
		table1 as table1_alias INNER JOIN 
		table2 as table2_alias ON table1_alias.column_name = table2_alias.column_name INNER JOIN 
	    table3 as table3_alias ON table(x)_alias.column_name = table3_alias.column_name ...
		
	WHERE
		...
	ORDER BY
		...

*/

select
	emp.emp_no,
	first_name,
	last_name,
	position,
	from_date,
	sh.current_salary,
	sh.sal_from_date,
	sh.sal_to_date
from
	Employees emp inner join
	Managers man on emp.sid_Employee = man.sid_Employee inner join
	Salary_History sh on emp.sid_Employee = sh.sid_Employee
order by
	emp_no,sal_from_date desc;


--		Exercise 12.1 The CEO is looking at the position history of the managers. Thus requires an ordered list
--				      of managers that shows the date of start and to date of their position.

--					  The list should include emp no,first name,last name, position from date and position to date

--					  The list should be ordered by the position from date
--
--					  But the CEO has subsequently asked for the time in months they have been in the job
--					  
--					  Hint: Use Datediff() for months in the job (we covered this in Chapter 10)
--

select
	emp.emp_no,
	first_name,
	last_name,
	pos_from_date,
	pos_to_date,
	DATEDIFF(month,pos_from_date,pos_to_date)  as MonthsInPosition
from
	Employees emp inner join
	Managers man on emp.sid_Employee = man.sid_Employee inner join
	Employee_Position_History eph on man.sid_Employee = eph.sid_Employee
order by
	emp_no, pos_from_date;


/*

		Note: When performing Multi Type Joins with 3 or more tables ensure that the alias for the table(s)
		      clearly named to ensure the join is well defined and obvious to the reader

	SELECT 
		alias.column_name(s)
		.
		.
		.
	FROM 
		table1 as table1_alias INNER JOIN 
		table2 as table2_alias ON table1_alias.column_name = table2_alias.column_name (INNER JOIN or LEFT JOIN ?) 
	    table3 as table3_alias ON table(x)_alias.column_name = table3_alias.column_name ...
		
	WHERE
		...
	ORDER BY
		...

	Note: A common join query (in my experience) is to combine Inner/Left joins to 
		  ensure we do not miss data

    Scenario: This query scenario is to provide a profile of employee locations to ascertain the 
			  employee postal code is correct i.e. conforms to the Geography table as this is
			  the source of truth for the organisations mapping and location tracking.

*/

select * from Employee_Location;

select
	emp.emp_no,
	first_name,
	last_name,
	el.PostalCode LocPostalCode,  
	geo.PostalCode GeoPostalCode

from 
	Employees emp inner join
	Employee_Location el on emp.sid_Employee = el.sid_Employee left join
	Geography geo on el.PostalCode = geo.PostalCode;

--		Exercise 12.2 The HR manager is looking at Employee Movement through departments and has requested
--					  a data validation check should be performed on the movements data to ensure the recorded
--					  department is correct
--
--					  A list of incorrect department number values is required, the list should reveal
--					  emp no, first name, last name , department number currently recorded for the employee 


select
	emp.emp_no,
	first_name,
	last_name,
	emh.dept_no as emhDeptNo,
	dep.dept_no as depDepNo
from
	Employees emp inner join
	Employee_Movements_History emh on emp.sid_Employee = emh.sid_Employee left join
	Departments dep on emh.dept_no = dep.dept_no
where
	dep.dept_no is null
order by
	emp_no;


/*
		Note : Self Join There is no such Join Type it is a term used to describe querying columns with the same table

				1: Great for Hierarchical data contained in a single tables
				2: And also creating correlated pair lists
	
	1: Using a Left Join :-

	select
		table_alias_1.Column1,
		table_alias_1.Column2,
		table_alias_1.Column3,
		table_alias_2.Column1
	from
		table1 as table_alias_1  left join
	    table2 as table_alias_2 on table_alias_1.Column = table_alias_2.Column
	where 
		....
	order by
		column(s)

	2: Using a Where condition to compare the table contents i.e. predicate :- 
	
	select
		table_alias_1.Column1,
		table_alias_1.Column2,
		table_alias_1.Column3,
		table_alias_2.Column1
	from
		table1 as table_alias_1,
		table2 as table_alias_2
	where
		table_alias_1.Column1 <> table_alias_2.Column1  
	    table_alias_1.Column2  = table_alias_2.Column2  
		.
		.
	order by
		column(s)

*/

select * from Management.EmployeeManagerTree;

select
	emp1.sid_Employee,
	emp1.FullName,
	emp1.sid_Manager,
	emp2.FullName as ManagerName
from
	Management.EmployeeManagerTree emp1 left join
	Management.EmployeeManagerTree emp2 on emp1.sid_Manager = emp2.sid_Employee 
where
	emp1.sid_Manager = 46;

select
	emp1.sid_Employee,
	emp1.FullName,
	emp1.sid_Manager,
	emp2.FullName as ManagerName
from
	Management.EmployeeManagerTree emp1 ,
	Management.EmployeeManagerTree emp2 
where 	
	emp1.sid_Manager = emp2.sid_Employee 
order by 
	sid_Manager;


select
	cp1.emp_no as Emp1,
	cp1.current_salary,
	cp2.emp_no as Emp2
from
	Current_Personnel cp1 ,
	Current_Personnel cp2 
where
	cp1.emp_no <> cp2.emp_no and
	cp1.current_salary = cp2.current_salary
order by
	cp1.emp_no

--		Exercise 12.3 The hiring manager has requested an ordered list of the top 10,000 employees detailing  
--					  employees hired on the same date as well as how many years they have been with the
--					  company.
--					  
--					  Include : Create a full name column (i.e. First and Last) 
--
--					  Tip: Ensure the Top (n) is used otherwise your query will take a very long time
--					       If you find that you have not used the Top (n) and the query will not complete 
--						   you can cease the query by clicking the cancel executing query button (next to the Execute button)
					
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
order by
	emp1.emp_no ;


