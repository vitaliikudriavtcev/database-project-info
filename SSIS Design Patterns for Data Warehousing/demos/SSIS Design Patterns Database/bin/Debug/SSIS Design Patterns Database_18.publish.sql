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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating [Admin]...';


GO
CREATE SCHEMA [Admin]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [CUD]...';


GO
CREATE SCHEMA [CUD]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [DDL]...';


GO
CREATE SCHEMA [DDL]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [DML]...';


GO
CREATE SCHEMA [DML]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [ETL]...';


GO
CREATE SCHEMA [ETL]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [Source]...';


GO
CREATE SCHEMA [Source]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [Staging]...';


GO
CREATE SCHEMA [Staging]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [Target]...';


GO
CREATE SCHEMA [Target]
    AUTHORIZATION [dbo];


GO
PRINT N'Creating [Admin].[READ_ME]...';


GO


CREATE PROCEDURE [Admin].[READ_ME]
AS
BEGIN

  DECLARE @message NVARCHAR(4000)
  DECLARE @crlf NVARCHAR(4) = char(10) + char(13)

  SET @message = '' 
  SET @message = @message + @crlf + 'This is just a proc with instructions to tell you how to get started. '
  SET @message = @message + @crlf + '------------------------------------------------------------------------------------------------- '
  SET @message = @message + @crlf + '  1. Execute the stored proc DDL.CreateAllObjects. This will create all of the tables in the '
  SET @message = @message + @crlf + '     Source and Target schemas, then populate them with base data. After that it will create the'
  SET @message = @message + @crlf + '     stored procs in the CUD schema to update/insert to the individual tables'
  SET @message = @message + @crlf + ' '
  SET @message = @message + @crlf + '  2. Run the basic package to demonstrate what an initial load would be. Show the data in '
  SET @message = @message + @crlf + '     the target table. All rows should have Create in the CUID (Create Update Insert Delete) '
  SET @message = @message + @crlf + '     column.'
  SET @message = @message + @crlf + ' '
  SET @message = @message + @crlf + '  3. After running the basic package, run the CUD... stored proc which corresponds with the table.'
  SET @message = @message + @crlf + '     This will add new rows to the table and update existing ones so you can do a demo of the '
  SET @message = @message + @crlf + '     Insert/Update functionality'
  SET @message = @message + @crlf + ' '
  SET @message = @message + @crlf + '  4. Run the package a second time to show the new/updated rows in the Target table. '
  SET @message = @message + @crlf + ' '
  SET @message = @message + @crlf + '------------------------------------------------------------------------------------------------- '
  SET @message = @message + @crlf + ' '
  SET @message = @message + @crlf + '  Author Robert C. Cain, MVP, MCTS'
  SET @message = @message + @crlf + '  http://arcanecode.com | @ArcaneCode'
  SET @message = @message + @crlf + ' '
  SET @message = @message + @crlf + '------------------------------------------------------------------------------------------------- '

  PRINT @message
  SELECT @message

END
GO
PRINT N'Creating [DDL].[DropProcIfExists]...';


GO

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
GO
PRINT N'Creating [DDL].[DropTableIfExists]...';


GO
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
GO
PRINT N'Creating [DDL].[CreateETLTable]...';


GO

CREATE PROCEDURE [DDL].[CreateETLTable]
(   @TableName NVARCHAR(255)
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
	SET @columnDefs = @columnDefs + '[CIUD] NVARCHAR(20) NOT NULL, '
	SET @columnDefs = @columnDefs + '[IsRowDeleted] BIT NOT NULL DEFAULT 0, '
	SET @columnDefs = @columnDefs + '[LastUpdateDate] DATETIME NOT NULL '
  SET @columnDefs = @columnDefs + ') ON [PRIMARY] '

  -- Create the insert and update ETL tables
  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '_Insert] ('
  SET @sqlStatement = @sqlStatement + @columnDefs
  EXECUTE sp_executesql @sqlStatement

  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '_Update] ('
  SET @sqlStatement = @sqlStatement + @columnDefs
  EXECUTE sp_executesql @sqlStatement
  
  -- For deletes we only need the PK and metadata. 
  SET @columnDefs = ''
	SET @columnDefs = @columnDefs + '[BigNumber] BIGINT NULL, '
	SET @columnDefs = @columnDefs + '[IsRowDeleted] BIT NOT NULL DEFAULT 0, '
	SET @columnDefs = @columnDefs + '[LastUpdateDate] DATETIME NOT NULL '
  SET @columnDefs = @columnDefs + ') ON [PRIMARY] '

  -- Create the delete table
  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'CREATE TABLE [' + @SchemaName + '].[' + @TableName + '_Delete] ('
  SET @sqlStatement = @sqlStatement + @columnDefs
  EXECUTE sp_executesql @sqlStatement

END
GO
PRINT N'Creating [DDL].[CreateCUDProcsType1]...';


GO


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
GO
PRINT N'Creating [DDL].[CreateCUDProcsType2]...';


GO


CREATE PROCEDURE [DDL].[CreateCUDProcsType2]
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
  SET @sqlStatement = @sqlStatement + '  EXEC DML.UpdateSourceTableType2  ''' + @TableSchemaName + ''', ''' + @TableName + ''', ' + CAST(@UpdateFrom AS NVARCHAR) + ', ' + CAST(@UpdateThru AS NVARCHAR) + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + 'END ' + @crlf

  EXECUTE sp_executesql @sqlStatement

END
GO
PRINT N'Creating [DDL].[CreateCUDProcs]...';


GO


CREATE PROCEDURE [DDL].[CreateCUDProcs]
(   @ProcSchemaName NVARCHAR(255)
  , @ProcName NVARCHAR(255)
  , @TableSchemaName NVARCHAR(255)
  ,	@TableName NVARCHAR(255)
  , @InsertStart BIGINT      -- Set the max value to load
  , @UpdateFrom BIGINT
  , @UpdateThru BIGINT
  , @IncludeType2Change BIT = 0
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
  SET @sqlStatement = @sqlStatement + '  EXEC DML.UpdateSourceTable  ''' + @TableSchemaName + ''', ''' + @TableName + ''', ' + CAST(@UpdateFrom AS NVARCHAR) + ', ' + CAST(@UpdateThru AS NVARCHAR) + ', ' + CAST(@IncludeType2Change AS NVARCHAR) + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + ' ' + @crlf
  SET @sqlStatement = @sqlStatement + 'END ' + @crlf

  EXECUTE sp_executesql @sqlStatement

END
GO
PRINT N'Creating [DDL].[DropAllObjects]...';


GO




CREATE PROCEDURE [DDL].[DropAllObjects]
AS
BEGIN

  -- When you are done and want to remove unnecessary objects, run this
  -- At the end only the required items will remain. 
  -- Use the DDL.CreateAllObjects to recreate everything

  EXEC [DDL].[DropTableIfExists] 'Source', '01_Trunc_and_Load'
  EXEC [DDL].[DropTableIfExists] 'Source', '02_SCD_Type_1'
  EXEC [DDL].[DropTableIfExists] 'Source', '03_SCD_Type_2'
  EXEC [DDL].[DropTableIfExists] 'Source', '04_Set_Based'
  EXEC [DDL].[DropTableIfExists] 'Source', '05_Hashbytes'
  EXEC [DDL].[DropTableIfExists] 'Source', '06_CDC'
  EXEC [DDL].[DropTableIfExists] 'Source', '07_Merge'
  EXEC [DDL].[DropTableIfExists] 'Source', '08_Date_Based'  
  EXEC [DDL].[DropTableIfExists] 'Target', '01_Trunc_and_Load'
  EXEC [DDL].[DropTableIfExists] 'Target', '02_SCD_Type_1'
  EXEC [DDL].[DropTableIfExists] 'Target', '03_SCD_Type_2'
  EXEC [DDL].[DropTableIfExists] 'Target', '04_Set_Based'
  EXEC [DDL].[DropTableIfExists] 'Target', '05_Hashbytes' 
  EXEC [DDL].[DropTableIfExists] 'Target', '06_CDC'
  EXEC [DDL].[DropTableIfExists] 'Target', '07_Merge'
  EXEC [DDL].[DropTableIfExists] 'Target', '08_Date_Based'

  EXEC [DDL].[DropTableIfExists] 'ETL', '05_Hashbytes_Insert'
  EXEC [DDL].[DropTableIfExists] 'ETL', '05_Hashbytes_Update'
  EXEC [DDL].[DropTableIfExists] 'ETL', '05_Hashbytes_Delete'
  
  EXEC [DDL].[DropProcIfExists] 'CUD', '01_Trunc_and_Load'
  EXEC [DDL].[DropProcIfExists] 'CUD', '02_SCD_Type_1'
  EXEC [DDL].[DropProcIfExists] 'CUD', '03_SCD_Type_2_T1'
  EXEC [DDL].[DropProcIfExists] 'CUD', '03_SCD_Type_2_T2'
  EXEC [DDL].[DropProcIfExists] 'CUD', '04_Set_Based'
  EXEC [DDL].[DropProcIfExists] 'CUD', '05_Hashbytes'
  EXEC [DDL].[DropProcIfExists] 'CUD', '06_CDC'
  EXEC [DDL].[DropProcIfExists] 'CUD', '07_Merge'
  EXEC [DDL].[DropProcIfExists] 'CUD', '08_Date_Based'  
  
END
GO
PRINT N'Creating [DDL].[CreateTargetTable]...';


GO




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
	SET @sqlStatement = @sqlStatement + '[CIUD] NVARCHAR(20) NOT NULL, '
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
GO
PRINT N'Creating [DDL].[CreateSourceTable]...';


GO



CREATE PROCEDURE [DDL].[CreateSourceTable]
(   @SchemaName NVARCHAR(255)
  ,	@TableName NVARCHAR(255)
  , @MaxBigNumber BIGINT      -- Set the max value to load
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
  
  -- Create the table
  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'WITH E00(N) AS (SELECT 1 UNION ALL SELECT 1), '
  SET @sqlStatement = @sqlStatement + '     E02(N) AS (SELECT 1 FROM E00 a, E00 b), '
  SET @sqlStatement = @sqlStatement + '     E04(N) AS (SELECT 1 FROM E02 a, E02 b), '
  SET @sqlStatement = @sqlStatement + '     E08(N) AS (SELECT 1 FROM E04 a, E04 b), '
  SET @sqlStatement = @sqlStatement + '     E16(N) AS (SELECT 1 FROM E08 a, E08 b), '
  SET @sqlStatement = @sqlStatement + '     E32(N) AS (SELECT 1 FROM E16 a, E16 b), '
  SET @sqlStatement = @sqlStatement + 'cteTally(N) AS (SELECT ROW_NUMBER() OVER (ORDER BY N) FROM E32) '
  SET @sqlStatement = @sqlStatement + ' SELECT N AS BigNumber '
  SET @sqlStatement = @sqlStatement + '      , FORMAT(N, ''#,##0'') AS FormattedComma '
  SET @sqlStatement = @sqlStatement + '      , FORMAT(N, ''0000000000000'') AS FormattedZero '
  SET @sqlStatement = @sqlStatement + '      , CAST(''Created'' AS NVARCHAR(20)) AS CIUD '
  SET @sqlStatement = @sqlStatement + '      , GETDATE() AS LastUpdateDate '
  SET @sqlStatement = @sqlStatement + '   INTO [' + @SchemaName + '].[' + @TableName + '] '
  SET @sqlStatement = @sqlStatement + '   FROM cteTally '
  SET @sqlStatement = @sqlStatement + '  WHERE N <= ' + CAST(@MaxBigNumber AS NVARCHAR) + '; '
  
  EXECUTE sp_executesql @sqlStatement

  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'ALTER TABLE [' + @SchemaName + '].[' + @TableName + '] '
  SET @sqlStatement = @sqlStatement + 'ALTER COLUMN BigNumber BIGINT NOT NULL '
  EXECUTE sp_executesql @sqlStatement

  SET @sqlStatement = ''
  SET @sqlStatement = @sqlStatement + 'ALTER TABLE [' + @SchemaName + '].[' + @TableName + '] '
  SET @sqlStatement = @sqlStatement + 'ADD CONSTRAINT [PK_' + @TableName + '] PRIMARY KEY CLUSTERED ([BigNumber] ASC) '
  EXECUTE sp_executesql @sqlStatement
END
GO
PRINT N'Creating [DDL].[CreateAllObjects]...';


GO

CREATE PROCEDURE [DDL].[CreateAllObjects]
AS
BEGIN

  DECLARE @MaxRows            BIGINT = 100000
  DECLARE @MaxRowsSmall       BIGINT = 10000
  DECLARE @InsertRows         BIGINT = 150000
  DECLARE @UpdateFrom         BIGINT = 1000
  DECLARE @UpdateThru         BIGINT = 5000
  DECLARE @InsertRowsSmall    BIGINT = 15000
  DECLARE @UpdateFromT1       BIGINT = 100
  DECLARE @UpdateThruT1       BIGINT = 500
  DECLARE @UpdateFromT2       BIGINT = 1000
  DECLARE @UpdateThruT2       BIGINT = 1500
  DECLARE @IncludeType2       BIT = 1

  PRINT 'Creating 01_Trunc_and_Load with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '01_Trunc_and_Load', @MaxRows

  PRINT 'Creating 02_SCD_Type_1 with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '02_SCD_Type_1', @MaxRowsSmall

  PRINT 'Creating 03_SCD_Type_2 with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '03_SCD_Type_2', @MaxRowsSmall

  PRINT 'Creating 04_Set_Based with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '04_Set_Based', @MaxRows

  PRINT 'Creating 05_Hashbytes_DiffDb with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '05_Hashbytes_DiffDb', @MaxRows

  PRINT 'Creating 06_Hashbytes_SameDb with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '06_Hashbytes_SameDb', @MaxRows

  PRINT 'Creating 07_CDC with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '07_CDC', @MaxRows

  PRINT 'Creating 08_Merge with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '08_Merge', @MaxRows

  PRINT 'Creating 09_Date_Based with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '09_Date_Based', @MaxRows
  
  PRINT 'Creating 10_Fact with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '10_Fact', @MaxRows

  PRINT 'Creating 10_Fact_Lookup with ' + FORMAT(@MaxRows, '#,##0') + ' rows'
  EXEC DDL.CreateSourceTable 'Source', '10_Fact_Lookup', @MaxRows

  PRINT 'Creating Target Tables'
  EXEC DDL.CreateTargetTable 'Target', '01_Trunc_and_Load'
  EXEC DDL.CreateTargetTable 'Target', '02_SCD_Type_1'
  EXEC DDL.CreateTargetTable 'Target', '03_SCD_Type_2', @IncludeType2
  EXEC DDL.CreateTargetTable 'Target', '04_Set_Based_Type_1'
  EXEC DDL.CreateTargetTable 'Target', '05_Set_Based_Type_2', @IncludeType2
  EXEC DDL.CreateTargetTable 'Target', '05_Hashbytes_DiffDb' 
  EXEC DDL.CreateTargetTable 'Target', '06_Hashbytes_SameDb' 
  EXEC DDL.CreateTargetTable 'Target', '07_CDC'
  EXEC DDL.CreateTargetTable 'Target', '08_Merge'
  EXEC DDL.CreateTargetTable 'Target', '09_Date_Based'
  EXEC DDL.CreateTargetTable 'Target', '10_Fact'

  PRINT 'Creating ETL Tables'
  EXEC [DDL].[CreateETLTable] '04_Set_Based_Type_1'
  EXEC [DDL].[CreateETLTable] '04_Set_Based_Type_2'
  EXEC [DDL].[CreateETLTable] '05_Hashbytes_DiffDb'
  EXEC [DDL].[CreateETLTable] '06_Hashbytes_SameDb'
  EXEC [DDL].[CreateETLTable] '09_Date_Based'
  
  
  PRINT 'Creating Stored Procedures'
  EXEC [DDL].[CreateCUDProcs] 'CUD', '01_Trunc_and_Load',        'Source', '01_Trunc_and_Load', @InsertRows, @UpdateFrom, @UpdateThru
  EXEC [DDL].[CreateCUDProcs] 'CUD', '02_SCD_Type_1',            'Source', '02_SCD_Type_1', @InsertRowsSmall, @UpdateFromT1, @UpdateThruT1
  EXEC [DDL].[CreateCUDProcs] 'CUD', '03_SCD_Type_2_T1',         'Source', '03_SCD_Type_2', @InsertRowsSmall, @UpdateFromT1, @UpdateThruT1
  EXEC [DDL].[CreateCUDProcs] 'CUD', '03_SCD_Type_2_T2',         'Source', '03_SCD_Type_2', @InsertRowsSmall, @UpdateFromT2, @UpdateThruT2, @IncludeType2
  EXEC [DDL].[CreateCUDProcs] 'CUD', '04_Set_Based_Type_1' ,     'Source', '04_Set_Based' , @InsertRows, @UpdateFrom, @UpdateThru
  EXEC [DDL].[CreateCUDProcs] 'CUD', '05_Hashbytes_DiffDb' ,     'Source', '05_Hashbytes_DiffDb' , @InsertRows, @UpdateFrom, @UpdateThru
  EXEC [DDL].[CreateCUDProcs] 'CUD', '06_Hashbytes_SameDb' ,     'Source', '06_Hashbytes_SameDb' , @InsertRows, @UpdateFrom, @UpdateThru
  EXEC [DDL].[CreateCUDProcs] 'CUD', '07_CDC'       ,            'Source', '07_CDC'       , @InsertRows, @UpdateFrom, @UpdateThru
  EXEC [DDL].[CreateCUDProcs] 'CUD', '08_Merge'     ,            'Source', '08_Merge'     , @InsertRows, @UpdateFrom, @UpdateThru
  EXEC [DDL].[CreateCUDProcs] 'CUD', '09_Date_Based',            'Source', '09_Date_Based', @InsertRows, @UpdateFrom, @UpdateThru

/*
  EXEC sys.sp_cdc_enable_db;

  EXEC sys.sp_cdc_enable_table
    @source_schema = 'Source', -- Schema of Source Table
    @source_name = '07_CDC', -- Schema of Source Table
    @role_name = NULL, -- Controls Access to Change Data
    @supports_net_changes = 1 -- Supports Querying for net changes
*/
  
  PRINT 'Done' 

END
GO
PRINT N'Creating [DML].[InsertIntoSourceTable]...';


GO



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
  SET @sqlStatement = @sqlStatement + '      , ''Insert'' AS CIUD '
  SET @sqlStatement = @sqlStatement + '      , GETDATE() AS LastUpdateDate '
  SET @sqlStatement = @sqlStatement + '   FROM cteTally '
  SET @sqlStatement = @sqlStatement + '  WHERE N > ' + CAST(@startBigNumber AS NVARCHAR) 
  SET @sqlStatement = @sqlStatement + '    AND N <= ' + CAST(@MaxBigNumber AS NVARCHAR) + '; '
  
  EXECUTE sp_executesql @sqlStatement

END
GO
PRINT N'Creating [DML].[UpdateSourceTable]...';


GO




CREATE PROCEDURE [DML].[UpdateSourceTable]
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
  SET @sqlStatement = @sqlStatement + '      , FormattedComma = FORMAT(BigNumber + 1, ''#,##0'')  '

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
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
