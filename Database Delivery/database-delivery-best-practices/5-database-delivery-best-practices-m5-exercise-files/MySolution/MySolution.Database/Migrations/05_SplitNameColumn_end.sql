ALTER TABLE dbo.Customer DROP COLUMN Name
GO

DROP TRIGGER dbo.tr_CustomerNameInsert
GO

DROP TRIGGER dbo.tr_CustomerNameUpdate
GO

ALTER PROCEDURE [dbo].[sp_SelectCustomers]
AS
BEGIN
	SET NOCOUNT ON;
	
    SELECT c.CustomerID, c.LastName, c.FirstName
	FROM dbo.Customer c
END
GO
