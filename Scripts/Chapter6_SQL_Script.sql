-- How to create a database using DDL

create database A_Database;

-- Excercise 6.1 Student to Create a database named Ch6_Database

create database Ch6_Database;

-- How to add a database table using DDL

use Ch6_Database;
create table TableSetA (Fruit varchar(12));

-- Excercise 6.2 Student to add a database table to Ch6_Database named TableSetB with Column Fruit and data type varchar(12)

use Ch6_Database;
create table TableSetB (Fruit varchar(12));

-- How to insert data (Using DML) into a table using a singular record and then multiple records (i.e. A list) 

use Ch6_Database;
INSERT into [dbo].[TableSetA] ([Fruit])
values ('Bananas');

Select * from [dbo].[TableSetA];

INSERT into [dbo].[TableSetA] ([Fruit])
values ('Orange'),('Apple') ;

-- Excercise 6.3 Student to add new records to [dbo].[TableSetB] , insert fruits = Orange, Apple, Plums, Almonds

insert into TableSetB (Fruit)
values ('Orange'),('Apple'),('Plums'),('Almonds');

select * from TableSetB; 

--- How to Update data based on a Where clause 

/*

	UPDATE 
		table_name
	SET column1 = value1, column2 = value2, ...
	WHERE 
		condition;

*/

	UPDATE
		[dbo].[TableSetA]
	SET [Fruit] = 'Orange'
	WHERE 
		[Fruit]='Oranges';
			
select * from [dbo].[TableSetA];	

-- Excercise 6.4 Student to Update [dbo].[TableSetB] to set Fruit values that are plural to non plural e.g. Almonds to Almond

select * from [dbo].[TableSetB];	

	UPDATE
		[dbo].[TableSetB]
	SET Fruit = 'Almond'
		WHERE
	[Fruit]='Almonds'

	UPDATE
		[dbo].[TableSetB]
	SET Fruit = 'Plum'
		WHERE
	[Fruit]='Plums'

	UPDATE
		[dbo].[TableSetA]
	SET [Fruit] = 'Oranges'
	WHERE 
		[Fruit]='Orange';

-- How to Change the database name using DDL (ALTER DATABASE) and fix 

/*
	Use Master;

	ALTER DATABASE database_name MODIFY NAME = new_database_name;

*/

	use master;

	ALTER DATABASE [Ch6_Database] MODIFY NAME = CH_6_Database;

-- Excercise 6.5 Student to Alter the database CH_6_Database and rename to Chapter_6_Database

	use master;

	ALTER DATABASE CH_6_Database MODIFY NAME = Chapter_6_Database;

-- Add a new column to TableSetA - Introducing the Identity Field , these can be used as surrogate keys where uniqueness in required

/*

	ALTER TABLE table_name
	ADD column_name datatype;

*/

	use [Chapter_6_Database];

	ALTER Table [dbo].[TableSetA]
	ADD sid_A_Key int IDENTITY(1,5);

	select * from [dbo].[TableSetA];

-- Excercise 6.6 Student to Alter the Database table [dbo].[TableSetB] add a new identity column named sid_B_Key arguments for Identity are 10 , 10

	Alter Table [dbo].[TableSetB]
	Add sid_B_Key int Identity (10,10);

	select * from [dbo].[TableSetB];

-- Alter a database table column 

/*
	
	Alter Table table_name Alter column_name data_type

*/

	Alter Table [dbo].[TableSetA]
	 Alter Column [Fruit] char(8) ;

	select * from [dbo].[TableSetA];

-- Excercise 6.7 Student to Alter the Database table and change column Fruit data type to Text (Hint text does not get sized!)

	Alter Table [dbo].[TableSetB]
     Alter Column Fruit Text;

	 select * from [dbo].[TableSetB];

