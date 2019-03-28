CREATE TABLE [dbo].[User] (
    [UserID]	BIGINT NOT NULL IDENTITY (1, 1) PRIMARY KEY,
    [Name]		NVARCHAR (200) NOT NULL,
    [Email]     NVARCHAR (256) NOT NULL,
    [Status]    NVARCHAR (50)  NOT NULL
)
GO

CREATE PROCEDURE [dbo].[sp_SelectUsers]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT u.UserID, u.Name
	FROM dbo.[User] u
END
GO
