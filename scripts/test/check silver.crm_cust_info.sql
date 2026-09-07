--check for nulls or duplicates in PK in crm_cust_info
--expectation : no results
SELECT 
cst_id,
count(*)
from silver.crm_cust_info
Group by cst_id
Having count(*)>1 or cst_id is null


--check unwanted spaces
--expectation : no results
select cst_firstname
from silver.crm_cust_info
where cst_firstname != trim(cst_firstname)

select cst_gndr
from silver.crm_cust_info
where cst_gndr != trim(cst_gndr)

--data standardization & consistency
select distinct cst_gndr
from silver.crm_cust_info

