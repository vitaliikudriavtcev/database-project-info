
CREATE PROCEDURE [DDL].[DropProcIfExists]
(   @ProcSchemaName NVARCHAR(255)
  , @ProcName NVARCHAR(255)
) AS
BEGIN

  DECLARE @sqlStatement NVARCHAR(2000)

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

END

