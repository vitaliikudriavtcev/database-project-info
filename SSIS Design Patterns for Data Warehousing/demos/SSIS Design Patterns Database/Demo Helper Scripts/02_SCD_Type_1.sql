USE SSISDesignPatterns
GO

-- Reset source, if needed
DECLARE @MaxRows    BIGINT = 10000
EXEC DDL.CreateSourceTable 'Source', '02_SCD_Type_1', @MaxRows

-- If needed, reset target table
EXEC DDL.CreateTargetTable 'Target', '02_SCD_Type_1'


-- Show data prior to first run, will be empty table.
SELECT [02_SCD_Type_1SK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[02_SCD_Type_1]
 ORDER BY [BigNumber]

 -- Run the package to do the initial load. 

 -- Show the table with rows in it.
SELECT [02_SCD_Type_1SK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[02_SCD_Type_1]
 ORDER BY [BigNumber]

-- Show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[02_SCD_Type_1]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[02_SCD_Type_1]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- Update rows in the source
DECLARE @MaxInsertRowsT1  BIGINT = 12000
DECLARE @UpdateFromT1     BIGINT = 500
DECLARE @UpdateThruT1     BIGINT = 999
DECLARE @IncludeType2ChangeT1 BIT = 0
DECLARE @DeleteFrom       BIGINT = -1
DECLARE @DeleteThru       BIGINT = -1

EXECUTE [CUD].[02_SCD_Type_1] @MaxInsertRowsT1, @UpdateFromT1, @UpdateThruT1, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT1

-- Rerun the package

-- Show data post update

-- Again, show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[02_SCD_Type_1]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[02_SCD_Type_1]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- New records 
SELECT [02_SCD_Type_1SK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[02_SCD_Type_1]
 WHERE [BigNumber] > (SELECT MAX(BigNumber) -50 FROM [Target].[02_SCD_Type_1] WHERE TargetCIUD = 'Created' )
 ORDER BY [BigNumber]

-- Updated rows 
SELECT [02_SCD_Type_1SK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[02_SCD_Type_1]
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[02_SCD_Type_1] WHERE TargetCIUD = 'Update' )
   AND [BigNumber] < (SELECT MAX(BigNumber) -3 FROM [Target].[02_SCD_Type_1] WHERE TargetCIUD = 'Update' )
 ORDER BY [BigNumber]


