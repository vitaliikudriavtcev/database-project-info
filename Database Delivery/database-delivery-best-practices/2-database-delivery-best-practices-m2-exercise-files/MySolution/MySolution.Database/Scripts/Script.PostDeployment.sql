DECLARE @NewVersion int = 9;--increase it after every changing ???

DECLARE	@CurrentVersion int = (	SELECT	TOP 1 CAST (s.[Value] as int)
								FROM	dbo.Settings s
								WHERE	s.[Name] = N'Version');


-- Jump to the incremental migration scripts based on the current version.
IF @currentDBVersion = 5 GOTO Version05
ELSE IF @currentDBVersion = 7 GOTO Version07
ELSE
RETURN

-- Script to migrate to v0.5
Version5:
--:r .\Scripts\Migration\V11\SchemaChangeScript.sql
:r .\Scripts\Migration\V11\DataChangeScript.sql

EXEC [internal].[CreateDatabaseVersion] @id = 2, @major = 0, @minor = 5, 
 @build = 0128, 
 @revision = 212

--Splitting the Name Column
--IF (@CurrentVersion < 5)
--BEGIN
--  UPDATE u
--  SET	FirstName	= LEFT([Name], CHARINDEX(' ', [Name]) - 1),
--		LastName	= RIGHT([Name], LEN([Name]) - CHARINDEX(' ', [Name]))
--  FROM	dbo.[User] u
--		INNER JOIN dbo.tmp_UserNames n ON n.ID = u.UserID;
 
--  DROP TABLE dbo.tmp_UserNames;
--END

----Extracting a User Status Table
--IF (@CurrentVersion < 7)
--BEGIN
--  INSERT dbo.UserStatus (UserStatusID, Name) 
--  VALUES(1, N'Regular'),
--		(2, N'Preferred'),
--		(3, N'Gold');

--  UPDATE	u
--  SET		StatusID =	CASE	WHEN s.[Name] = N'Preferred' THEN 2 
--								WHEN s.[Name] = N'Gold'	THEN 3 
--								ELSE 1 
--						END
--  FROM		dbo.[User] u
--  INNER JOIN dbo.tmp_UserStatuses s ON s.ID = u.UserID;

--  DROP TABLE dbo.tmp_UserStatuses;
--END


:r ReferenceData.sql

IF (EXISTS (SELECT TOP 1 1 FROM dbo.Settings WHERE [Name] = N'Version'))
BEGIN
	UPDATE dbo.Settings
	SET [Value] = @NewVersion
	WHERE [Name] = N'Version';
END
ELSE
BEGIN
	INSERT dbo.Settings ([Name], [Value])
	VALUES (N'Version', @NewVersion);
END
