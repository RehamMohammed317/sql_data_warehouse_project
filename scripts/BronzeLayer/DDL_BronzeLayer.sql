CREATE TABLE bronze.crm_cust_info(
cst_id INT,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_matrerial_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date 
);
GO

CREATE TABLE bronze.crm_prd_info(
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt datetime,
prd_end_dt datetime
);
GO

CREATE TABLE bronze.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);
GO

CREATE TABLE bronze.erp_loc_a101(
cid nvarchar(50),
cntry nvarchar(50));
GO


CREATE TABLE bronze.erp_cust_a212(
cid nvarchar(50),
bdate date,
gen nvarchar(50));
GO

CREATE TABLE bronze.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcate nvarchar(50),
maintenance nvarchar(50)
)
