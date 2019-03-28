DECLARE	@CurrentVersion int = (	SELECT	TOP 1 CAST (s.[Value] as int)
								FROM	dbo.Settings s
								WHERE	s.[Name] = N'Version');
----Splitting the Name Column
IF (@CurrentVersion < 5)
BEGIN
  CREATE TABLE dbo.tmp_UserNames (ID bigint, [Name] nvarchar(200));

  INSERT	dbo.tmp_UserNames (ID, [Name])
  SELECT	u.UserID, u.[Name]
  FROM		dbo.[User] u;
END

--Extracting a User Status Table
IF (@CurrentVersion < 7)
BEGIN
  CREATE TABLE dbo.tmp_UserStatuses (ID bigint, [Name] nvarchar(50));

  INSERT	dbo.tmp_UserStatuses (ID, [Name])
  SELECT	u.UserID, u.[Status]
  FROM		dbo.[User] u;
END
