EXEC sp_rename 'dbo.User', 'Customer';
EXEC sp_rename 'Customer.UserID', 'CustomerID' , 'COLUMN';
GO

CREATE VIEW [dbo].[User]
AS
SELECT CustomerID UserID, Name, Email, [Status]
FROM   dbo.Customer
GO

CREATE PROCEDURE [dbo].[sp_SelectCustomers]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT c.CustomerID, c.Name
	FROM dbo.Customer c
END
GO
