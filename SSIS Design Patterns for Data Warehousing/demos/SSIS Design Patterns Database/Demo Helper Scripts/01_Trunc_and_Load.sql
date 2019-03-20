USE SSISDesignPatterns
GO

-- Reset source, if needed
DECLARE @MaxRows    BIGINT = 100000
EXEC DDL.CreateSourceTable 'Source', '01_Trunc_and_Load', @MaxRows

-- If needed, reset target table
EXEC DDL.CreateTargetTable 'Target', '01_Trunc_and_Load'


-- Show data prior to first run, will be empty table.
SELECT [01_Trunc_and_LoadSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[01_Trunc_and_Load]
 ORDER BY [BigNumber]

 -- Run the package to do the initial load. 

 -- Show the table with rows in it.
SELECT [01_Trunc_and_LoadSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[01_Trunc_and_Load]
 ORDER BY [BigNumber]

-- Show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[01_Trunc_and_Load]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[01_Trunc_and_Load]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- Update rows in the source
DECLARE @MaxInsertRowsT1  BIGINT = 150000
DECLARE @UpdateFromT1     BIGINT = 5000
DECLARE @UpdateThruT1     BIGINT = 9999
DECLARE @IncludeType2ChangeT1 BIT = 0
DECLARE @DeleteFrom       BIGINT = -1
DECLARE @DeleteThru       BIGINT = -1

EXECUTE [CUD].[01_Trunc_and_Load] @MaxInsertRowsT1, @UpdateFromT1, @UpdateThruT1, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT1

-- Rerun the package

-- Show data post update

-- Again, show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[01_Trunc_and_Load]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[01_Trunc_and_Load]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]

-- New Rows
SELECT [01_Trunc_and_LoadSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[LastUpdateDate]
      ,[IsRowDeleted]
  FROM [Target].[01_Trunc_and_Load]
 WHERE [BigNumber] > (SELECT MAX(BigNumber) -50 FROM [Target].[01_Trunc_and_Load]  WHERE TargetCIUD = 'Created' )
 ORDER BY [BigNumber]

-- Updated rows by TargetCIUD
SELECT [01_Trunc_and_LoadSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[LastUpdateDate]
      ,[IsRowDeleted]
  FROM [Target].[01_Trunc_and_Load]
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[01_Trunc_and_Load]  WHERE TargetCIUD = 'Update' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[01_Trunc_and_Load]  WHERE TargetCIUD = 'Update' )
 ORDER BY [BigNumber]

 -- Show by SourceCIUD
SELECT [01_Trunc_and_LoadSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[LastUpdateDate]
      ,[IsRowDeleted]
  FROM [Target].[01_Trunc_and_Load]
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[01_Trunc_and_Load]  WHERE SourceCIUD = 'Update' )
   AND [BigNumber] < (SELECT MAX(BigNumber) -3 FROM [Target].[01_Trunc_and_Load]  WHERE SourceCIUD = 'Update' )
 ORDER BY [BigNumber]

