--check silver.erp_cust_az12
select distinct 
bdate 
from silver.erp_cust_az12
where bdate <'1924-01-01' OR bdate >getDate()

--data standardization & consistency
select distinct gen
from silver.erp_cust_az12
