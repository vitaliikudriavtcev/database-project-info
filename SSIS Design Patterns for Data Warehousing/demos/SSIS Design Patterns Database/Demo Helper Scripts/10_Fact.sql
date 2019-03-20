USE SSISDesignPatterns
GO

-- Reset source, if needed
DECLARE @MaxRows    BIGINT = 100000
EXEC DDL.CreateSourceTable 'Source', '10_Fact', @MaxRows

-- Set the date for all records to 30 days in past for this demo
UPDATE [Source].[10_Fact] 
   SET [LastUpdateDate] = DATEADD(d,-30,GETDATE());

-- If needed, reset target table
EXEC DDL.CreateTargetTable 'Target', '10_Fact'


-- Show data prior to first run, will be empty table.
SELECT [10_FactBK]
      ,[FakeDim1_BigNumber]
      ,[FakeDim2_FormattedComma]
      ,[FakeDim3_FormattedZero]
      ,[TargetCIUD]
      ,[LastUpdateDate]
  FROM [Target].[10_Fact]
 ORDER BY [10_FactBK]

 -- Run the package to do the initial load. 

 -- Show the table with rows in it.
SELECT [10_FactBK]
      ,[FakeDim1_BigNumber]
      ,[FakeDim2_FormattedComma]
      ,[FakeDim3_FormattedZero]
      ,[TargetCIUD]
      ,[LastUpdateDate]
  FROM [Target].[10_Fact]
 ORDER BY [10_FactBK]

-- Show source has been udpated
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[10_Fact]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- Update rows in the source
DECLARE @MaxInsertRowsT1  BIGINT = 150000
DECLARE @UpdateFromT1     BIGINT = 5000
DECLARE @UpdateThruT1     BIGINT = 9999
DECLARE @IncludeType2ChangeT1 BIT = 0
DECLARE @DeleteFrom       BIGINT = -1
DECLARE @DeleteThru       BIGINT = -1

EXECUTE [CUD].[10_Fact] @MaxInsertRowsT1, @UpdateFromT1, @UpdateThruT1, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT1


-- Rerun the package

-- Show data post update

-- Again, show number of rows by update type
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[10_Fact]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- New records 
SELECT [10_FactBK]
      ,[FakeDim1_BigNumber]
      ,[FakeDim2_FormattedComma]
      ,[FakeDim3_FormattedZero]
      ,[TargetCIUD]
      ,[LastUpdateDate]
  FROM [Target].[10_Fact]
 WHERE [10_FactBK] > (SELECT MAX([10_FactBK]) -50 FROM [Target].[10_Fact] WHERE TargetCIUD = 'Insert' )
 ORDER BY [10_FactBK]

-- Updated rows
SELECT [10_FactBK]
      ,[FakeDim1_BigNumber]
      ,[FakeDim2_FormattedComma]
      ,[FakeDim3_FormattedZero]
      ,[TargetCIUD]
      ,[LastUpdateDate]
  FROM [Target].[10_Fact]
 WHERE [10_FactBK] > (SELECT MIN([10_FactBK]) -3 FROM [Target].[10_Fact] WHERE TargetCIUD = 'Update' )
   AND [10_FactBK] < (SELECT MAX([10_FactBK]) +3 FROM [Target].[10_Fact] WHERE TargetCIUD = 'Update' )
 ORDER BY [10_FactBK]


