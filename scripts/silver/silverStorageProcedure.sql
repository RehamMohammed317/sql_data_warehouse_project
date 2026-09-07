CREATE or ALTER PROCEDURE silver.load_silver as
BEGIN
  DECLARE @start_time datetime ,@end_time Datetime ;
  BEGIN TRY
        print '==================================';
		print 'Loading silver layer';
		print '==================================';
		print '----------------------------------';
		print 'Loading CRM Tables';
		print '----------------------------------';
		print' Truncate table silver.crm_sales_details '
		SET @start_time=getdate();
		TRUNCATE TABLE silver.crm_sales_details ;
		truncate table silver.crm_sales_details 
		insert into silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_quantity,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_price
		)
		Select 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_quantity,

		case 
		  when sls_order_dt =0 or len(sls_order_dt) !=8 then null
		  else cast(cast(sls_order_dt as varchar)as date)
		end as sls_order_dt,
		case 
		  when sls_ship_dt =0 or len(sls_ship_dt) !=8 then null
		  else cast(cast(sls_ship_dt as varchar)as date)
		end as sls_ship_dt,
		case 
		  when sls_due_dt =0 or len(sls_due_dt) !=8 then null
		  else cast(cast(sls_due_dt as varchar)as date)
		end as sls_due_dt,
		case when sls_sales is null or sls_sales <=0 or sls_sales !=sls_quantity * sls_price
		then sls_quantity * abs(sls_price)
		else sls_sales
		end sls_sales ,
		case when sls_price is null or sls_price <=0
		then sls_sales/nullif(sls_quantity,0)
		else sls_price
		end sls_price


		from bronze.crm_sales_details;
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';

		print'===================================================='

		print' Truncate table silver.crm_cust_info '
				SET @start_time=getdate();
				TRUNCATE TABLE silver.crm_cust_info ;
		Insert into silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_gndr,
		cst_matrerial_status,
		cst_create_date

		)
		SELECT
		cst_id,
		cst_key,
		trim(cst_firstname) as cst_firstname,
		trim(cst_lastname) as cst_lastname,
		case when upper(Trim(cst_gndr)) = 'F' THEN 'Female'
			 when upper(trim(cst_gndr)) = 'M' THEN 'Male'
			 ELSE 'n/a'
		END cst_gndr,
		case when upper(Trim(cst_matrerial_status)) = 'M' THEN 'Married'
			 when upper(trim(cst_matrerial_status)) = 'S' THEN 'Single'
			 ELSE 'n/a'
		END cst_matrerial_status,
		cst_create_date

		FROM
			(SELECT
			*, 
			ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as flag_last
			from bronze.crm_cust_info
			where cst_id  is not null
		)t
		where flag_last =1 ;
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';
		print'==============================================================================='

		print' Truncate table silver.crm_prd_info'
				SET @start_time=getdate();
				TRUNCATE TABLE silver.crm_prd_info;
		insert into silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)
		select
		prd_id,
		replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
		SUBSTRING(prd_key,7,len(prd_key))as prd_key,
		isnull(prd_cost,0) as prd_cost,
		case upper(trim(prd_line))
		when 'M' then 'Mountain'
		when 'R' then 'Road'
		when 'S' then 'Other sales'
		when 'T' then 'Touring'
		else 'n/a'
		end as prd_line,
		cast(prd_start_dt as date) as prd_start_dt,
		cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1 as date )as prd_end_dt_test
		from bronze.crm_prd_info;
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';
		print'================================================================================='
		print '----------------------------------';
		print 'Loading ERP Tables';
		print '----------------------------------';

		print' Truncate table silver.erp_cust_az12'
				SET @start_time=getdate();
				TRUNCATE TABLE silver.erp_cust_az12;

		insert into silver.erp_cust_az12
		(cid,
		bdate,
		gen
		)
		select
		case when cid like 'NAS%' then substring (cid,4,len(cid))
		else cid 
		end cid,
		case when bdate > getdate () then null
		else bdate
		end bdate,
		case when trim(upper(gen)) in ('F' ,'Female')
		then  'Female'
		when trim(upper(gen)) in ('M', 'Male')
		then 'Male'
		else 'n/a'
		end gen
		from bronze.erp_cust_az12;
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';

		print'====================================================================================='

		print' Truncate table silver.erp_px_cat_g1v2'
				SET @start_time=getdate();
				TRUNCATE TABLE silver.erp_px_cat_g1v2;

		insert into silver.erp_px_cat_g1v2
		(id, cat,subcat,maintenance)
		select 
		id,
		cat,
		subcat,
		maintenance
		from bronze.erp_px_cat_g1v2;
		/*
		--check for unwanted spaces
		select * from bronze.erp_px_cat_g1v2
		where cat !=trim(cat) or subcat !=trim(subcat) or maintenance !=trim(maintenance)
 

		 --data standardization & consistency
		 select distinct cat
		 from bronze.erp_px_cat_g1v2

		 select distinct subcat
		 from bronze.erp_px_cat_g1v2

		 select distinct maintenance
		 from bronze.erp_px_cat_g1v2;
		 */
		 SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';

		 print'=========================================================================================='
		 print' Truncate table silver.erp_loc_a101'
				SET @start_time=getdate();
				TRUNCATE TABLE silver.erp_loc_a101;
		 insert into silver.erp_loc_a101
		 (cid,cntry)
		select
		Replace (cid,'-','') cid,
		case 
		when trim(cntry)='DE' then 'Germany'
		when trim(cntry) in('US','USA') then 'United States'
		when trim(cntry)='' or cntry is null then 'n/a'
		else trim(cntry)
		end cntry
		from bronze.erp_loc_a101 ;
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';
END TRY
  BEGIN CATCH
  print '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
  print 'error acourred during loading bronze layer'
  print 'Error Message'+ERROR_MESSAGE();
  print 'Error Message'+CAST(ERROR_NUMBER() AS NVARCHAR);
  print 'Error Message'+CAST(ERROR_STATE() AS NVARCHAR);
  print '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
  END CATCH
END
