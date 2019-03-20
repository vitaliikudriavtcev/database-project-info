﻿/*
Deployment script for SSISDesignPatterns

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SSISDesignPatterns"
:setvar DefaultFilePrefix "SSISDesignPatterns"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Creating [DML].[UpdateSourceTableType1]...';


GO




CREATE PROCEDURE [DML].[UpdateSourceTableType1]
(   @SchemaName NVARCHAR(255)
  ,	@TableName NVARCHAR(255)
  , @FromBigNumber BIGINT = 0
  , @ThruBigNumber BIGINT = 9223372036854775807
  , @IncludeType2Change BIT = 0
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

  /* Update the table ---------------------------------------------------------------------------*/
  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + ' UPDATE [' + @SchemaName + '].[' + @TableName + '] '
  SET @sqlStatement = @sqlStatement + '    SET CIUD = ''Update'' '

  IF @IncludeType2Change = 1
  BEGIN
    SET @sqlStatement = @sqlStatement + '      , FormattedComma = FORMAT(BigNumber + 1, ''#,##0'')  '
  END

  SET @sqlStatement = @sqlStatement + '      , LastUpdateDate = GETDATE() '
  SET @sqlStatement = @sqlStatement + '  WHERE BigNumber BETWEEN ' + CAST(@FromBigNumber AS NVARCHAR) 
  SET @sqlStatement = @sqlStatement + '    AND ' + CAST(@ThruBigNumber AS NVARCHAR)
  
  EXECUTE sp_executesql @sqlStatement

END
GO
PRINT N'Creating [DML].[UpdateSourceTableType2]...';


GO




CREATE PROCEDURE [DML].[UpdateSourceTableType2]
(   @SchemaName NVARCHAR(255)
  ,	@TableName NVARCHAR(255)
  , @FromBigNumber BIGINT = 0
  , @ThruBigNumber BIGINT = 9223372036854775807
  , @IncludeType2Change BIT = 0
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

  /* Update the table ---------------------------------------------------------------------------*/
  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + ' UPDATE [' + @SchemaName + '].[' + @TableName + '] '
  SET @sqlStatement = @sqlStatement + '    SET CIUD = ''Update'' '

  IF @IncludeType2Change = 1
  BEGIN
    SET @sqlStatement = @sqlStatement + '      , FormattedZero = FORMAT(BigNumber + 2, ''0000000000000'') '
  END

  SET @sqlStatement = @sqlStatement + '      , LastUpdateDate = GETDATE() '
  SET @sqlStatement = @sqlStatement + '  WHERE BigNumber BETWEEN ' + CAST(@FromBigNumber AS NVARCHAR) 
  SET @sqlStatement = @sqlStatement + '    AND ' + CAST(@ThruBigNumber AS NVARCHAR)
  
  EXECUTE sp_executesql @sqlStatement

END
GO
PRINT N'Update complete.';


GO
