CREATE TABLE [dbo].[User] (
    [UserID]       BIGINT         NOT NULL,
    [FirstName]    NVARCHAR (100) NOT NULL,
    [LastName]     NVARCHAR (100) NOT NULL,
    [Email]        NVARCHAR (256) NOT NULL,
    [StatusID]     BIGINT         NOT NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([UserID] ASC),
	CONSTRAINT FK_User_UserStatus FOREIGN KEY ([StatusID]) REFERENCES UserStatus(UserStatusID)
);

