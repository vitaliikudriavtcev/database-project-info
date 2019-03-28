--fill user status table
IF EXISTS (SELECT TOP 1 1 FROM dbo.UserStatus WHERE UserStatusID = 1)
	UPDATE dbo.UserStatus SET Name = 'Bronze' WHERE UserStatusID = 1;
ELSE
	INSERT dbo.UserStatus (UserStatusID, Name) VALUES (1, 'Bronze');

IF EXISTS (SELECT TOP 1 1 FROM dbo.UserStatus WHERE UserStatusID = 2)
	UPDATE dbo.UserStatus SET Name = 'Silver' WHERE UserStatusID = 2;
ELSE
	INSERT dbo.UserStatus (UserStatusID, Name) VALUES (2, 'Silver');

IF EXISTS (SELECT TOP 1 1 FROM dbo.UserStatus WHERE UserStatusID = 3)
	UPDATE dbo.UserStatus SET Name = 'Gold' WHERE UserStatusID = 3
ELSE
	INSERT dbo.UserStatus (UserStatusID, Name) VALUES (3, 'Gold');
