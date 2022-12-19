USE eCommerce ;

/*
	Scripts and exercises used in Chapter 24
	
	This script file (Chapter24_SQL_Script.sql) is available for download in this lecture resources 

	Just to recap ...

		# As this is a monthly analysis over 3 years (2017 to 2019) ; the metrics are captured for the end of month i.e. 
		  EOM Snapshot for example the SOH (Stock On Hand) is registered as at the End of Month when the business does a 
		  monthly stocktake and we use the StockTakeFlag for this.

		  If a flag is not available then the SQL Function EOMONTH(StockTxnDate) could be used instead for example.

		# Pre-aggregation is done to reduce the data set size as well as enable the data set to be product agnostic
	      thus reducing the calculations required by the Viz Tool (i.e. Less proprietary work)

		# In addition an analyst will need to test the visualisation against actual data hence the source
		  query plays a valuable role in this

		# This data set can also be implemented as a single fact table data mart

		# The Metrics required for the project data set will be the foundation for a Union All and reduce the
		  data size significantly as very often a visualisation does not require a full data set, it only requires enough
		  to answer the questions being asked of it.

  -- Unioned Data-Set Select template ...

  select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   Condition(s)
  group by
   Column(s)

  UNION ALL
  .
  .
  .

  Note : If required an Order by clause can be added at end of Union to suit your use case 

*/

-- Lecture set 251 -- Simple primer lecture to understand how our queries will influence the Union clause  
--					  This query is to demonstrate a single metric worksheet in Tableau
--
--					  Metric Name = Name = SOHQty	
--

  select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   sum(StockOnHand) as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   StockOnHand>0 and
   StockTakeFlag = 'Y'
  group by
   prod.ProductKey,
   inv.StockTxnDate

   
-- Exercise 24.1		The value for Back Order Quantity is required for a Tableau view that ultimately 
--						will apear in the final Dashboard
--
--						The Back Order Qty amount is the amount of stock on order with our Suppliers because 
--						sales activity probably depleted stock levels to 0 or below the order threshold
--					
-- Method				The Query that will be contructed uses the Template shown earlier, hence copy this 
--						ready for editing but make sure you set the UNION ALL statement between the 
--						2 Queries
--
--						You will need to only include the Back Order Qty value in your row set 
--						hence set your Where condition to only include Back Order Qty > 0
--
--						The Where condition will test the StockTakeFlag = 'Y'
--
-- Tableau
--						Now take the UNION'd rowset and refresh the factInventory Excel workbook (overwrite the current data)
--
--						Now open your Tableau workbook and refresh the data model with the new data
--					
--						Create a new sheet that will hold the BOQQty value , save it .
--
--						Tip: Do not repeat the SOHQty aggregation in this query otherwise you will see some skewed results.
--

   UNION ALL

  select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   sum(BackOrderQty) as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   BackOrderQty>0 and
   StockTakeFlag='Y'
  group by
   Prod.ProductKey,
   StockTxnDate

   UNION ALL

/* 

    Lecture set 255

	Recap : Business rules for the Stock Status dimension are ...

	1		SOH >= ReorderPoint							: means Stock Level OK
	2		SOH = 0 and BackOrderQty > 0				: means Out of Stock - Back Ordered
	3		SOH < ReorderPoint and BackOrderQty	> 0		: means Low Stock - Back Ordered
	4		BOQ = 0 and SOH <= ReorderPoint				: means Reorder Now

 Select * from [dbo].[Product]	<< Showing where the Reorder Point is 
								  [Reorder Point indicates when stock should be reordered due
								   to low levels of inventory]

 Nested Query Syntax : The select part of the template is used for the Outer Query
  
 SELECT
   ProductKey,
   StockTxnDate,									-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
 FROM
 	(
		
		The Inner Query code that will build our Stock Status
		
	) as <alias> 
 
 WHERE			
		condition(s)							-- If applicable to the requirement
		
 GROUP BY
		column(s)								-- If applicable to the requirement 

 ORDER BY
		columns(s)								-- If applicable to the requirement
		
*/


 SELECT
   ProductKey,
   StockTxnDate,									-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   StockStatus,
   count(StockStatus) as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
from
(
 select
	prod.ProductKey,
	StockTxnDate,
	case
		when StockOnHand>=prod.ReorderPoint then 'Stock Level OK'
		when StockOnHand=0 and BackOrderQty>0 then 'Out of Stock - Back Ordered'
		when (StockOnHand < prod.ReorderPoint) and BackOrderQty>0 then 'Low Stock - Back Ordered'
		when BackOrderQty=0 and (StockOnHand<= Prod.ReorderPoint) then 'Reorder Now'
	end as StockStatus
 from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
 where
  StockOnHand>0 and
  StockTakeFlag='Y' ) as dtStockStatus
 group by
   ProductKey,
   StockStatus,
   StockTxnDate

/*	 Exercise 24.2		

	 Based on your learning from the previous lecture you will ...

	 1: Write a query to fullfill the analytics for Back Order Status quantity
	 
	 2: Add your full data set to the factInventory Excel
	 
	 3: Refresh your Tableau workbook
	 
	 4: Create a new Tableau View and Bar Chart to represent the Back Order Status for each year

	Recap : Business rules for the BackOrderStatus Status dimension are ...

	1		BackOrderQty > 0 and BackOrderQty <=10 	: means Up to 10 on order
	2		BackOrderQty >10 and BackOrderQty <=20	: means Up to 20 on order
	3		BackOrderQty >20 and BackOrderQty <=40	: means Up to 40 on order
	4		BackOrderQty >40 and BackOrderQty <=60	: means Up to 60 on order
	5	    BackOrderQty >60						: means 60 + on order
	
	Tip: Don't forget the UNION ALL 

*/

UNION ALL

-- Step 1 : Code the inner query
-- Step 2 : Code the outer query
-- Step 3 : Run all the Union'd Queries and refresh your Excel WB
-- Step 4 : Refresh your Tableau Data
-- Step 5 : Create the new worksheet and bar chart

 SELECT
   ProductKey,
   StockTxnDate,									-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   BackorderStatus,
   count(BackorderStatus) as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
 FROM
(
  select
	prod.ProductKey,
	StockTxnDate,
	case
		when BackOrderQty >0 and BackOrderQty <=10 then 'Up to 10 on order'
		when BackOrderQty >10 and BackOrderQty <=20 then 'Up to 20 on order'
		when BackOrderQty >20 and BackOrderQty <=40 then 'Up to 40 on order'
		when BackOrderQty >40 and BackOrderQty <=60 then 'Up to 60 on order'
	else
		'+ 60 on order'
	end as BackorderStatus
  from
	Product prod inner join
	ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
    ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where
	BackOrderQty > 0 and
    StockTakeFlag='Y'
) as dtBackorderstatus 
group by
ProductKey,
BackorderStatus,
StockTxnDate

UNION ALL

/*
	Lecture set 259

	In this scenario the Stock on Hand Cost is to be visualised, and there is
	no such value in the ProductInventory table, consequently we do this 
	manually in the query.

	Compute a value based upon two colmuns inside an aggregation function

	SYNTAX:

	SELECT
		Column(n)s,
		agg_function(Column1 <operator> Column2) as <OutputMetricAlias>
	FROM
		Table(s)
	WHERE
	    Condition(s)
    GROUP BY
		Column(s)
	ORDER BY
		Column(s)

*/

  select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   sum(StockOnHand*UnitCost) as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   StockOnHand>0 and
   StockTakeFlag='Y'
  group by
   prod.productkey,
   StockTxnDate

UNION ALL

/*	 Exercise 24.3	

	 Based on your learning from the previous lecture you will ...

	 1: Write a query to fullfill the analytics for Lost Sales Value	 
	 2: Create a new Tableau View and Line Chart to represent the Lost Sales by month

	Recap : Business rules for the lost sales value ...

		Lost sales are calculated as any stock item that is 0 On Hand and has a backorder
		value > 0 multiplied by the List Price of the item.

*/

  select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   sum(BackOrderQty * ListPrice) as LostSalesValue,
   0 as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   BackOrderQty>0 and
   StockOnHand=0 and
   StockTakeFlag='Y'
  group by
   prod.ProductKey,
   StockTxnDate

/*
	Lecture set 263

	In this scenario the the Overstock Quantity is to be visualised, and there is
	no such value in the ProductInventory table, consequently we do this 
	manually in the query.

	Compute a value based upon two colmuns inside an aggregation function

	SYNTAX:

	SELECT
		Column(n)s,
		agg_function(Column1 <operator> Column2) as <OutputMetricAlias>
	FROM
		Table(s)
	WHERE
	    Condition(s)
    GROUP BY
		Column(s)
	ORDER BY
		Column(s)

*/

UNION ALL

  select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   sum(StockOnHand-MaxStockLevel) as OverStockAmount,
   0 as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   StockOnHand>MaxStockLevel and
   StockTakeFlag ='Y'
  group by
   prod.ProductKey,
   StockTxnDate

/*	 Exercise 24.4	

	 Based on your learning from the previous lectures you will ...

	 1: Write a query to fullfill the analytics for Overstock Cost $ 
	 2: Create a new Tableau View with a Stacked Bar Chart to represent the Overstock Value $ by YEAR only

	Recap : Business rules for the overstock value

		    Overstock value is calculated as the Overstock Amount x UnitCost

	Tip  : You will be embedding the a calculation inside the SUM() aggregation 

	Hint : Consider the order of precedence in the calculation steps else your end result will not 
	       be as you would expect it

*/	

  UNION ALL

  select
   Prod.ProductKey,
   StockTxnDate,												-- Stock Take is end of each month
   0 as SOHQty,
   0 as BOQQty,
   '' StockStatus,
   0 as StockStatusCount,
   '' as BackorderStatus,
   0 as BackorderStatusCount,
   0 as SOHCost,
   0 as LostSalesValue,
   0 as OverStockAmount,
   sum((StockOnHand-MaxStockLevel) * UnitCost ) as OverStockCost
  from
   Product prod inner join
   ProductInventory inv on prod.ProductKey = inv.ProductKey inner join
   ProductSubcategory psc on prod.ProductSubcategoryKey = psc.ProductSubcategoryKey 
  where	
   StockOnHand>MaxStockLevel and
   StockTakeFlag='Y'
  group by
	prod.ProductKey,
	StockTxnDate



