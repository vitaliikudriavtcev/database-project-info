


CREATE PROCEDURE [DML].[InsertIntoSourceTable]
(   @SchemaName NVARCHAR(255)
  ,	@TableName NVARCHAR(255)
  , @MaxBigNumber BIGINT      -- Set the max value to load
) AS
BEGIN

  DECLARE @sqlStatement NVARCHAR(2000)

  -- If the table doesn't exist raise an error
  IF NOT EXISTS (SELECT [TABLE_SCHEMA], [TABLE_NAME] 
               FROM [INFORMATION_SCHEMA].[TABLES]
              WHERE [TABLE_SCHEMA] = @SchemaName
                AND [TABLE_NAME] = @TableName
            )
  BEGIN 
    SET @sqlStatement = ''
    SET @sqlStatement = 'ERROR! TABLE [' + @SchemaName + '].[' + @TableName + '] does not exist.';
    PRINT @sqlStatement
    RETURN
  END

  DECLARE @startBigNumber BIGINT
  DECLARE @startBigNumberReturn BIGINT


  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + ' SELECT @startBigNumberReturn = MAX(BigNumber) '
  SET @sqlStatement = @sqlStatement + '   FROM [' + @SchemaName + '].[' + @TableName + '];'

  EXECUTE sp_executesql @sqlStatement, N'@startBigNumberReturn BIGINT OUTPUT', @startBigNumberReturn=@startBigNumber OUTPUT
    
  -- Create the table
  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'WITH E00(N) AS (SELECT 1 UNION ALL SELECT 1), '
  SET @sqlStatement = @sqlStatement + '     E02(N) AS (SELECT 1 FROM E00 a, E00 b), '
  SET @sqlStatement = @sqlStatement + '     E04(N) AS (SELECT 1 FROM E02 a, E02 b), '
  SET @sqlStatement = @sqlStatement + '     E08(N) AS (SELECT 1 FROM E04 a, E04 b), '
  SET @sqlStatement = @sqlStatement + '     E16(N) AS (SELECT 1 FROM E08 a, E08 b), '
  SET @sqlStatement = @sqlStatement + '     E32(N) AS (SELECT 1 FROM E16 a, E16 b), '
  SET @sqlStatement = @sqlStatement + 'cteTally(N) AS (SELECT ROW_NUMBER() OVER (ORDER BY N) FROM E32) '
  SET @sqlStatement = @sqlStatement + ' INSERT INTO [' + @SchemaName + '].[' + @TableName + '] '
  SET @sqlStatement = @sqlStatement + ' SELECT N AS BigNumber '
  SET @sqlStatement = @sqlStatement + '      , FORMAT(N, ''#,##0'') AS FormattedComma '
  SET @sqlStatement = @sqlStatement + '      , FORMAT(N, ''0000000000000'') AS FormattedZero '
  SET @sqlStatement = @sqlStatement + '      , ''Insert'' AS SourceCIUD '
  SET @sqlStatement = @sqlStatement + '      , GETDATE() AS LastUpdateDate '
  SET @sqlStatement = @sqlStatement + '   FROM cteTally '
  SET @sqlStatement = @sqlStatement + '  WHERE N > ' + CAST(@startBigNumber AS NVARCHAR) 
  SET @sqlStatement = @sqlStatement + '    AND N <= ' + CAST(@MaxBigNumber AS NVARCHAR) + '; '
  
  EXECUTE sp_executesql @sqlStatement

END

