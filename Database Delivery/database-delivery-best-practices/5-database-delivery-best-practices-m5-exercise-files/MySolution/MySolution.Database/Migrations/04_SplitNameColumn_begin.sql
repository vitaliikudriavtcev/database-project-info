ALTER TABLE Customer
	ADD FirstName nvarchar(100) NULL,
		LastName nvarchar(100) NULL
GO

UPDATE dbo.Customer
SET FirstName = LEFT(Name, CHARINDEX(' ', Name) - 1),
    LastName = RIGHT(Name, LEN(Name) - CHARINDEX(' ', Name))
GO

ALTER TABLE dbo.Customer ALTER COLUMN Name nvarchar(200) NULL
GO

CREATE TRIGGER dbo.tr_CustomerNameInsert ON dbo.Customer
AFTER INSERT AS
	SET NOCOUNT ON;

	DECLARE @Name nvarchar(200)
	SELECT @Name = Name
	FROM inserted

	IF (@Name IS NOT NULL)
		UPDATE dbo.Customer
		SET FirstName = LEFT(inserted.Name, CHARINDEX(' ', inserted.Name) - 1),
            LastName = RIGHT(inserted.Name, LEN(inserted.Name) - CHARINDEX(' ', inserted.Name))
		FROM inserted
		WHERE dbo.Customer.CustomerID = inserted.CustomerID
	ELSE
		UPDATE dbo.Customer
		SET Name = inserted.FirstName + ' ' + inserted.LastName
		FROM inserted
		WHERE dbo.Customer.CustomerID = inserted.CustomerID
GO

CREATE TRIGGER dbo.tr_CustomerNameUpdate ON dbo.Customer
AFTER UPDATE AS
	SET NOCOUNT ON;
	
	IF (UPDATE(Name))
		UPDATE dbo.Customer
		SET FirstName = LEFT(inserted.Name, CHARINDEX(' ', inserted.Name) - 1),
            LastName = RIGHT(inserted.Name, LEN(inserted.Name) - CHARINDEX(' ', inserted.Name))
		FROM inserted
		WHERE dbo.Customer.CustomerID = inserted.CustomerID
	ELSE
		UPDATE dbo.Customer
		SET Name = inserted.FirstName + ' ' + inserted.LastName
		FROM inserted
		WHERE dbo.Customer.CustomerID = inserted.CustomerID
GO


ALTER PROCEDURE [dbo].[sp_SelectCustomers]
AS
BEGIN
	SET NOCOUNT ON;
	
    SELECT c.CustomerID, c.Name, c.LastName, c.FirstName
	FROM dbo.Customer c
END
GO
