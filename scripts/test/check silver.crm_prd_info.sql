
--silver layer checks 
--check for nulls or duplicates in PK
--expected : no result
Select
prd_id,
count(*)
from silver.crm_prd_info
group by prd_id
having count(*)>1 or prd_id is null

Select
prd_key,
count(*)
from silver.crm_prd_info 
group by prd_key
having count(*)>1 or prd_key is null

--check for unwanted spaces
--expectation :no results
select prd_nm
from silver.crm_prd_info
where prd_nm !=trim(prd_nm)


--check for nulls or negative numbers
-- expectation: no results
select prd_cost
from silver.crm_prd_info
where prd_cost <0 or prd_cost is null

--data standarization & consistency

select distinct prd_line
from silver.crm_prd_info

--check for invalid date orders
select *
from silver.crm_prd_info 
where prd_end_dt <prd_start_dt