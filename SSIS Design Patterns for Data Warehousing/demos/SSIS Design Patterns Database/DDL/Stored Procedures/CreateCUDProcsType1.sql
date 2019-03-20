

CREATE PROCEDURE [DDL].[CreateCUDProcsType1]
(   @ProcSchemaName NVARCHAR(255)
  , @ProcName NVARCHAR(255)
  , @TableSchemaName NVARCHAR(255)
  ,	@TableName NVARCHAR(255)
  , @InsertStart BIGINT      -- Set the max value to load
  , @UpdateFrom BIGINT
  , @UpdateThru BIGINT
)
AS
BEGIN

  DECLARE @sqlStatement NVARCHAR(2000)
  DECLARE @crlf NCHAR(2)
  SET @crlf = char(13) + char(10)
  
  -- If the proc already exists, drop it
  IF EXISTS (SELECT [SPECIFIC_SCHEMA]
                  , [SPECIFIC_NAME]
               FROM [INFORMATION_SCHEMA].[ROUTINES]
              WHERE [ROUTINE_TYPE] = 'PROCEDURE'
                AND [SPECIFIC_SCHEMA] = @ProcSchemaName 
                AND [SPECIFIC_NAME] = @ProcName
            )
  BEGIN
    SET @sqlStatement = ''
    SET @sqlStatement = 'DROP PROCEDURE [' + @ProcSchemaName + '].[' + @ProcName + '];'
    EXECUTE sp_executesql @sqlStatement
  END
  
  -- Create the proc
  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'CREATE PROCEDURE [' + @ProcSchemaName + '].[' + @ProcName + '] ' + @crlf
  SET @sqlStatement = @sqlStatement + 'AS ' + @crlf
  SET @sqlStatement = @sqlStatement + 'BEGIN ' + @crlf
  SET @sqlStatement = @sqlStatement + ' ' + @crlf

  SET @sqlStatement = @sqlStatement + '  EXEC DML.InsertIntoSourceTable ''' + @TableSchemaName + ''', ''' + @TableName + ''', ' + CAST(@InsertStart AS NVARCHAR) + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + '  EXEC DML.UpdateSourceTableType1  ''' + @TableSchemaName + ''', ''' + @TableName + ''', ' + CAST(@UpdateFrom AS NVARCHAR) + ', ' + CAST(@UpdateThru AS NVARCHAR) + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + 'END ' + @crlf

  EXECUTE sp_executesql @sqlStatement

END


