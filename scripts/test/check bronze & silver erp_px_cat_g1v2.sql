--check for unwanted spaces
select * from bronze.erp_px_cat_g1v2
where cat !=trim(cat) or subcat !=trim(subcat) or maintenance !=trim(maintenance)
 

 --data standardization & consistency
 select distinct cat
 from bronze.erp_px_cat_g1v2

 select distinct subcat
 from bronze.erp_px_cat_g1v2

 select distinct maintenance
 from bronze.erp_px_cat_g1v2


 --silver
 --check for unwanted spaces
select * from silver.erp_px_cat_g1v2
where cat !=trim(cat) or subcat !=trim(subcat) or maintenance !=trim(maintenance)
 

 --data standardization & consistency
 select distinct cat
 from silver.erp_px_cat_g1v2

 select distinct subcat
 from silver.erp_px_cat_g1v2

 select distinct maintenance
 from silver.erp_px_cat_g1v2