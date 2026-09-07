--check identify out-of-range dates 
select distinct 
bdate 
from bronze.erp_cust_az12
where bdate <'1924-01-01' OR bdate >getDate()

--data standardization & consistency
select distinct gen
from bronze.erp_cust_az12
