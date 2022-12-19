
USE Human_Resources;

/*

	Scripts and exercises used in Chapter 10
	
	This script file (Chapter10_SQL_Script.sql) is available for download in this lecture resources 

*/

/*

	Note : The CASE statement iterates through conditions and returns a value when the first condition is met (like an IF-THEN-ELSE statement). 
		   Hence, once a condition is true, it will stop reading and return the result. 
		   If no conditions are true, it returns the value in the ELSE clause. 

	SELECT Column(s) ...
    CASE
      WHEN column condition THEN <some value>
	   .
	   .
	   .
     ELSE 
	  <some value>
    END 
		AS Column Alias
	FROM 
	 Table ;

*/

select
	emp_no,
	current_salary,
	current_location,
	case
	 when current_salary between 100000 and 125000 then 'Paid Well'
	 when current_salary > 125000 then 'Paid Very Well'
	else
	 'Not Specified'	
	end as [Salary Status]
from
	Current_Personnel
order by 2;

-- Exercise 10.1 The HR manager requires expansion of the previous Salary Status by adding 2 more conditions
--				 1: Salary between 30000 and 50000 will be Paid Junior
--				 2: Salary between 50001 and 99999 will be Paid Senior


select
	emp_no,
	current_salary,
	current_location,
	case
	 when current_salary between 30000 and 50000 then 'Paid Junior'
	 When current_salary between 50001 and 99999 then 'Paid Senior'
	 when current_salary between 100000 and 125000 then 'Paid Well'
	 when current_salary > 125000 then 'Paid Very Well'
	else
	 'Not Specified'	
	end as [Salary Status]
from
	Current_Personnel
order by 2;


/*

	Note : The YEAR()	function takes a date argument and returns an integer value
		   The MONTH()	function takes a date argument and returns an integer value
		   The DAY()	function takes a date argument and returns an integer value

	SELECT 
		YEAR(Date), 
		MONTH(Date),
		DAY(Date)
	FROM
		TABLE
	WHERE
		condition ...

*/

select
	top 1 Cal_Date,
	year(Cal_Date) as [Year],
	month(Cal_Date) as [Month],
	day(cal_date) as [day]
from
	calendar;

select
	Cal_Date,
	year(Cal_Date) as [Year],
	month(Cal_Date) as [Month],
	day(cal_date) as [day]
from
	calendar
where
	year(cal_date) = 2024
order by
	1;

-- Exercise 10.2 The hiring manager has requested a list of employees from the employee table that was hired between 2013 and 2016 
--			     so she can conduct a review of hiring trends. The list should be ordered by year.

select
	emp_no,
	first_name,
	last_name,
	hire_date,
	year(hire_date)
from
	employees
where 
	year(hire_date) between 2013 and 2016
order by 
	year(hire_date) desc;


/*
	
	Note : The DATEPART() function can be used to return a specific part of a Date as an integer
		   As we saw in the previous lecture with YEAR() we can do the same with DATEPART()

		   * The abbreviation options are varied and can be found in the lecture resources as a link to SQL Documentation

		   Here are some abbreviation examples ...
										
		   Year		,	yyyy, yy	Returns Year e.g. 2013
		   Quarter	,	qq,q		Returns Quarter e.g. 3
		   Month	,	mm,m		Returns Month e.g. 10
		   Week		,	wk,ww		Returns Week of Year e.g. 44		
		   Day		,	dd,d		Returns Day of month e.g. 22
		   Weekday	,	dw			Returns Day of week e.g. 4 	
	  	      
		   Special note : SET DATEFIRST 7 - Sets the first day of the week e.g 1 is Monday , at present my installation is 7 (Sunday) Default value (US English) 

	SELECT 
		DATEPART(abbreviation,datevalue) as alias,
		Column(s) ...
	FROM
		TABLE
	WHERE
		condition ...

*/

	 SET DATEFIRST 7
	 select datepart(dw,getdate()) as Today -- Thurs

select
	emp_no,
	first_name,
	last_name,
	hire_date,
	datepart(yy,hire_date) as Year_Of_Hire,
	datepart(q,hire_date) as Qtr_Of_Hire,
	datepart(dd,hire_date) as Day_Of_Hire,
	datepart(dw,hire_date) as Day_Of_Week_Hire,
	datename(dw,hire_date) as Day_Of_Week_Name_Hire
from
	employees
order by
	datepart(yy,hire_date)

-- Exercise 10.3 The hiring manager is reviewing the Employee Position History and requires an ordered list of employees made up of
--				 emp_no,position,pos_from_date,Year of position, week of year position. Sorted by Year and Week. 

select
	emp_no,
	position,
	pos_from_date,
	DATEPART(year,pos_from_date) as YearOfPosition,
	datepart(wk,pos_from_date) as WeekOfYearPosition
from
	Employee_Position_History
order by
	DATEPART(year,pos_from_date) ,
	datepart(wk,pos_from_date)


/*

	Note : The DATEDIFF() function can be used to return the difference between the startdate and enddate. 
		   
		   * The abbreviation options are varied and can be found in the lecture resources as a link to SQL Documentation

		   Here are some abbreviation examples ...
										
		   Year		,	yyyy, yy	Returns Year e.g. 2013
		   Quarter	,	qq,q		Returns Quarter e.g. 3
		   Month	,	mm,m		Returns Month e.g. 10
		   Week		,	wk,ww		Returns Week of Year e.g. 44		
		   Day		,	dd,d		Returns Day of month e.g. 22
		   Weekday	,	dw			Returns Day of week e.g. 4 	

	SELECT 
		DATEDIFF(datepart , startdate , enddate) as alias,
		Column(s) ...
	FROM
		TABLE
	WHERE
		condition ...

*/

select
	emp_no,
	pos_from_date,
	pos_to_date,
	DATEDIFF(yy,pos_from_date,pos_to_date) as YearsInJob
from
	Employee_Position_History
order by
	DATEDIFF(yy,pos_from_date,pos_to_date)

-- Exercise 10.4 As the value of the difference in Job Position Start & End in many records is 0 then the HR manager has asked for 
--				 a value to be added to another time in the job.


select
	emp_no,
	pos_from_date,
	pos_to_date,
	DATEDIFF(yy,pos_from_date,pos_to_date) as YearsInJob,
	DATEDIFF(month,pos_from_date,pos_to_date) as MonthsInJob,
	DATEDIFF(dd,pos_from_date,pos_to_date) as DaysInJob
from
	Employee_Position_History
order by
	DATEDIFF(yy,pos_from_date,pos_to_date)

/*

	Note : The DATEADD() function can be used to add a specified number to a datepart of an input date 
		   
		   * The abbreviation options are varied and can be found in the lecture resources as a link to SQL Documentation

		   Here are some abbreviation examples ...
										
		   Year		,	yyyy, yy	Returns Year e.g. 2013
		   Quarter	,	qq,q		Returns Quarter e.g. 3
		   Month	,	mm,m		Returns Month e.g. 10
		   Week		,	wk,ww		Returns Week of Year e.g. 44		
		   Day		,	dd,d		Returns Day of month e.g. 22
		   Weekday	,	dw			Returns Day of week e.g. 4 	

	SELECT 
		DATEADD(datepart , number , date )   as alias,					-- Note that number can be a negative so we can subtract from a date
		Column(s) ...
	FROM
		TABLE
	WHERE
		condition ...

*/

select top 1000
	[sid_Employee],
	Pay_Amount,
	Pay_Date,
	dateadd(dd,7,Pay_Date) as Next_PayDate
from
	[Payroll].[Employee_Payroll]

-- Exercise 10.5 The Payroll Analyst would like to see the payroll transactions for the months between Jan & Mar and
--				 the ordered list should include the Employee Id, Pay Amount, Pay Date, Next Pay Date , Previous Pay Date
--				 order by Previous Pay Date 
--
--				 Only use Datepart() to test the months for extraction
--

select 
	[sid_Employee],
	Pay_Amount,
	Pay_Date,
	dateadd(dd,7,Pay_Date) as Next_PayDate,
	dateadd(dd,-7,Pay_Date) as Prev_PayDate
from
	[Payroll].[Employee_Payroll]
where
	datepart(m,pay_date) between 1 and 3

/*

	Note: We can use the FORMAT function to format output such as Currency , Date etc
	
	* The format syntax and culture options can be found in the lecture resources as a link to SQL Documentation

	SELECT 
	    FORMAT(Column,format,culture) as alias,
		Column(s) ...
	FROM
		TABLE
	WHERE
		condition ..

*/

-- Number Formats

	SELECT TOP 1 Pay_Amount, [Pay_Date]  
            ,FORMAT(Pay_Amount, 'N', 'en-us') AS 'Number Format'  
            ,FORMAT(Pay_Amount, 'G', 'en-us') AS 'General Format'  
            ,FORMAT(Pay_Amount, 'C', 'en-us') AS 'Currency Format'  
	FROM 
		[Payroll].[Employee_Payroll]
	ORDER BY	
		[Pay_Amount];  

-- Our data using default currency (Australian $)

select 
	[sid_Employee],
	format(Pay_Amount,'C0') as CurrencyPay,
	Pay_Date,
	dateadd(dd,7,Pay_Date) as Next_PayDate,
	dateadd(dd,-7,Pay_Date) as Prev_PayDate
from
	[Payroll].[Employee_Payroll]
where
	datepart(m,pay_date) between 1 and 3

-- Date format

	SELECT Top 1
	   FORMAT ( [Pay_Date], 'd', 'en-US' ) AS 'US English Result'  
      ,FORMAT ( [Pay_Date], 'd', 'en-gb' ) AS 'Australian English Result'  
      ,FORMAT ( [Pay_Date], 'd', 'de-de' ) AS 'German Result'  
      ,FORMAT ( [Pay_Date], 'd', 'zh-cn' ) AS 'Simplified Chinese (PRC) Result'
  	FROM 
		[Payroll].[Employee_Payroll]
	ORDER BY	
		[Pay_Amount];  

-- Our data using a US date format

select 
	[sid_Employee],
	format(Pay_Amount,'C0') as CurrencyPay,
	format(Pay_Date,'d','en-US') as USPayDate,
	dateadd(dd,7,Pay_Date) as Next_PayDate,
	dateadd(dd,-7,Pay_Date) as Prev_PayDate
from
	[Payroll].[Employee_Payroll]
where
	datepart(m,pay_date) between 1 and 3


-- Exercise 10.6 The Payroll analyst has requested changes to the pay list generated in the last exercise and requires the following
--               Pay_Amount to be UK Pounds, Pay_Date to be UK Date format
--			     The changes should also be applied to the Next Pay Date and Prev Pay Date
--				 To find the locale for UK you will need to review the documention via the link in this lecture resources


select 
	[sid_Employee],
	format(Pay_Amount,'C0','en-gb') as CurrencyPay,
	format(Pay_Date,'d','en-gb') as UKPayDate,
	format(dateadd(dd,7,Pay_Date),'d','en-gb') as Next_UKPayDate,
	format(dateadd(dd,-7,Pay_Date),'d','en-gb') as Prev_UKPayDate
from
	[Payroll].[Employee_Payroll]
where
	datepart(m,pay_date) between 1 and 3

/*
	Note : The CONCAT function returns a string as a result of joining (Concatenating) two or more string values

	SELECT 
	    CONCAT( string_value1, string_value2 [, string_valueN ] ) as alias,
		Column(s) ...
	FROM
		TABLE
	WHERE
		condition ..

*/

select top 5
	emp_no,
	current_location,
	current_salary
from
	[dbo].[Current_Personnel]


select top 5
	concat('Employee # ',emp_no,' is currently located at ',current_location, ' and is paid ', format(current_salary,'C0','en-US'), ' per year') as StoryLine
from
	[dbo].[Current_Personnel]


-- Exercise 10.7  The data viz team has been asked to provide a prototype to tell a brief story of employees e.g. 10 employees
--				  Use the Employees table as the data source and describe the employee with attributes including 
--				  Name,Birthday,gender, how long ago they were hired to work here 


select top 10
	concat('Our valued team member ', first_name , ' ' , last_name , ' born on ' , birth_date , ' and their gender is ' , gender, 
	' has worked with us for ', DATEDIFF(year,hire_date,getdate()), ' Years(s)' ) as EmpBio

from
	Employees
