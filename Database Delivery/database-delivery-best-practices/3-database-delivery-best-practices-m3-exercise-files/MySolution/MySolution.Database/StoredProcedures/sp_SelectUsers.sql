IF OBJECT_ID('sp_SelectUsers', 'P') IS NOT NULL
DROP PROC [dbo].[sp_SelectUsers]
GO

CREATE PROCEDURE [dbo].[sp_SelectUsers]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT u.UserID, u.FirstName, u.LastName, u.Email, s.Name [Status]
	FROM dbo.[User] u
    INNER JOIN dbo.UserStatus s ON u.StatusID = s.UserStatusID
END
