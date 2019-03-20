

CREATE PROCEDURE [DDL].[CreateCUDProcs]
(   @ProcSchemaName NVARCHAR(255)
  , @ProcName NVARCHAR(255)
  , @TableSchemaName NVARCHAR(255)
  ,	@TableName NVARCHAR(255)
  --, @InsertStart BIGINT      -- Set the max value to load
  --, @UpdateFrom BIGINT
  --, @UpdateThru BIGINT
  --, @DeleteFrom BIGINT
  --, @DeleteThru BIGINT
  --, @IncludeType2Change BIT = 0
)
AS
BEGIN

  DECLARE @sqlStatement NVARCHAR(2000)
  DECLARE @sn AS NVARCHAR(1000)
  DECLARE @crlf NCHAR(2)

  SET @sn = '''' + @TableSchemaName + ''' , ''' + @TableName + ''''
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
  SET @sqlStatement = @sqlStatement + '(' + @crlf
  SET @sqlStatement = @sqlStatement + '  @InsertStart BIGINT      -- Set the max value to load' + @crlf
  SET @sqlStatement = @sqlStatement + ', @UpdateFrom BIGINT' + @crlf
  SET @sqlStatement = @sqlStatement + ', @UpdateThru BIGINT' + @crlf
  SET @sqlStatement = @sqlStatement + ', @DeleteFrom BIGINT = -1' + @crlf
  SET @sqlStatement = @sqlStatement + ', @DeleteThru BIGINT = -1' + @crlf
  SET @sqlStatement = @sqlStatement + ', @IncludeType2Change BIT = 0' + @crlf
  SET @sqlStatement = @sqlStatement + ')' + @crlf
  SET @sqlStatement = @sqlStatement + 'AS ' + @crlf
  SET @sqlStatement = @sqlStatement + 'BEGIN ' + @crlf
  SET @sqlStatement = @sqlStatement + ' ' + @crlf

  SET @sqlStatement = @sqlStatement + '  IF @InsertStart > -1 ' + @crlf
  SET @sqlStatement = @sqlStatement + '    BEGIN ' + @crlf
  SET @sqlStatement = @sqlStatement + '      EXEC DML.InsertIntoSourceTable ' + @sn + ', @InsertStart ' + @crlf
  SET @sqlStatement = @sqlStatement + '    END ' + @crlf
  SET @sqlStatement = @sqlStatement + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + '  IF @UpdateFrom > -1 ' + @crlf
  SET @sqlStatement = @sqlStatement + '    BEGIN ' + @crlf
  SET @sqlStatement = @sqlStatement + '      EXEC DML.UpdateSourceTable  ' + @sn + ', @UpdateFrom, @UpdateThru, @IncludeType2Change ' + @crlf
  SET @sqlStatement = @sqlStatement + '    END ' + @crlf
  SET @sqlStatement = @sqlStatement + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + '  IF @DeleteFrom > -1 ' + @crlf
  SET @sqlStatement = @sqlStatement + '    BEGIN ' + @crlf
  SET @sqlStatement = @sqlStatement + '      EXEC DML.DeleteFromSourceTable ' + @sn + ', @DeleteFrom, @DeleteThru ' + @crlf
  SET @sqlStatement = @sqlStatement + '    END ' + @crlf
  SET @sqlStatement = @sqlStatement + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + 'END ' + @crlf

  EXECUTE sp_executesql @sqlStatement

END


