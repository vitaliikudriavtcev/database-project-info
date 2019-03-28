  UPDATE u
  SET	FirstName	= LEFT([Name], CHARINDEX(' ', [Name]) - 1),
		LastName	= RIGHT([Name], LEN([Name]) - CHARINDEX(' ', [Name]))
  FROM	dbo.[User] u
		INNER JOIN dbo.tmp_UserNames n ON n.ID = u.UserID;
 
  DROP TABLE dbo.tmp_UserNames;