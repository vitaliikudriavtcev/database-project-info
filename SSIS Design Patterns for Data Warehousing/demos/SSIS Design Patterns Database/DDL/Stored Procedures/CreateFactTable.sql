CREATE PROCEDURE [DDL].[CreateFactTable]
(   @SchemaName NVARCHAR(255)
  ,	@TableName NVARCHAR(255)
  , @IncludeType2 BIT = 0
) AS
BEGIN


  DECLARE @sqlStatement NVARCHAR(2000)
  
  -- If the table already exists, drop it
  IF EXISTS (SELECT [TABLE_SCHEMA], [TABLE_NAME] 
               FROM [INFORMATION_SCHEMA].[TABLES]
              WHERE [TABLE_SCHEMA] = @SchemaName
                AND [TABLE_NAME] = @TableName
            )
  BEGIN
    SET @sqlStatement = ''
    SET @sqlStatement = 'DROP TABLE [' + @SchemaName + '].[' + @TableName + '];'
    EXECUTE sp_executesql @sqlStatement
  END

  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '] ('
	SET @sqlStatement = @sqlStatement + '[' + @TableName + 'BK] BIGINT NOT NULL, '
	SET @sqlStatement = @sqlStatement + '[FakeDim1_BigNumber] BIGINT NULL, '
	SET @sqlStatement = @sqlStatement + '[FakeDim2_FormattedComma] NVARCHAR(4000) NULL, '
	SET @sqlStatement = @sqlStatement + '[FakeDim3_FormattedZero] NVARCHAR(4000) NULL, '
	SET @sqlStatement = @sqlStatement + '[TargetCIUD] NVARCHAR(20) NOT NULL, '
  SET @sqlStatement = @sqlStatement + '[LastUpdateDate] DATETIME NOT NULL '
  SET @sqlStatement = @sqlStatement + ') ON [PRIMARY] '

  EXECUTE sp_executesql @sqlStatement

END


