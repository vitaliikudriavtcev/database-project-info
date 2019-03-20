-- Display rows in the settings table
SELECT [Package], [Key], [Value]
  FROM [Admin].[Settings]

-- Change to N
UPDATE [Admin].[Settings]
   SET [Value] = 'N'
 WHERE [Package] = '14_3_AdminSettings_Child_2'
   AND [Key] = 'RunPackage'

-- Reset to Y
UPDATE [Admin].[Settings]
   SET [Value] = 'Y'
 WHERE [Package] = '14_3_AdminSettings_Child_2'
   AND [Key] = 'RunPackage'


-- Reset
DROP TABLE [Admin].[Settings];

CREATE TABLE [Admin].[Settings]
(
  [Package] NVARCHAR(255)  NOT NULL
, [Key]     NVARCHAR(255)  NOT NULL
, [Value]   NVARCHAR(2000) NOT NULL
)

INSERT INTO [Admin].[Settings]
  ([Package], [Key], [Value])
VALUES 
    ('14_1_AdminSettings_Master'
    , 'PretendConnectionString'
    , 'Here is a pretend connection string'
    )
  , ('14_3_AdminSettings_Child_2', 'RunPackage', 'Y')
  , ('14_4_AdminSettings_Child_3', 'Loop', 'Loop 1')
  , ('14_4_AdminSettings_Child_3', 'Loop', 'Loop 2')
  , ('14_4_AdminSettings_Child_3', 'Loop', 'Loop 3')

