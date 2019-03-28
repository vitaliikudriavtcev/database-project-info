-- =============================================
-- Author:		Vitalii Kudriavtcev
-- Create date: 21 march 2019
-- Description:	get all users data
-- =============================================
CREATE PROCEDURE [dbo].[GetUsers]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT	u.UserID
			, u.FirstName
			, u.LastName
			, u.Email
			, s.[Name] [Status]
	FROM	dbo.[User] u
			INNER JOIN dbo.UserStatus s ON u.StatusID = s.UserStatusID

END