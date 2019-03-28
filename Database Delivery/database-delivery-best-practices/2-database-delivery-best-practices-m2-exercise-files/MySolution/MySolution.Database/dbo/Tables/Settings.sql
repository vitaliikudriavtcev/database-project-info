CREATE TABLE [dbo].[Settings] (
    [Name]  NVARCHAR (200) NOT NULL,
    [Value] NVARCHAR (200) NOT NULL,
    CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([Name] ASC)
);

