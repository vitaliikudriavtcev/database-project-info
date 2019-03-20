USE SSISDesignPatterns
GO

-- Reset source, if needed
DECLARE @MaxRows    BIGINT = 100000
EXEC DDL.CreateSourceTable 'Source', '05_Hashbytes_DiffDb', @MaxRows

-- If needed, reset target table
EXEC DDL.CreateTargetTable 'Target', '05_Hashbytes_DiffDb'


-- Show data prior to first run, will be empty table.
SELECT [05_Hashbytes_DiffDbSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,HASHBYTES('SHA1', [FormattedComma] + '|' + [FormattedZero] + '|') AS hb
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[05_Hashbytes_DiffDb]
 ORDER BY [BigNumber]

 -- Run the package to do the initial load. 

 -- Show the table with rows in it.
SELECT [05_Hashbytes_DiffDbSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,HASHBYTES('SHA1', [FormattedComma] + '|' + [FormattedZero] + '|') AS hb
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[05_Hashbytes_DiffDb]
 ORDER BY [BigNumber]

-- Show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[05_Hashbytes_DiffDb]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[05_Hashbytes_DiffDb]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- Update rows in the source
DECLARE @MaxInsertRowsT1  BIGINT = 150000
DECLARE @UpdateFromT1     BIGINT = 5000
DECLARE @UpdateThruT1     BIGINT = 9999
DECLARE @IncludeType2ChangeT1 BIT = 0
DECLARE @DeleteFrom       BIGINT = -1
DECLARE @DeleteThru       BIGINT = -1

EXECUTE [CUD].[05_Hashbytes_DiffDb] @MaxInsertRowsT1, @UpdateFromT1, @UpdateThruT1, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT1


-- Rerun the package

-- Show data post update

-- Again, show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[05_Hashbytes_DiffDb]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[05_Hashbytes_DiffDb]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]



-- New records 
SELECT [05_Hashbytes_DiffDbSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,HASHBYTES('SHA1', [FormattedComma] + '|' + [FormattedZero] + '|') AS hb
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[05_Hashbytes_DiffDb]
 WHERE [BigNumber] > (SELECT MAX(BigNumber) -50 FROM [Target].[05_Hashbytes_DiffDb] WHERE TargetCIUD = 'Insert' )
 ORDER BY [BigNumber]

-- Updated rows 
SELECT [05_Hashbytes_DiffDbSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,HASHBYTES('SHA1', [FormattedComma] + '|' + [FormattedZero] + '|') AS hb
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[05_Hashbytes_DiffDb]
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[05_Hashbytes_DiffDb] WHERE TargetCIUD = 'Update' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[05_Hashbytes_DiffDb] WHERE TargetCIUD = 'Update' )
 ORDER BY [BigNumber]


