USE Human_Resources;

/*

	Scripts and exercises used in Chapter 11
	
	This script file (Chapter11_SQL_Script.sql) is available for download in this lecture resources 

*/

/*

		Note: The INNER JOIN selects records that have matching values in both tables
			  
			  When joining tables there is no obligation to join on matching column names
			  the only obligation is to ensure the data types are the same and the subject matter is
			  is the same e.g it would be acceptable to join (Employees) hire date to (Calendar) Cal Date 
			  the subject is date.


		SELECT 
			column_name(s)
		FROM 
			table1 as table1_alias INNER JOIN 
			table2 as table2_alias ON table1_alias.column_name = table2_alias.column_name;	
		WHERE
			...
		
*/

select
	emp_no,
	birth_date,
	first_name,
	gender_name,
	emp.gender
from
	Employees emp inner join
	Gender gen on gen.gender = emp.gender;

-- Exercise 11.1	The company CEO has requested an ordered list of employees that are managers i.e. Hold a management position
--					She requires the emp no, First name, last name, position and the start date , ordered by emp no
--					Hint : Understand where you are going to source the data from in the database
--						   Review the 2 tables to establish which column you are going to use for the join

select
	emp_no,
	first_name,
	last_name,
	position,
	from_date
from
	Employees emp inner join
	Managers man on emp.sid_Employee = man.sid_Employee
order by
	1;


/*

		Note: The LEFT JOIN selects ALL records from the Left Table (T1) and the matched records from the Right Table (T2)
			  A NULL is shown when there is no match to the right table (T2) 
			  
		SELECT 
			column_name(s)
		FROM 
			table1 as table1_alias LEFT JOIN 
			table2 as table2_alias ON table1_alias.column_name = table2_alias.column_name;	
		WHERE
			...
		
*/

select
	emp_no,
	first_name,
	last_name,
	position,
	from_date
from
	Employees emp left join 
	Managers man on emp.sid_Employee = man.sid_Employee
order by
	4 desc;

-- Exercise 11.2 The personnel manager requires a list of all current employees (Current_Personnel) including 
--				 emp no, first name, last name, current salary, current location a special request has been
--				 made to include a status to show the employee is 'not currently employed' otherwise show the status
--				 as 'Currently employed'	
--
--	Hint: Use your knowledge from previous lectures by combining the below ...
--		
--			a) The CASE statement
--			b) IS NULL operator
--			c) AND operator
--		
--		   The column name for status should be anything you think of but not status on it's own as it is a keyword 
--		   as previously discussed we try not to use keywords in column names

select
	emp.emp_no,
	first_name,
	last_name,
	current_salary,
	current_location,
	Case
		when current_salary is null AND current_location is null then 'Not currently employed'
	else
		'Currently employed'
	end as EmpStatus
from
	Employees emp left join
	Current_Personnel cp on emp.sid_Employee = cp.sid_Employee;


/*

		Note: The RIGHT JOIN selects ALL records from the Right Table (T2) and the matched records from the Left Table (T1)
			  A NULL is shown when there is no match to the right table (T1) 
	
		SELECT 
			column_name(s)
		FROM 
			table1 as table1_alias RIGHT JOIN 
			table2 as table2_alias ON table1_alias.column_name = table2_alias.column_name;	
		WHERE
			...
		
*/

select
	gen.gender,
	gen.gender_name,
	emp_no,
	birth_date,
	first_name,
	last_name
from
	Employees emp right join 
	Gender gen on emp.gender = gen.gender
order by 1 desc;

-- Exercise 11.3 The CEO has a feeling we are under staffed in some departments and wants an ordered list (by Emp No)
--				 of current employees showing Department Name (Departments), emp no and current location
--				 Once this list is generated the CEO will be shocked with the result and demand to know why it is so!		 

select
	dept_name,
	emp_no,
	current_location
from
	Current_Personnel cp right join
	Departments dep on cp.sid_Department = dep.sid_Department
order by 2;


/*

		Note: The FULL JOIN selects ALL records when there is a matching value in the Left Table (T1) OR 
              a matching value in the Right Table (T2), a NULL is returned when there is no matching value
	
		SELECT 
			column_name(s)
		FROM 
			table1 as table1_alias FULL JOIN 
			table2 as table2_alias ON table1_alias.column_name = table2_alias.column_name;	
		WHERE
			...
		
*/

select
	emp_no,
	City,
	CountryRegionName
from
	Current_Personnel cp full join
	Geography geo on cp.sid_Location = geo.sid_Location
order by
	emp_no;


-- Exercise 11.4 We are currently sitting with our client and the query for profiling the Current Personnel against Geography
--               is going well but the client is frustrated that I am scrolling around so much to demonstrated the issues in
--			     the data. He wants me to remove all the matched records from the row set and only display the sorted T1 and T2 
--				 un-matched records which is the primary reason for this profiling.
--
--				 Hint : Use predication for this 

select
	emp_no,
	City,
	CountryRegionName
from
	Current_Personnel cp full join
	Geography geo on cp.sid_Location = geo.sid_Location
where
	emp_no is null or
	City is null
order by
	emp_no,2;

--			BEST PRACTICE JOIN Method Old -vs- New (ANSI) 
--
--			Note : Query1 is a best practice ANSI JOIN syntax (Further more FULL JOIN is an ANSI spec)
--
--				   Query2 is an older style JOIN syntax (and if you code this way during your interview testing I can guarantee
--														 you will not make the shortlist as a SQL Analyst/Dev)
--		

-- Query 1 (ANSI)

select
	cp.emp_no,	
	dep.dept_name,
	geo.City,
	geo.CountryRegionName
from
	Current_Personnel cp inner join
	Geography geo on cp.sid_Location = geo.sid_Location inner join
	Departments dep on cp.sid_Department = dep.sid_Department
order by
	emp_no,2;

-- Query 2 (Query 1 but the older style)

select
	c.emp_no,	
	d.dept_name,
	g.City,
	g.CountryRegionName
from
	Current_Personnel c,
	Geography g,
	Departments d
where
	c.sid_Location = g.sid_Location and
	c.sid_Department = d.sid_Department
order by
	emp_no,2;



-- Formatting your code for readability

-- 1:

select
	cp.emp_no,	
	dep.dept_name,
	geo.City,
	geo.CountryRegionName
from
	Current_Personnel cp inner join
	Geography geo on cp.sid_Location = geo.sid_Location inner join
	Departments dep on cp.sid_Department = dep.sid_Department
order by
	emp_no,2;

-- 2:
SELECT cp.emp_no, 
       dep.dept_name, 
       geo.city, 
       geo.countryregionname 
FROM   current_personnel cp 
       INNER JOIN geography geo 
               ON cp.sid_location = geo.sid_location 
       INNER JOIN departments dep 
               ON cp.sid_department = dep.sid_department 
ORDER  BY emp_no, 
          2; 

