



CREATE PROCEDURE [DDL].[DropAllObjects]
AS
BEGIN

  -- When you are done and want to remove unnecessary objects, run this
  -- At the end only the required items will remain. 
  -- Use the DDL.CreateAllObjects to recreate everything

  EXEC [DDL].[DropTableIfExists] 'Source', '01_Trunc_and_Load'
  EXEC [DDL].[DropTableIfExists] 'Source', '02_SCD_Type_1'
  EXEC [DDL].[DropTableIfExists] 'Source', '03_SCD_Type_2'
  EXEC [DDL].[DropTableIfExists] 'Source', '04_Set_Based'
  EXEC [DDL].[DropTableIfExists] 'Source', '05_Hashbytes'
  EXEC [DDL].[DropTableIfExists] 'Source', '06_CDC'
  EXEC [DDL].[DropTableIfExists] 'Source', '07_Merge'
  EXEC [DDL].[DropTableIfExists] 'Source', '08_Date_Based'  
  EXEC [DDL].[DropTableIfExists] 'Target', '01_Trunc_and_Load'
  EXEC [DDL].[DropTableIfExists] 'Target', '02_SCD_Type_1'
  EXEC [DDL].[DropTableIfExists] 'Target', '03_SCD_Type_2'
  EXEC [DDL].[DropTableIfExists] 'Target', '04_Set_Based'
  EXEC [DDL].[DropTableIfExists] 'Target', '05_Hashbytes' 
  EXEC [DDL].[DropTableIfExists] 'Target', '06_CDC'
  EXEC [DDL].[DropTableIfExists] 'Target', '07_Merge'
  EXEC [DDL].[DropTableIfExists] 'Target', '08_Date_Based'

  EXEC [DDL].[DropTableIfExists] 'ETL', '05_Hashbytes_Insert'
  EXEC [DDL].[DropTableIfExists] 'ETL', '05_Hashbytes_Update'
  EXEC [DDL].[DropTableIfExists] 'ETL', '05_Hashbytes_Delete'
  
  EXEC [DDL].[DropProcIfExists] 'CUD', '01_Trunc_and_Load'
  EXEC [DDL].[DropProcIfExists] 'CUD', '02_SCD_Type_1'
  EXEC [DDL].[DropProcIfExists] 'CUD', '03_SCD_Type_2_T1'
  EXEC [DDL].[DropProcIfExists] 'CUD', '03_SCD_Type_2_T2'
  EXEC [DDL].[DropProcIfExists] 'CUD', '04_Set_Based'
  EXEC [DDL].[DropProcIfExists] 'CUD', '05_Hashbytes'
  EXEC [DDL].[DropProcIfExists] 'CUD', '06_CDC'
  EXEC [DDL].[DropProcIfExists] 'CUD', '07_Merge'
  EXEC [DDL].[DropProcIfExists] 'CUD', '08_Date_Based'  
  
END




