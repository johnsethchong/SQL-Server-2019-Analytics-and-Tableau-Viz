USE eCommerce ;

/*
	Scripts and exercises used in Chapter 25
	
	This script file (Chapter25_SQL_Script.sql) is available for download in this lecture resources 
		
	Just to recap ...
	
	The data we shall query & extract is based on the business requirement of 3 year sales analysis.
	
	Hence, we have a set of columns that are dimensions and metrics, these form the basis of our 
	visualisations contained in our dashboards.

	# Abstract thinking is key in this section as Data Analysis requires thinking outside of the 
	  box, this section aims to get you into the mindset that nothing is impossible when presenting
	  answers to users questions.

	# The analysis will span years 2017 to 2019 inclusive and the granularity of the data is at the 
	  OnlineSales.OrderDate 

	# Product,ProductSubCategory and ProductCategory dimensions are part of the data source that has the
	  potential to be used in subsequent visualisations the student wishes to pursue

	# The OnlineSales table is the primary transaction (fact) table source by which we build our analysis
	  for the dashboards

	# Pre-aggregation is done to enable the data set to be product agnostic thus reducing the calculations 
	  required by the Viz Tool (i.e. Less proprietary work)

	# In addition an analyst will need to test the visualisation against actual data hence the source
	  query plays a valuable role in this

	# This data set can also be implemented as a single fact table data mart

  *** What the Prefixes mean in the column names ...

	  tc  = candidate fields for Tableau Calculated fields
	  ov  = columns output from the Window function OVER 
	  lag = columns output from the Window function LAG() OVER
	  mv  = columns output from Window function OVER (Preceding)
	  xj  = columns output from Cross Join 

	  cte = columns output from CTE (Common Table Expression) queries, although not shown in the final  
			union query as CTE's are not able to be UNIONED in this context, we'll add the CTE data to
			the dataset later in the section lectures.

  This is the UNION Template of identified columns for our data set
  
Select
  ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
  Table(s)	
where	
  Condition(s)
group by
  Column(s)

  UNION ALL
  ...

  Note : If required an Order by clause can be added at end of Union to suit your use case 

*/

--  Lecture set 277 to 279 
--
--	Scenario : Build a basic rowset showing all columns that will be used in the analysis required

--Select
--  ProductKey,											
--  OrderDate,
--  '' as City,
--  '' as State,
--  '' as Country,
--  sum(SalesAmount) as tcSalesValue,									
--  sum(TotalProductCost) as tcProductCost,									
--  0	as tcSalesTax,										
--  0 as tcTransportCost,									
--  0 as tcOrderCount,									
--  0 as ovOrderCount,									
--  0 as ovRunningOrderCount,								
--  0 as ovSalesValue,									
--  0 as ovRunningSalesTotal,								
--  0 as lagSalesGrowthIn$,								 
--  0 as lagSalesGrowthInPercent,							
--  0 as lagFreightGrowthIn$,								
--  0 as lagFreightGrowthInPercent,						
--  0 as mvSalesValue,											 
--  0 as mvAvgSales,
--  0 as mvOrderCount,
--  0 as mvAvgOrders,
--  '' as xjSaleTypeName,									 
--  '' as xjSaleStatus,
--  '' as xjGeoSaleStatus,
--  0 as xjGeoSaleStatusCount,
--  0 as cteAverageCustSales$,
--  0 as cteAvgOrderProductQty
--from
-- OnlineSales
--where	
-- year(OrderDate) between 2017 and 2019 
--group by
-- ProductKey,
-- OrderDate

/*
 Now it is time to really challenge your thinking and put your learning so far to good use :)

 Exercise 25.1 
	
		The requirements for analysis have stated that some GEO analysis (Mapping) be undertaken.

		In addition some extra column values are required to display single measures as part 
		of the final visualisation i.e. Dashboard

		Hence you will need to modify the above query (i.e. Previous Lecture) to include the
		following data and values...
				
		1) City,State & Country

		2) The aggregation resulting in the column tcSalesTax being populated

		3) The aggregation resulting in the column tcTransportCost being populated

		4) The aggregation resulting in the column tcOrderCount being populated

		5) Copy the rowset into a new Excel spreadsheet and save it as factSalesData in your 
		   Tableau data source area

	** Tips : One of the above column aggregations will require a distinct as part of the expression
		      Ensure you profile your data and pick the correct JOIN to use
			  	

*/

-- Exercise 25.1 Solution

Select
  ProductKey,											
  OrderDate,
  City as City,
  StateProvinceName as State,
  CountryRegionName as Country,
  sum(SalesAmount) as tcSalesValue,									
  sum(TotalProductCost) as tcProductCost,									
  sum(TaxAmt)as tcSalesTax,										
  sum(freight) as tcTransportCost,									
  count(distinct SalesOrderNumber) as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
 OnlineSales os inner join
 Customer cus on os.CustomerKey = cus.CustomerKey left join
 GeoLocation geo on cus.GeographyKey = geo.GeographyKey
where	
 year(OrderDate) between 2017 and 2019 
group by
 ProductKey,
 OrderDate,
 City,
 StateProvinceName,
 CountryRegionName

/*
 Lecture set 280 to 282

 Tableau data visualisations	

 Exercise 25.2

			There are 2 more label sheets required for our visualisations
			
			1: Transport cost $

			2: Transport cost as a percentage of gross sales (this will be a calculated field)

					   
 */


 /*
	Window function : OVER ()
	Basic Syntax as implemented in a query

	select
	  Column(s),											
	  agg(column) as alias,
	  agg(column) over (order by <Column>) as alias				
    from
	  Table(s) 
    where
	  condition(s)
    group by
	  column(s)
	order by
	  column(s)

 */
 -- Lecture set 283 to 286
 
 -- This query will demonstrate how the analyst should think laterally to arrive
 -- at the solution

 -- The requirement is to produce a single daily order count along side a single 
 -- running total order count so we can plot this on a dual value chart 

 -- Visualisation : Daily Orders count with accumulated count trend line

 UNION ALL
    
Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  ovOrderCount,									
  ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
 (
 select
	OrderDate,
	count(distinct [SalesOrderNumber]) as ovOrderCount,
	sum(count(distinct SalesOrderNumber)) over (Order By OrderDate) as ovRunningOrderCount
 from
	OnlineSales 
 where
	year(OrderDate) between 2017 and 2019
 group by
	OrderDate
 ) dt

 /*

 Exercise 25.3

		  Using your knowledge about the OVER () function an analysis is required 
		  for ...

		  1: Sales value over time (i.e. Order Date) 
		  
		  2: Running total of sales over time 

		  3: A Tableau visualisation showing ...

			  a) Bars for the sales total
			  b) Trend line for the accumulated sale

					   
 */

 UNION ALL

Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  ovSalesValue,									
  ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
(
select																						
  OrderDate,
  sum(SalesAmount) as ovSalesValue,
  sum(sum(SalesAmount)) over (Order By OrderDate) as ovRunningSalesTotal
from
  OnlineSales 
where
  year(OrderDate) between 2017 and 2019
group by
  OrderDate
) dt


/*
	Window function : LAG() OVER()
	Basic Syntax as implemented in a query

	select
	  Column(s),											
	  agg(column) as alias,
	  LAG(scalar_expression, offset) OVER (order by <Column>) as alias				
    from
	  Table(s) 
    where
	  condition(s)
    group by
	  column(s)
	order by
	  column(s)

	Nb: a) Scalar means to return a single value from a value expression
	    b) There is also a LEAD () function for accessing rows ahead of the current row

    Lecture set 287 - 291

    The requirement is to produce Month on Month Sales Growth/Shrink both as a 
	monthly $value and %value

    Visualisation : Month on Month $ growth/shrink and % growth/shrink
		            The Month is the finest grain for display on a chart  


*/

	-- Step 1 (Establish the base metric to calculate i.e. Sales Value $ and identify the dimension for the chart)

--select								
--    MonthStartDate as OrderDate,											-- Dimension on Chart as Year/Month only hence use Calendar table to achieve this
--	sum(SalesAmount) as SalesValue
--from 
--	OnlineSales os inner join
--	Calendar cal on os.OrderDate = cal.DisplayDate
--where
--	year(OrderDate) between 2017 and 2019
--group by 
--    MonthStartDate
--order by
--	OrderDate

--	-- Step 2 (Establish the previous month sales value - Just so we can debug/observe the calculation as it unfolds)

--select								
--    MonthStartDate as OrderDate,											-- Dimension on Chart as Year/Month only hence use Calendar table to achieve this
--	sum(SalesAmount) as SalesValue,
--	lag(sum(SalesAmount),1) Over (Order By MonthStartDate)  as PreviousYearMonthSales
--from 
--	OnlineSales os inner join
--	Calendar cal on os.OrderDate = cal.DisplayDate
--where
--	year(OrderDate) between 2017 and 2019
--group by 
--    MonthStartDate
--order by
--	OrderDate

--	-- Step 3 (Subtract previous month sales value from current sales to arrive at a growth/shrink of Sales $) - The first metric for the requirement


--select								
--    MonthStartDate as OrderDate,											-- Dimension on Chart as Year/Month only hence use Calendar table to achieve this
--	sum(SalesAmount) as SalesValue,
--	lag(sum(SalesAmount),1) Over (Order By MonthStartDate)  as PreviousYearMonthSales,
--	sum(SalesAmount) - lag(sum(SalesAmount),1) Over (Order By MonthStartDate) as lagSalesGrowthIn$
--from 
--	OnlineSales os inner join
--	Calendar cal on os.OrderDate = cal.DisplayDate
--where
--	year(OrderDate) between 2017 and 2019
--group by 
--    MonthStartDate
--order by
--	OrderDate


	-- Step 4 (Establish the growth/shrink as a  % of previous month sales value)
    --
	-- Formula = 100 * (
	--           (Current Sales Value - Prev Month Value)  /
	--           Prev Month Value
	--				   )
    --	

UNION ALL

Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  lagSalesGrowthIn$,								 
  lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
(	
select								
    MonthStartDate as OrderDate,											-- Dimension on Chart as Year/Month only hence use Calendar table to achieve this
	sum(SalesAmount) as SalesValue,
	lag(sum(SalesAmount),1) Over (Order By MonthStartDate)  as PreviousYearMonthSales,
	sum(SalesAmount) - lag(sum(SalesAmount),1) Over (Order By MonthStartDate) as lagSalesGrowthIn$,
	100 * (
			(sum(SalesAmount) - lag(sum(SalesAmount),1) Over (Order By MonthStartDate)) /
			lag(sum(SalesAmount),1) Over (Order By MonthStartDate)
		   )
		  as lagSalesGrowthInPercent
from 
	OnlineSales os inner join
	Calendar cal on os.OrderDate = cal.DisplayDate
where
	year(OrderDate) between 2017 and 2019
group by 
    MonthStartDate
) dt

/*

 Exercise 25.4

		  Using your knowledge about the LAG() OVER () function ...
		  
		  Produce a Week on Week Transport cost Growth/Shrink analysis as 
		  Transport is a significant cost point for the business and if this 
		  can be reduced the overall margin can be improved.

		  1: $ Growth/Shrink value of Transport (Freight)
		  
		  2: % Growth/Shrink value of Transport (Freight)

		  3: A Tableau visualisation showing ...

			  a) Bars for the Transport cost
			  b) Trend line for the transport cost %

         Tip: Data set is for 2017 to 2019 inclusive
		      Calendar.WeekStartDate 
					   
 */
 
-- Step 1 (Establish the base metric to calculate i.e. Transport Value $ and identify the dimension for the chart)

--select								
--    WeekStartDate as OrderDate,											
--	sum(Freight) as FreightValue
--from 
--	OnlineSales os inner join
--	Calendar cal on os.OrderDate = cal.DisplayDate
--where
--	year(OrderDate) between 2017 and 2019
--group by 
--    WeekStartDate
--order by
--	WeekStartDate

---- Step 2 (Establish the previous week Transport value - Just so we can debug/observe the calculation as it unfolds)

--select								
--    WeekStartDate as OrderDate,											
--	sum(Freight) as FreightValue,
--	lag(sum(Freight),1) Over (order by WeekStartDate) as PreviousYearWeekFreight
--from 
--	OnlineSales os inner join
--	Calendar cal on os.OrderDate = cal.DisplayDate
--where
--	year(OrderDate) between 2017 and 2019
--group by 
--    WeekStartDate
--order by
--	WeekStartDate


---- Step 3 (Subtract previous week Transport value from current Transport to arrive at a growth/shrink of Transport $) - The first metric for the requirement

--select								
--    WeekStartDate as OrderDate,											
--	sum(Freight) as FreightValue,
--	lag(sum(Freight),1) Over (order by WeekStartDate) as PreviousYearWeekFreight,
--	sum(Freight) - lag(sum(Freight),1) Over (order by WeekStartDate) as lagFreightGrowthIn$
--from 
--	OnlineSales os inner join
--	Calendar cal on os.OrderDate = cal.DisplayDate
--where
--	year(OrderDate) between 2017 and 2019
--group by 
--    WeekStartDate
--order by
--	WeekStartDate

-- Step 4 (Establish the growth/shrink as a % of previous week Transport value)
--
--		Formula = 100 * (
--						(Current Freight Value - Prev week Value)  /
--						 Prev week Value
--				        )
--	

UNION ALL

Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  lagFreightGrowthIn$,								
  lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
(	
select								
    WeekStartDate as OrderDate,											
	sum(Freight) as TransportValue,
	lag(sum(Freight),1) Over (Order By WeekStartDate)  as PreviousYearWeekFreight,
	sum(Freight) - lag(sum(Freight),1) Over (Order By WeekStartDate) as lagFreightGrowthIn$,
	100 * (
			(sum(Freight) - lag(sum(Freight),1) Over (Order By WeekStartDate)) /
			lag(sum(Freight),1) Over (Order By WeekStartDate)
		   )
		  as lagFreightGrowthInPercent
from 
	OnlineSales os inner join
	Calendar cal on os.OrderDate = cal.DisplayDate
where
	year(OrderDate) between 2017 and 2019
group by 
    WeekStartDate
) dt

/*
	Window function : OVER(Preceding)
	Basic Syntax as implemented in a query

	select
	  Column(s),											
	  agg(column) as alias,
	  agg(column) OVER (order by <Column> rows between nn preceding and current row) as alias				
    from
	  Table(s) 
    where
	  condition(s)
    group by
	  column(s)
	order by
	  column(s)

	Nb: a) nn is the number of rows that are desired preceding (& Including) the current row.
		b) There is also a OVER(Following) function for accessing rows ahead of the current row

    Lecture set 292 to 295

    The requirement is to provide a moving average sales analysis alongside the daily sales total 
    Visualisation : Show the 3 year sales trend with a moving average to smooth the daily sales  


*/
UNION ALL

Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  mvSalesValue,											 
  mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from

-- Step 2 : Calculate the moving average of the sales totals from the below derived table
(
select
	OrderDate,
	mvSalesValue,
	avg(mvSalesValue) over (Order By OrderDate rows between 30 preceding and current row ) as mvAvgSales

-- Step 1 : Establish the Daily Sales Totals    
from
(
select											
	OrderDate,
	sum(SalesAmount) as mvSalesValue
from
	OnlineSales  
where
	year(OrderDate) between 2017 and 2019
group by 
	OrderDate
) dt
) dtMvAvgSales

/*

 Exercise 25.5

		  Using your knowledge about the OVER (Preceding) function ...
		  
		  Produce an analysis of the number of Sales Orders along with the
		  moving average of these

		  Visualisation : Show the 3 year sales order trend with a moving average for smoothing

		  Tip: Experiment with various values in the preceding rows to find your optimum 
		       smoothing on the visualisation.

			   There is no right or wrong answer here, use your judgement as after all you
			   maybe expressing an opinion to your user as to why this should be used over 
			   others that may be presented.
 					   
 */
 
UNION ALL

Select
  0 as ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  mvOrderCount,
  mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
-- Step 2 : Calculate the moving average of the sales orders from the below derived table
(
select
	OrderDate,
	mvOrderCount,
	avg(mvOrderCount) Over (Order by OrderDate rows between 30 preceding and current row) as mvAvgOrders

-- Step 1 : Establish the Daily Sales Orders (Count)

from
(
select											
	OrderDate,
	count(distinct SalesOrderNumber) as mvOrderCount
from
	OnlineSales 
where
	year(OrderDate) between 2017 and 2019
group by 
	OrderDate
) dt
) dtMvAvagOrders


/*

	Notes : The Cross Join can be used to generate a paired combination of each row in 
	        Table 1 with each row of Table 2.
	
			! Caution : Query Performance will be adversely affected by large cartesian 
			            product results e.g Millions to Billions of rows

	Basic Syntax as implemented in a query

	select
		Columns
	from
		Table 1 cross join
		Table 2 

	Scenario:

	To provide a visualisation of the distribution of all Products that were either 
	Sold/Not Sold via the Sales Types contained in the SaleType table e.g. TV Advertisement
	
	Hence a status of (Had Sale(s) / No Sale) should be evaluated across all
	Sales transactions between 2017 and 2019 
	
	This is presented as a 2 Step method 
	
    Lecture set 296 to 300

*/

-- Step 1 : Cross Join acts as the source data for the Left Outer Join 

 --  select
 --   *
 --  from
	--SaleType st cross join
	--Product prod
 --  Where
 --   ProductKey>0

-- Step 2 : A Derived table is formed using the Left Outer Join providing the row set
--			for our visualisation of the sale type distribution

UNION ALL

Select
  ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  '' as Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  xjSaleTypeName,									 
  xjSaleStatus,
  '' as xjGeoSaleStatus,
  0 as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
(
   select
    prod.ProductKey,
	st.SaleTypeName as xjSaleTypeName,
	case
  	  when SalesValue > 0 then 'Had Sale(s)'
	  when SalesValue is null then 'No Sale'
	 end as xjSaleStatus,
	'2019-12-31' as OrderDate
   from
	SaleType st cross join
	Product prod left join
    (
	select
		SaleTypeKey,
		ProductKey,
		sum(SalesAmount) as SalesValue
	from
		OnlineSales
	where
		year(OrderDate) between 2017 and 2019 
	group by
		SaleTypeKey,
		ProductKey
    ) as SaleTypeSales on SaleTypeSales.SaleTypeKey = st.SaleTypeKey and
						  SaleTypeSales.ProductKey = prod.ProductKey

   Where
    prod.ProductKey>0
) dt

/*

 Exercise 25.6

		  Using your knowledge about the cross join shown previously...
		  
		  Analyse the customer geography to establish where in the world products were sold or not 
		  sold via the various Sale Types.

		  1: Your query structure will ...

			 a) Cross Join Geography and Products (Outer Query)
			 
			 b) Join to a derived table that returns the Sales Value across
			    the Countries reference by Online Sales
				
		 2: The data set is for 3 years 2017 to 2019 Incl.

		 3: The Union Row set will include the count of the Sale Status 
		    
			(You can observe the placeholder in the template as a clue) 

		 4: The Tableau visualistion will not be a MAP (We cover geo analytics later on) ! 
		    
			It will be a stacked bar chart that ...

			a) Shows the Product Category by Country

			b) Shows the count of the Sale Status by Product Category / Country	 (Hint - Create a calculated field)   

			c) Locate the NULL value in the visualisation and filter this out

			d) Set the colourisation for the bars using the appropriate dimension 

			   Colouring is up to you and your artistic talent :) 

   		5: Here is a quick hint of what the chart may appear to be once created.
		
 */
 
UNION ALL

Select
  ProductKey,											
  OrderDate,
  '' as City,
  '' as State,
  Country,
  0 as tcSalesValue,									
  0 as tcProductCost,									
  0	as tcSalesTax,										
  0 as tcTransportCost,									
  0 as tcOrderCount,									
  0 as ovOrderCount,									
  0 as ovRunningOrderCount,								
  0 as ovSalesValue,									
  0 as ovRunningSalesTotal,								
  0 as lagSalesGrowthIn$,								 
  0 as lagSalesGrowthInPercent,							
  0 as lagFreightGrowthIn$,								
  0 as lagFreightGrowthInPercent,						
  0 as mvSalesValue,											 
  0 as mvAvgSales,
  0 as mvOrderCount,
  0 as mvAvgOrders,
  '' as xjSaleTypeName,									 
  '' as xjSaleStatus,
  xjGeoSaleStatus,
  count(xjGeoSaleStatus) as xjGeoSaleStatusCount,
  0 as cteAverageCustSales$,
  0 as cteAvgOrderProductQty
from
   (
  	select
	  distinct(prod.ProductKey),
	  geo.CountryRegionName as Country,
	case
  	  when SalesValue > 0 then 'Had Sale(s)'
	  when SalesValue is null then 'No Sale'
	 end as xjGeoSaleStatus,
	 '2019-12-31' as OrderDate
	from
	  GeoLocation geo cross join					-- >> Card: 616
	  Product prod 	left join						-- >> Card: 606				: 616 X 606 = Cartesian Product 373,296 rows	
	(
	   select
			 cus.GeographyKey
			,ProductKey
			,sum(SalesAmount) as SalesValue	
		from
			OnlineSales os inner join
			Customer cus on os.CustomerKey = cus.CustomerKey
		where 
			year(OrderDate) between 2017 and 2019 
		group by
			 GeographyKey
			,ProductKey	
	) as geoSaleTypedSales ON geoSaleTypedSales.GeographyKey = geo.GeographyKey and
						      geoSaleTypedSales.ProductKey = prod.ProductKey
	where 
	  prod.ProductKey > 0
    ) dt
group by
	ProductKey,
	Country,
	xjGeoSaleStatus,
	OrderDate

/*
	UNION ALL	<<< Note: cannot use UNION ALL in the result set above, it will need to 
					be appended to the data source excel file, still use the template
					though, just a small inconvenience but we need to know how CTE's are
					built and applied !!

	Common Table Expression - CTE
	
	Specifies a temporary named result set, not unlike a derived table

	Basic Syntax as implemented in a query

	WITH CTE_Name (Colum1,Column2,Column3,...)				1: CTE is a named derived table providing a subset of data
	AS														   Note that the SELECT and WITH column count must match
	(
		Select
			column(s)
		From
			Table(s)
		Where
			condition(s)
		Group By
			Column(s)
	)

	Select													2: Queries can be written referencing the CTE to support a requirement
		column(s) 
	From
		CTE_Name
	Where
		condition(s)
	Group By
		column(s)

	Lecture set 301 to 305

*/

	-- Scenario :

	-- To provide a yearly (2017,2018,2019) average total sale value

	-- Can't we just average all Purchase Values for Customers , why use a CTE ?
	-- Let's try this ...
	
	select 
		avg(SalesAmount) as AvgSales 
	from 
		OnlineSales
	where
		year(OrderDate) = 2019 

	SELECT 
		CustomerKey, 
		avg(SalesAmount) as CustAvgPurchaseAmount,
		sum(SalesAmount) as CustPurchaseValue,
		count(ProductKey) as CustOrderItemCount
    FROM	
		OnlineSales  
	where
		year(OrderDate) = 2019 
    GROUP BY 
		CustomerKey
	order by 
		CustomerKey

    -- Now paste the results into Excel and observe the average for 2019

	-- This is where we can leverage the CTE to provide the correct average for our data!

	/* When building your CTE first consider ...
	
		1: The inner query, i.e what is it you want to extract as the named result set ?

			e.g. Return a set of rows for each customer showing their total purchase value (aka Sales Value)

		2: The final use, i.e what is the second select trying to achieve for the required output

		   e.g. Return the average total sale calculated from the CTE and grouped by each year

	*/

	with Sales_CTE (OrderDate,CustomerKey,SalesValue)
	AS
	(
	select
		cast(year(OrderDate) as char(4)) + '-01-01' as OrderDate,
		CustomerKey,
		sum(SalesAmount) as SalesValue
	from
		OnlineSales
	where
		year(OrderDate) between 2017 and 2019
	group by
		Year(OrderDate),
		CustomerKey
	)
	Select
	  0 as ProductKey,											
	  OrderDate,
	  '' as City,
	  '' as State,
	  '' as Country,
	  0 as tcSalesValue,									
	  0 as tcProductCost,									
	  0	as tcSalesTax,										
	  0 as tcTransportCost,									
	  0 as tcOrderCount,									
	  0 as ovOrderCount,									
	  0 as ovRunningOrderCount,								
	  0 as ovSalesValue,									
	  0 as ovRunningSalesTotal,								
	  0 as lagSalesGrowthIn$,								 
	  0 as lagSalesGrowthInPercent,							
	  0 as lagFreightGrowthIn$,								
	  0 as lagFreightGrowthInPercent,						
	  0 as mvSalesValue,											 
	  0 as mvAvgSales,
	  0 as mvOrderCount,
	  0 as mvAvgOrders,
	  '' as xjSaleTypeName,									 
	  '' as xjSaleStatus,
	  '' as xjGeoSaleStatus,
	  0 as xjGeoSaleStatusCount,
  	 avg(SalesValue) as cteAverageCustSales$,
	 0 as cteAvgOrderProductQty
	from
		Sales_CTE
	group by
		OrderDate
	order by
		OrderDate;

/*

 Exercise 25.7

		  Using your knowledge about the CTE shown previously...
		
		  1: Create a CTE to solve ...

		     The average number of products purchased for 2017,2018,2019

		  2: Visualise this in a Tableau label worksheet using the same concepts 
		     as the Sales Average $

		  Hint : There is no hint :) you are flying solo here, no tips or hints 


*/

	WITH Orders_CTE (OrderDate,CustomerKey,OrderProductQty ) 
	AS  
	(  
		SELECT  
			cast(year(Orderdate) as char(4)) + '-01-01'  as OrderDate, 
			CustomerKey,
			count(ProductKey) as OrderProductQty
		FROM	
			OnlineSales  
		where
			year(OrderDate) between 2017 and 2019
		GROUP BY 
			year(Orderdate),
			CustomerKey,
			SalesOrderNumber	
		)  
	SELECT 
	  0 as ProductKey,											
	  OrderDate,
	  '' as City,
	  '' as State,
	  '' as Country,
	  0 as tcSalesValue,									
	  0 as tcProductCost,									
	  0	as tcSalesTax,										
	  0 as tcTransportCost,									
	  0 as tcOrderCount,									
	  0 as ovOrderCount,									
	  0 as ovRunningOrderCount,								
	  0 as ovSalesValue,									
	  0 as ovRunningSalesTotal,								
	  0 as lagSalesGrowthIn$,								 
	  0 as lagSalesGrowthInPercent,							
	  0 as lagFreightGrowthIn$,								
	  0 as lagFreightGrowthInPercent,						
	  0 as mvSalesValue,											 
	  0 as mvAvgSales,
	  0 as mvOrderCount,
	  0 as mvAvgOrders,
	  '' as xjSaleTypeName,									 
	  '' as xjSaleStatus,
	  '' as xjGeoSaleStatus,
	  0 as xjGeoSaleStatusCount,
  	  0 as cteAverageCustSales$,
  	 avg(OrderProductQty) AS cteAvgOrderProductQty
	FROM 
		Orders_CTE
	Group By
		OrderDate
	order by 
		OrderDate desc


		/*

		  Exercise 25.8

		  Using your knowledge about Tableau Maps ...

		  1: Create a Map of the Global transport cost

		  The map should show ... 
		  
			a) Country,State,City
			
			b) Bubble size by transport cost 

			c) Colourized to suit 

		*/