CREATE PROCEDURE [DDL].[DropTableIfExists]
(   @SchemaName NVARCHAR(255)
  , @TableName NVARCHAR(255)
) AS
BEGIN

  DECLARE @sqlStatement NVARCHAR(2000)

  IF EXISTS (SELECT [TABLE_SCHEMA], [TABLE_NAME] 
               FROM [INFORMATION_SCHEMA].[TABLES]
              WHERE [TABLE_SCHEMA] = @schemaName
                AND [TABLE_NAME] = @TableName 
            )
  BEGIN
    SET @sqlStatement = ''
    SET @sqlStatement = 'DROP TABLE [' + @schemaName + '].[' + @TableName + '];'
    EXECUTE sp_executesql @sqlStatement
  END

END

