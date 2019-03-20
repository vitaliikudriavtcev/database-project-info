
CREATE PROCEDURE [DDL].[CreateETLTable]
(   @TableName          NVARCHAR(255)
  , @IncludeType2Change BIT = 0
  , @IncludeDelete      BIT = 0
) AS
BEGIN

  DECLARE @schemaName   NVARCHAR(50) = 'ETL'
  DECLARE @sqlStatement NVARCHAR(2000)
  DECLARE @etlTableName NVARCHAR(255)
  DECLARE @columnDefs   NVARCHAR(2000)

  -- Delete the tables if they exist
  SET @etlTableName = @TableName + '_Insert'    
  EXEC [DDL].[DropTableIfExists] @SchemaName, @etlTableName 

  SET @etlTableName = @TableName + '_Update'    
  EXEC [DDL].[DropTableIfExists] @SchemaName, @etlTableName 

  SET @etlTableName = @TableName + '_Delete'    
  EXEC [DDL].[DropTableIfExists] @SchemaName, @etlTableName 

  -- Set the column definitions for inserts / updates
  SET @columnDefs = ''
	SET @columnDefs = @columnDefs + '[BigNumber] BIGINT NULL, '
	SET @columnDefs = @columnDefs + '[FormattedComma] NVARCHAR(4000) NULL, '
	SET @columnDefs = @columnDefs + '[FormattedZero] NVARCHAR(4000) NULL, '
	SET @columnDefs = @columnDefs + '[SourceCIUD] NVARCHAR(20) NULL, '
	SET @columnDefs = @columnDefs + '[TargetCIUD] NVARCHAR(20) NULL, '
	SET @columnDefs = @columnDefs + '[IsRowDeleted] BIT NOT NULL DEFAULT 0, '

  IF @IncludeType2Change = 0
    BEGIN
	    SET @columnDefs = @columnDefs + '[LastUpdateDate] DATETIME NULL '
    END
  ELSE
    BEGIN
	    SET @columnDefs = @columnDefs + '[EffectiveDate] DATETIME NULL, '
	    SET @columnDefs = @columnDefs + '[ExpirationDate] DATETIME NULL, '
	    SET @columnDefs = @columnDefs + '[IsCurrentRecord] NCHAR(1) DEFAULT ''Y'' NOT NULL '
    END

  SET @columnDefs = @columnDefs + ') ON [PRIMARY] '

  -- Create the insert and update ETL tables
  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '_Insert] ('
  SET @sqlStatement = @sqlStatement + @columnDefs
  EXECUTE sp_executesql @sqlStatement

  IF @IncludeType2Change = 1
    BEGIN
      SET @sqlStatement = ''
      SET @sqlStatement = @sqlStatement + 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '_Insert_NewType2] ('
      SET @sqlStatement = @sqlStatement + @columnDefs
      EXECUTE sp_executesql @sqlStatement
    END

  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '_Update] ('
  SET @sqlStatement = @sqlStatement + @columnDefs
  EXECUTE sp_executesql @sqlStatement
  
  IF @IncludeType2Change = 1
    BEGIN
      SET @sqlStatement = ''
      SET @sqlStatement = @sqlStatement + 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '_Update_ExpiringType2] ('
      SET @sqlStatement = @sqlStatement + @columnDefs
      EXECUTE sp_executesql @sqlStatement
    END


  IF @IncludeDelete = 1
    BEGIN
      -- For deletes we only need the PK and metadata. 
      SET @columnDefs = ''
	    SET @columnDefs = @columnDefs + '[BigNumber] BIGINT NULL, '
	    SET @columnDefs = @columnDefs + '[IsRowDeleted] BIT NOT NULL DEFAULT 0, '
	    SET @columnDefs = @columnDefs + '[LastUpdateDate] DATETIME NULL '
      SET @columnDefs = @columnDefs + ') ON [PRIMARY] '

      -- Create the delete table
      SET @sqlStatement = ''
      SET @sqlStatement = @sqlStatement + 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '_Delete] ('
      SET @sqlStatement = @sqlStatement + @columnDefs
      EXECUTE sp_executesql @sqlStatement
    END
END

