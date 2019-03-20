

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



