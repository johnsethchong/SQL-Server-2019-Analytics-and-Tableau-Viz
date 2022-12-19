USE eCommerce ;

/*
	Scripts and exercises used in Chapter 23
	
	This script file (Chapter23_SQL_Script.sql) is available for download in this lecture resources 

	*  Caveat:

		The free version of Tableau i.e. Tableau Public does not enable connections to a database product such
		as SQL Server etc.

		So I will use Excel to put our query result data into a workbook & sheets 

		Nb: DO NOT use seperate Excel files for loading data, just treat Excel like a database , in other
			words each work sheet is a Table and the workbook is a Database.
		
		Loading data to Excel is only a small %age of what we shall be learning here anyway so should not be an
		inconvenience.

	* The Good News:
	
		If you do not have a copy of Excel you can use these free products ... 	

		1: Apache OpenOffice - https://www.openoffice.org/download/index.html	
		   I have not tested this but it will save to Excel format

		2: LibreOffice - https://www.libreoffice.org/discover/calc/ 
		   I have not tested this but it will save to Excel format

		3: Google Sheets (Free for Personal Use) https://www.google.com/sheets/about/
	 	   There are cell count limits so you may be forced to split your data set across files (based on my testing)

		4: Excel Online - Free https://products.office.com/en-au/free-office-online-for-the-web
		   There are row count limits here so you may be forced to split your data set across files (based on my testing)


*/

--       ** Getting our query results into the Tableau Workbook data model
--
--			Note: Tableau is a relational data model pardigm which aligns to what we have learned in this course
--				  so far, hence it will feel natural when dealing with your data for visualisation
--
--			Tableau has a row limit of 15Mil rows for a Workbook we won't be consuming that much data in a single workbook
--
--			Of course if you have a paid version of Tableau then we can hit a database directly	using Queries or Stored Procedures 


	-- Step 1 : Write a query , lets start simple first

	select * from ProductSubcategory;

	-- Step 2 : Save the results to your Excel file (Worksheet) (I recommend you save to the default Tableau repository as shown)
	--			Use seperate worksheets in the excel file as Tableau will recognise these
	--
	--	e.g.  C:\Users\<your username>\Documents\My Tableau Repository\Datasources\Sectionxx		<<-- I am organising data files to Section folders 

	-- Step 3 : Connect to the .xls from the Tabeau data connectors UI

/*

	To add another rowset to our Inventory work book we can follow the steps as we did previously , in this case though we will
	create another worksheet in our Section23 data file.

	When Tableau is updated you will observe a cool feature

*/

	select * from ProductCategory;


--	Exercise 23.1	Your colleague has gone off sick for a few days (sprained her ankle) and her team leader
--					has requested you step in and add the Products table to her work book model
--		
--					Tip: The product table is a dimension
--
--					Specs : 
--							1: The workbook only requires the following columns
--								ProductKey,ProductSubcategoryKey,ProductName,StandardCost,ListPrice,SupplierId
--
--							2: Confirm your extract has 607 records
--
--							3: Update your Tableau workbook with the Products table
--
--							4: Create a new sheet named "Products by Category breakdown"
--
--							   * Display a table with 
--							
--							   a) Product Category, Sub Category , Product  as Rows
--							   b) Record count as a Column
--
--
	
		select
			ProductKey,ProductSubcategoryKey,ProductName,StandardCost,ListPrice,SupplierId
		from
			product;
