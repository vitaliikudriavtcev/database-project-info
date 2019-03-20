USE SSISDesignPatterns
GO

-- Reset source, if needed
DECLARE @MaxRows    BIGINT = 100000
EXEC DDL.CreateSourceTable 'Source', '09_Date_Based', @MaxRows

-- Set the date for all records to 30 days in past for this demo
UPDATE [Source].[09_Date_Based] 
   SET [LastUpdateDate] = DATEADD(d,-30,GETDATE());

-- If needed, reset target table
EXEC DDL.CreateTargetTable 'Target', '09_Date_Based'


-- Show data prior to first run, will be empty table.
SELECT [09_Date_BasedSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[09_Date_Based]
 ORDER BY [BigNumber]

 -- Run the package to do the initial load. 

 -- Show the table with rows in it.
SELECT [09_Date_BasedSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[09_Date_Based]
 ORDER BY [BigNumber]

-- Show source has been udpated
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[09_Date_Based]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[09_Date_Based]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- Update rows in the source
DECLARE @MaxInsertRowsT1  BIGINT = 150000
DECLARE @UpdateFromT1     BIGINT = 5000
DECLARE @UpdateThruT1     BIGINT = 9999
DECLARE @IncludeType2ChangeT1 BIT = 0
DECLARE @DeleteFrom       BIGINT = -1
DECLARE @DeleteThru       BIGINT = -1

EXECUTE [CUD].[09_Date_Based] @MaxInsertRowsT1, @UpdateFromT1, @UpdateThruT1, @DeleteFrom, @DeleteThru, @IncludeType2ChangeT1


-- Rerun the package

-- Show data post update

-- Again, show number of rows by update type
SELECT 'Source' AS SourceTarget, [SourceCIUD] AS CIUD, FORMAT(COUNT([SourceCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[09_Date_Based]
 GROUP BY [SourceCIUD]
UNION
SELECT 'Target' AS SourceTarget, [TargetCIUD] AS CIUD, FORMAT(COUNT([TargetCIUD]), '#,##0') AS CIUDCount
  FROM [Target].[09_Date_Based]
 GROUP BY [TargetCIUD]
 ORDER BY [SourceTarget], [CIUD]


-- New records from 100,000 to 150,000
SELECT [09_Date_BasedSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[09_Date_Based]
 WHERE [BigNumber] > (SELECT MAX(BigNumber) -50 FROM [Target].[09_Date_Based] WHERE TargetCIUD = 'Insert' )
 ORDER BY [BigNumber]

-- Updated rows from 1,000 to 5,000
SELECT [09_Date_BasedSK]
      ,[BigNumber]
      ,[FormattedComma]
      ,[FormattedZero]
      ,[SourceCIUD]
      ,[TargetCIUD]
      ,[IsRowDeleted]
      ,[LastUpdateDate]
  FROM [Target].[09_Date_Based]
 WHERE [BigNumber] > (SELECT MIN(BigNumber) -3 FROM [Target].[09_Date_Based] WHERE TargetCIUD = 'Update' )
   AND [BigNumber] < (SELECT MAX(BigNumber) +3 FROM [Target].[09_Date_Based] WHERE TargetCIUD = 'Update' )
 ORDER BY [BigNumber]


