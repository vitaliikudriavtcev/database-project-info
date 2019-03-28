CREATE TABLE [dbo].[UserStatus]
(
	[UserStatusID] BIGINT       NOT NULL, 
    [Name]         NVARCHAR(50) NOT NULL,
	CONSTRAINT [PK_UserStatus] PRIMARY KEY CLUSTERED ([UserStatusID] ASC)
)
