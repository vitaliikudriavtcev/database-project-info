USE SSISDesignPatterns
GO

-- Reset source, if needed
DECLARE @MaxRows    BIGINT = 100000
EXEC DDL.CreateSourceTable 'Source', '06_Hashbytes_SameDb', @MaxRows

-- If needed, reset target table
EXEC DDL.CreateTargetTable 'Target', '06_Hashbytes_SameDb'


-- Show data prior to first run, will be empty table.
SELECT [06_Hashbytes_SameDbSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[06_Hashbytes_SameDb]
 ORDER BY [BigNumber]

 -- Run the package to do the initial load. 

 -- Show the table with rows in it.
SELECT [06_Hashbytes_SameDbSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[06_Hashbytes_SameDb]
 ORDER BY [BigNumber]

-- Show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[06_Hashbytes_SameDb]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[06_Hashbytes_SameDb]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]



-- Update rows in the source
DECLARE @MaxInsertRowsT1  BIGINT = 150000
DECLARE @UpdateFromT1     BIGINT = 5000
DECLARE @UpdateThruT1     BIGINT = 9999
DECLARE @IncludeType2ChangeT1 BIT = 0
DECLARE @DeleteFrom       BIGINT = 20000
DECLARE @DeleteThru       BIGINT = 21999

EXECUTE [CUD].[06_Hashbytes_SameDb] @MaxInsertRowsT1, @UpdateFromT1, @UpdateThruT1, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT1


-- Rerun the package

-- Show data post update

-- Again, show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[06_Hashbytes_SameDb]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[06_Hashbytes_SameDb]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]
 

-- New records 
SELECT [06_Hashbytes_SameDbSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[06_Hashbytes_SameDb]
 WHERE [BigNumber] > (SELECT MAX(BigNumber) -50 FROM [Target].[06_Hashbytes_SameDb] WHERE TargetCIUD = 'Insert' )
 ORDER BY [BigNumber]

-- Updated rows 
SELECT [06_Hashbytes_SameDbSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[06_Hashbytes_SameDb]
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[06_Hashbytes_SameDb] WHERE TargetCIUD = 'Update' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[06_Hashbytes_SameDb] WHERE TargetCIUD = 'Update' )
 ORDER BY [BigNumber]

SELECT [06_Hashbytes_SameDbSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[06_Hashbytes_SameDb]
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[06_Hashbytes_SameDb] WHERE TargetCIUD = 'Delete' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[06_Hashbytes_SameDb] WHERE TargetCIUD = 'Delete' )
 ORDER BY [BigNumber]

