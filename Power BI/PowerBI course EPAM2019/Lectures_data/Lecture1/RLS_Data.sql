--Replace <ACCOUNT> with the SECOND account provided to you
--This account represents a manager who is associated with two regions
DECLARE @LogonAccount NVARCHAR(255) = N'vitalii_kudriavtcev@epam.com';

CREATE TABLE [dbo].[Manager]
(
	[ManagerID] INT CONSTRAINT [PK_Manager] PRIMARY KEY CLUSTERED
	,[ManagerLogon] NVARCHAR(255) NOT NULL
);

INSERT [dbo].[Manager] VALUES
	(1, @LogonAccount)
	,(2, N'carmen.carrington@tailspintoys.com')
	,(3, N'haruto.suzuki@tailspintoys.com')
	,(4, N'jane.campbell@tailspintoys.com')
	,(5, N'john.bishop@tailspintoys.com')
	,(6, N'ted.baker@tailspintoys.com')
	,(7, N'ty.johnston@tailspintoys.com');
GO

CREATE TABLE [dbo].[ManagerRegion]
(
	[ManagerID] INT NOT NULL
	,[RegionID] INT NOT NULL
	,CONSTRAINT [PK_ManagerRegion] PRIMARY KEY CLUSTERED ([ManagerID], [RegionID])
	,CONSTRAINT [FK_ManagerRegion_Manager] FOREIGN KEY ([ManagerID]) REFERENCES [dbo].[Manager]([ManagerID])
	,CONSTRAINT [FK_ManagerRegion_Region] FOREIGN KEY ([RegionID]) REFERENCES [dbo].[Region]([RegionID])
);

--Insert manager/region relationships
INSERT [dbo].[ManagerRegion] VALUES
	(1, 1)
	,(1, 5)
	,(2, 6)
	,(3, 4)
	,(4, 3)
	,(5, 2)
	,(6, 1)
	,(7, 2)
	,(7, 6);
GO

--Create a view to retrieve manager and region relationships
CREATE VIEW [dbo].[vManagerRegion]
AS
	SELECT
		[m].[ManagerLogon]
		,[r].[RegionID]
		,[r].[CityFull]
	FROM
		[dbo].[Manager] AS [m]
		INNER JOIN [dbo].[ManagerRegion] AS [mr]
			ON [mr].[ManagerID] = [m].[ManagerID]
		INNER JOIN [dbo].[Region] AS [r]
			ON [r].[RegionID] = [mr].[RegionID];
GO

--Retrieve all rows from the view (to be used by the model)
--Verify that your account has permssions to see data for the Midwest and Southern regions
SELECT * FROM [dbo].[vManagerRegion];
GO
