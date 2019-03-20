CREATE PROCEDURE [DML].[DeleteFromSourceTable]
(   @SchemaName NVARCHAR(255)
  ,	@TableName NVARCHAR(255)
  , @FromBigNumber BIGINT = 0
  , @ThruBigNumber BIGINT = 9223372036854775807
) AS
BEGIN

  DECLARE @sqlStatement NVARCHAR(2000)
  DECLARE @message NVARCHAR(2000)

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


  /* Validate FromBigNumber parameter -----------------------------------------------------------*/
  -- Get the min possible big number
  DECLARE @minBigNumber BIGINT
  DECLARE @minBigNumberReturn BIGINT

  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + ' SELECT @minBigNumberReturn = MIN(BigNumber) '
  SET @sqlStatement = @sqlStatement + '   FROM [' + @SchemaName + '].[' + @TableName + '];'

  EXECUTE sp_executesql @sqlStatement, N'@minBigNumberReturn BIGINT OUTPUT', @minBigNumberReturn=@minBigNumber OUTPUT

  IF @FromBigNumber < @minBigNumber SET @FromBigNumber = @minBigNumber

  /* Validate ThruBigNumber parameter -----------------------------------------------------------*/

  -- Get the max possible big number
  DECLARE @maxBigNumber BIGINT
  DECLARE @maxBigNumberReturn BIGINT

  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + ' SELECT @maxBigNumberReturn = MAX(BigNumber) '
  SET @sqlStatement = @sqlStatement + '   FROM [' + @SchemaName + '].[' + @TableName + '];'

  EXECUTE sp_executesql @sqlStatement, N'@maxBigNumberReturn BIGINT OUTPUT', @maxBigNumberReturn=@maxBigNumber OUTPUT

  IF @ThruBigNumber > @maxBigNumber SET @ThruBigNumber = @maxBigNumber

  -- Check to see thru is greater than min
  -- Ensure from is less than the max
  IF @ThruBigNumber < @minBigNumber 
  BEGIN
    SET @message = ''
    SET @message = @message + 'The Thru Big Number (' 
    SET @message = @message + CAST(@ThruBigNumber AS NVARCHAR) 
    SET @message = @message + ') is less than the minimum value in the table of ' 
    SET @message = @message + CAST(@minBigNumber AS NVARCHAR)
    PRINT @message
    RETURN
  END

  -- Ensure from is less than the max
  IF @FromBigNumber > @maxBigNumber 
  BEGIN
    SET @message = ''
    SET @message = @message + 'The From Big Number (' 
    SET @message = @message + CAST(@FromBigNumber AS NVARCHAR) 
    SET @message = @message + ') exceeds the maximum value in the table of ' 
    SET @message = @message + CAST(@maxBigNumber AS NVARCHAR)
    PRINT @message
    RETURN
  END
  

  -- Finally validate From < Thru
  IF @FromBigNumber > @ThruBigNumber
  BEGIN
    SET @message = ''
    SET @message = @message + 'The From Big Number (' 
    SET @message = @message + CAST(@FromBigNumber AS NVARCHAR) 
    SET @message = @message + ') cannot be greater than the Thru Big Number (' 
    SET @message = @message + CAST(@ThruBigNumber AS NVARCHAR) + ')'
    PRINT @message
    RETURN
  END

  /* Generate Delete Statement ------------------------------------------------------------------*/
  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + ' DELETE FROM [' + @SchemaName + '].[' + @TableName + '] '
  SET @sqlStatement = @sqlStatement + '  WHERE BigNumber BETWEEN ' + CAST(@FromBigNumber AS NVARCHAR) 
  SET @sqlStatement = @sqlStatement + '    AND ' + CAST(@ThruBigNumber AS NVARCHAR)
  
  EXECUTE sp_executesql @sqlStatement

END


