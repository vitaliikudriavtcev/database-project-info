
CREATE PROCEDURE [DDL].[CreateAllObjects]
AS
BEGIN

  DECLARE @MaxRows            BIGINT = 100000
  DECLARE @MaxRowsSmall       BIGINT = 10000
  DECLARE @InsertRows         BIGINT = 150000
  DECLARE @UpdateFrom         BIGINT = 1000
  DECLARE @UpdateThru         BIGINT = 5000
  DECLARE @InsertRowsSmallT1  BIGINT = 15000
  DECLARE @InsertRowsSmallT2  BIGINT = 20000
  DECLARE @UpdateFromT1       BIGINT = 100
  DECLARE @UpdateThruT1       BIGINT = 500
  DECLARE @UpdateFromT2       BIGINT = 1000
  DECLARE @UpdateThruT2       BIGINT = 1500
  DECLARE @DeleteFrom         BIGINT = 6000
  DECLARE @DeleteThru         BIGINT = 7000
  DECLARE @IncludeType2       BIT = 1
  DECLARE @DoNotIncludeType2  BIT = 0
  DECLARE @IncludeDelete      BIT = 1

  PRINT 'Creating 01_Trunc_and_Load with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '01_Trunc_and_Load', @MaxRows

  PRINT 'Creating 02_SCD_Type_1 with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '02_SCD_Type_1', @MaxRowsSmall

  PRINT 'Creating 03_SCD_Type_2 with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '03_SCD_Type_2', @MaxRowsSmall

  PRINT 'Creating 04_Set_Based_Type_1 with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '04_Set_Based_Type_1', @MaxRows

  PRINT 'Creating 04_Set_Based_Type_2 with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '04_Set_Based_Type_2', @MaxRows

  PRINT 'Creating 05_Hashbytes_DiffDb with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '05_Hashbytes_DiffDb', @MaxRows

  PRINT 'Creating 06_Hashbytes_SameDb with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '06_Hashbytes_SameDb', @MaxRows

  PRINT 'Creating 07_CDC with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '07_CDC', @MaxRows

  PRINT 'Creating 08_Merge with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '08_Merge', @MaxRows

  PRINT 'Creating 09_Date_Based with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '09_Date_Based', @MaxRows
  
  PRINT 'Creating 10_Fact with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '10_Fact', @MaxRows

  EXEC DDL.CreateSourceTable 'Target', '10_Fact_FakeDim1', 150000
  EXEC DDL.CreateSourceTable 'Target', '10_Fact_FakeDim2', 150000
  EXEC DDL.CreateSourceTable 'Target', '10_Fact_FakeDim3', 150000

  PRINT 'Creating 13_Task_Factory_SCD with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '13_Task_Factory_SCD', @MaxRows


  PRINT 'Creating Target Tables'
  EXEC DDL.CreateTargetTable 'Target', '01_Trunc_and_Load'
  EXEC DDL.CreateTargetTable 'Target', '02_SCD_Type_1'
  EXEC DDL.CreateTargetTable 'Target', '03_SCD_Type_2', @IncludeType2
  EXEC DDL.CreateTargetTable 'Target', '04_Set_Based_Type_1'
  EXEC DDL.CreateTargetTable 'Target', '04_Set_Based_Type_2', @IncludeType2
  EXEC DDL.CreateTargetTable 'Target', '05_Hashbytes_DiffDb' 
  EXEC DDL.CreateTargetTable 'Target', '06_Hashbytes_SameDb' 
  EXEC DDL.CreateTargetTable 'Target', '07_CDC'
  EXEC DDL.CreateTargetTable 'Target', '08_Merge'
  EXEC DDL.CreateTargetTable 'Target', '09_Date_Based'
  EXEC DDL.CreateFactTable   'Target', '10_Fact'
  EXEC DDL.CreateTargetTable 'Target', '13_Task_Factory_SCD', @IncludeType2


  PRINT 'Creating ETL Tables'
  EXEC [DDL].[CreateETLTable] '04_Set_Based_Type_1'
  EXEC [DDL].[CreateETLTable] '04_Set_Based_Type_2', @IncludeType2, @IncludeDelete 
  EXEC [DDL].[CreateETLTable] '05_Hashbytes_DiffDb'
  EXEC [DDL].[CreateETLTable] '06_Hashbytes_SameDb', @DoNotIncludeType2, @IncludeDelete
  EXEC [DDL].[CreateETLTable] '07_CDC', @DoNotIncludeType2, @IncludeDelete
  EXEC [DDL].[CreateETLTable] '09_Date_Based'
  EXEC [DDL].[CreateFactTable] 'ETL', '10_Fact_Update'
  EXEC [DDL].[CreateETLTable] '13_Task_Factory_SCD', @IncludeType2, @IncludeDelete 
  
  
  PRINT 'Creating Stored Procedures'
  EXEC [DDL].[CreateCUDProcs] 'CUD', '01_Trunc_and_Load',       'Source', '01_Trunc_and_Load' 
  EXEC [DDL].[CreateCUDProcs] 'CUD', '02_SCD_Type_1',           'Source', '02_SCD_Type_1' 

  EXEC [DDL].[CreateCUDProcs] 'CUD', '03_SCD_Type_2_T1',        'Source', '03_SCD_Type_2' 
  EXEC [DDL].[CreateCUDProcs] 'CUD', '03_SCD_Type_2_T2',        'Source', '03_SCD_Type_2' 

  EXEC [DDL].[CreateCUDProcs] 'CUD', '04_Set_Based_Type_1' ,    'Source', '04_Set_Based_Type_1' 

  EXEC [DDL].[CreateCUDProcs] 'CUD', '04_Set_Based_Type_2_T1' , 'Source', '04_Set_Based_Type_2' 
  EXEC [DDL].[CreateCUDProcs] 'CUD', '04_Set_Based_Type_2_T2' , 'Source', '04_Set_Based_Type_2' 

  EXEC [DDL].[CreateCUDProcs] 'CUD', '05_Hashbytes_DiffDb' ,    'Source', '05_Hashbytes_DiffDb' 
  EXEC [DDL].[CreateCUDProcs] 'CUD', '06_Hashbytes_SameDb' ,    'Source', '06_Hashbytes_SameDb' 
  EXEC [DDL].[CreateCUDProcs] 'CUD', '07_CDC'       ,           'Source', '07_CDC'        
  EXEC [DDL].[CreateCUDProcs] 'CUD', '08_Merge'     ,           'Source', '08_Merge'      
  EXEC [DDL].[CreateCUDProcs] 'CUD', '09_Date_Based',           'Source', '09_Date_Based' 

  EXEC [DDL].[CreateCUDProcs] 'CUD', '10_Fact',                 'Source', '10_Fact' 

  EXEC [DDL].[CreateCUDProcs] 'CUD', '13_Task_Factory_SCD_T1' , 'Source', '13_Task_Factory_SCD' 
  EXEC [DDL].[CreateCUDProcs] 'CUD', '13_Task_Factory_SCD_T2' , 'Source', '13_Task_Factory_SCD' 

  PRINT 'Creating Admin.Settings Table'
  IF (NOT EXISTS (SELECT * 
                    FROM INFORMATION_SCHEMA.TABLES 
                   WHERE TABLE_SCHEMA = 'Admin' 
                     AND TABLE_NAME = 'Settings'
                 )
     )
  BEGIN
    CREATE TABLE [Admin].[Settings]
    (
      [Package] NVARCHAR(255)  NOT NULL
    , [Key]     NVARCHAR(255)  NOT NULL
    , [Value]   NVARCHAR(2000) NOT NULL
    )
  END

  IF (NOT EXISTS (SELECT 1 
                    FROM [Admin].[Settings]
                   WHERE [Package] = '14_1_AdminSettings_Master'
                     AND [Key] = 'PretendConnectionString'
                 )
     )
  BEGIN
    INSERT INTO [Admin].[Settings]
      ([Package], [Key], [Value])
    VALUES 
      ('14_1_AdminSettings_Master', 'PretendConnectionString', 'Here is a pretend connection string')
  END

  IF (NOT EXISTS (SELECT 1 
                    FROM [Admin].[Settings]
                   WHERE [Package] = '14_3_AdminSettings_Child_2'
                     AND [Key] = 'RunPackage'
                 )
     )
  BEGIN
    INSERT INTO [Admin].[Settings]
      ([Package], [Key], [Value])
    VALUES 
      ('14_3_AdminSettings_Child_2', 'RunPackage', 'Y')
  END   


  IF (NOT EXISTS (SELECT 1 
                    FROM [Admin].[Settings]
                   WHERE [Package] = '14_4_AdminSettings_Child_3'
                     AND [Key] = 'Loop'
                     AND [Value] = 'Loop 1'
                 )
     )
  BEGIN
    INSERT INTO [Admin].[Settings]
      ([Package], [Key], [Value])
    VALUES 
        ('14_4_AdminSettings_Child_3', 'Loop', 'Loop 1')
      , ('14_4_AdminSettings_Child_3', 'Loop', 'Loop 2')
      , ('14_4_AdminSettings_Child_3', 'Loop', 'Loop 3')
  END   

    PRINT 'Creating Admin.LoadBalancer Table'
  IF (NOT EXISTS (SELECT * 
                    FROM INFORMATION_SCHEMA.TABLES 
                   WHERE TABLE_SCHEMA = 'Admin' 
                     AND TABLE_NAME = 'LoadBalancer'
                 )
     )
  BEGIN
    CREATE TABLE [Admin].[LoadBalancer]
    (
	  [LoadBalancerKey] INT IDENTITY NOT NULL
    , [Package] NVARCHAR(255)  NOT NULL
    , [LoadPath] INT  NOT NULL
	, [LoadOrder] INT NOT NULL
    , [RunPackage] NCHAR(1) NOT NULL DEFAULT 'Y'
	, [Parameter] NVARCHAR(255) NULL
    )
  END
  ;

  TRUNCATE TABLE [Admin].[LoadBalancer];
  
  INSERT INTO [Admin].[LoadBalancer]
    ( [Package], [LoadPath], [LoadOrder], [RunPackage], [Parameter] )
  VALUES
    ( '15_2_LoadBalancer_Child_1.dtsx', 1, 10, 'Y', 'Order 10 Path 1 Child 1' )
  , ( '15_3_LoadBalancer_Child_2.dtsx', 2, 20, 'Y', 'Order 20 Path 2 Child 2' )
  , ( '15_2_LoadBalancer_Child_1.dtsx', 1, 30, 'Y', 'Order 30 Path 1 Child 1' )
  , ( '15_3_LoadBalancer_Child_2.dtsx', 2, 40, 'Y', 'Order 40 Path 2 Child 2' )
  , ( '15_3_LoadBalancer_Child_2.dtsx', 2, 50, 'Y', 'Order 50 Path 2 Child 2' )
  ;


  PRINT 'Adding CDC'
  -- Turn on CDC (Once per Database)
  EXEC sys.sp_cdc_enable_db;
  
  -- Create the table to handle CDC States (Once per Database)
  CREATE TABLE [dbo].[cdc_states] 
   ([name] [nvarchar](256) NOT NULL, 
   [state] [nvarchar](256) NOT NULL) ON [PRIMARY];
  
  CREATE UNIQUE NONCLUSTERED INDEX [cdc_states_name] ON 
   [dbo].[cdc_states] 
   ( [name] ASC ) 
   WITH (PAD_INDEX  = OFF) ON [PRIMARY]
  
  -- Enable it for the 07_CDC table (do per table)
    EXEC sys.sp_cdc_enable_table
      @source_schema = 'Source', -- Schema of Source Table
      @source_name = '07_CDC', -- Schema of Source Table
      @role_name = NULL, -- Controls Access to Change Data
      @supports_net_changes = 1 -- Supports Querying for net changes
  


  PRINT 'Done' 

END



