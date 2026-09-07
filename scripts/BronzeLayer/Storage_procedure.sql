CREATE or ALTER PROCEDURE bronze.load_bronze as
BEGIN
  DECLARE @start_time datetime ,@end_time Datetime ;
  BEGIN TRY
        print '==================================';
		print 'Loading bronze layer';
		print '==================================';
		print '----------------------------------';
		print 'Loading CRM Tables';
		print '----------------------------------';
		print' Truncate table bronze.crm_cust_info'
		SET @start_time=getdate();
		TRUNCATE TABLE bronze.crm_cust_info;
		print' Insert table bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\reham\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR = ',',
		TABLOCK

		);
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';
		--SELECT COUNT(*) FROM bronze.crm_cust_info
		print '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'

		--bronze.crm_prd_info
		print' Truncate table bronze.crm_prd_info'
		SET @start_time=getdate();
		TRUNCATE TABLE bronze.crm_prd_info;
		print' Insert table bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\reham\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR=',',
		TABLOCK

		);
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';
		--SELECT COUNT(*) FROM bronze.crm_prd_info
		print '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
		--bronze.crm_sales_details
		print' Truncate table bronze.crm_sales_details'
		SET @start_time=getdate();
		TRUNCATE TABLE bronze.crm_sales_details;
		print' Insert table bronze.crm_sales_details '
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\reham\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR=',',
		TABLOCK

		);
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';
		--SELECT COUNT(*) FROM bronze.crm_sales_details
		print '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'

		print '--------------------------------';
		print 'Loading ERP tables ';
		print '--------------------------------';
		--bronze.erp_loc_a101
		print' Truncate table bronze.erp_loc_a101'
		SET @start_time=getdate();
		TRUNCATE TABLE bronze.erp_loc_a101;
		print' Insert table bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\reham\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR=',',
		TABLOCK

		);
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';
		--SELECT COUNT(*) FROM bronze.erp_loc_a101
		print '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
		--bronze.erp_cust_a212
		print' Truncate table bronze.erp_cust_a212'
		SET @start_time=getdate();
		TRUNCATE TABLE bronze.erp_cust_a212;
		print' Insert table bronze.erp_cust_a212'
		BULK INSERT bronze.erp_cust_a212
		FROM 'C:\Users\reham\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR=',',
		TABLOCK

		);
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';
		--SELECT COUNT(*) FROM bronze.erp_cust_a212
		print '^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'
		--bronze.erp_px_cat_g1v2
		print' Truncate table bronze.erp_px_cat_g1v2'
		SET @start_time=getdate();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		print' Insert table bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\reham\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
		FIRSTROW =2,
		FIELDTERMINATOR=',',
		TABLOCK

		);
		SET @end_time=GETDATE();
		print 'Load duration:'+CAST(DATEDIFF(second,@start_time,@end_time)AS nvarchar) +'Secounds';
		--SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2
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