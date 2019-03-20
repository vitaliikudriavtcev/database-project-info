USE SSISDesignPatterns
GO

-- Reset source, if needed
DECLARE @MaxRows    BIGINT = 100000
EXEC DDL.CreateSourceTable 'Source', '13_Task_Factory_SCD', @MaxRows
GO

-- If needed, reset target table
DECLARE @IncludeType2       BIT = 1
EXEC DDL.CreateTargetTable 'Target', '13_Task_Factory_SCD', @IncludeType2
GO

-- Show data prior to first run, will be empty table.
SELECT [13_Task_Factory_SCDSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[13_Task_Factory_SCD]
 ORDER BY [BigNumber]

 -- Run the package to do the initial load. 

 -- Show the table with rows in it.
SELECT [13_Task_Factory_SCDSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[13_Task_Factory_SCD]
 ORDER BY [BigNumber]

-- Show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[13_Task_Factory_SCD]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[13_Task_Factory_SCD]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- Update rows in the source
-- Note, FormattedComma field is used for T1, FormattedZero for T2
-- Declare variables we'll need for the CUD
DECLARE @MaxInsertRowsT1  BIGINT = 125000
DECLARE @UpdateFromT1     BIGINT = 5000
DECLARE @UpdateThruT1     BIGINT = 9999
DECLARE @IncludeType2ChangeT1 BIT = 0
DECLARE @DeleteFrom       BIGINT = -1
DECLARE @DeleteThru       BIGINT = -1

EXECUTE [CUD].[13_Task_Factory_SCD_T1] @MaxInsertRowsT1, @UpdateFromT1, @UpdateThruT1, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT1
GO

DECLARE @MaxInsertRowsT2  BIGINT = 150000
DECLARE @UpdateFromT2     BIGINT = 50000
DECLARE @UpdateThruT2     BIGINT = 59999
DECLARE @IncludeType2ChangeT2 BIT = 1
DECLARE @DeleteFrom       BIGINT = 80000
DECLARE @DeleteThru       BIGINT = 81999
EXECUTE [CUD].[13_Task_Factory_SCD_T2] @MaxInsertRowsT2, @UpdateFromT2, @UpdateThruT2, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT2
GO

-- Rerun the package

-- Show data post update

-- Again, show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[13_Task_Factory_SCD]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[13_Task_Factory_SCD]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- New records 
SELECT [13_Task_Factory_SCDSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[13_Task_Factory_SCD]
 WHERE [BigNumber] > (SELECT MAX(BigNumber) -50 FROM [Target].[13_Task_Factory_SCD]  WHERE TargetCIUD = 'Created' )
 ORDER BY [BigNumber]

-- Updated rows T1
SELECT [13_Task_Factory_SCDSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[13_Task_Factory_SCD] 
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[13_Task_Factory_SCD]  WHERE TargetCIUD = 'Update' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[13_Task_Factory_SCD]  WHERE TargetCIUD = 'Update' )
 ORDER BY [BigNumber]

-- Updated rows T2
SELECT [13_Task_Factory_SCDSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[13_Task_Factory_SCD]  
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[13_Task_Factory_SCD]  WHERE TargetCIUD = 'Expire' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[13_Task_Factory_SCD]  WHERE TargetCIUD = 'Expire' ) 
 ORDER BY [BigNumber]


 -- Deleted
SELECT [13_Task_Factory_SCDSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[IsCurrentRecord]
  FROM [Target].[13_Task_Factory_SCD]  
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[13_Task_Factory_SCD]  WHERE TargetCIUD = 'Deleted' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[13_Task_Factory_SCD]  WHERE TargetCIUD = 'Deleted' ) 
 ORDER BY [BigNumber]
