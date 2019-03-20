
CREATE PROCEDURE [DDL].[CreateTargetTable]
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
	SET @sqlStatement = @sqlStatement + '[' + @TableName + 'SK] BIGINT IDENTITY NOT NULL, '
	SET @sqlStatement = @sqlStatement + '[BigNumber] BIGINT NULL, '
	SET @sqlStatement = @sqlStatement + '[FormattedComma] NVARCHAR(4000) NULL, '
	SET @sqlStatement = @sqlStatement + '[FormattedZero] NVARCHAR(4000) NULL, '
	SET @sqlStatement = @sqlStatement + '[SourceCIUD] NVARCHAR(20) NOT NULL, '
	SET @sqlStatement = @sqlStatement + '[TargetCIUD] NVARCHAR(20) NOT NULL, '
	SET @sqlStatement = @sqlStatement + '[IsRowDeleted] BIT NOT NULL DEFAULT 0, '
  
  IF @IncludeType2 = 0
  BEGIN
	  SET @sqlStatement = @sqlStatement + '[LastUpdateDate] DATETIME NOT NULL '
  END
  ELSE
  BEGIN
	  SET @sqlStatement = @sqlStatement + '[EffectiveDate] DATETIME NOT NULL, '
	  SET @sqlStatement = @sqlStatement + '[ExpirationDate] DATETIME NULL, '
	  SET @sqlStatement = @sqlStatement + '[IsCurrentRecord] NCHAR(1) DEFAULT ''Y'' NOT NULL '
  END
  SET @sqlStatement = @sqlStatement + ') ON [PRIMARY] '

  EXECUTE sp_executesql @sqlStatement

END


