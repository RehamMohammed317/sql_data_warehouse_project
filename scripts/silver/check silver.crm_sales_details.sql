--check silver crm_sales_details
select
nullif (sls_ship_dt,0) sls_ship_dt
from silver.crm_sales_details
where sls_ship_dt <=0
or len(sls_ship_dt) <=0
or sls_ship_dt > 205000101
or sls_ship_dt < 19000101

select
nullif (sls_order_dt,0) sls_order_dt
from silver.crm_sales_details
where sls_order_dt <=0
or len(sls_order_dt) <=0
or sls_order_dt > 205000101
or sls_order_dt < 19000101

select
nullif (sls_due_dt,0) sls_due_dt
from silver.crm_sales_details
where sls_due_dt <=0
or len(sls_due_dt) <=0
or sls_due_dt > 205000101
or sls_due_dt < 19000101

--check data consistency : between sales ,quantity and product
-- sales = quantity * product
-- value must not null or 0 or -ve
Select 
sls_sales as old_sales,
sls_quantity,
sls_price as old_price,
case when sls_sales is null or sls_sales <=0 or sls_sales !=sls_quantity * sls_price
then sls_quantity * abs(sls_price)
else sls_sales
end sls_sales ,
case when sls_price is null or sls_price <=0
then sls_sales/nullif(sls_quantity,0)
else sls_price
end sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price or sls_sales <=0 or sls_sales is null
-- Rules to fix this 
--must ask data source
--1)if sales is -ve ,0,null then derive it using quantity and price
--2) if price is zero or null calculate it usnig sales and quantity
--3) if price is -ve convert it to +ve value
