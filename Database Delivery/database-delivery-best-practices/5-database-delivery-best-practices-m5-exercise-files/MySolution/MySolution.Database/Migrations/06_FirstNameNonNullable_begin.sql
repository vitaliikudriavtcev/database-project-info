ALTER TABLE dbo.Customer
	ADD CONSTRAINT Customer_FirstName_Default DEFAULT '' FOR FirstName

UPDATE dbo.Customer SET FirstName = '' WHERE FirstName IS NULL

ALTER TABLE dbo.Customer 
	ALTER COLUMN FirstName nvarchar(100) NOT NULL
