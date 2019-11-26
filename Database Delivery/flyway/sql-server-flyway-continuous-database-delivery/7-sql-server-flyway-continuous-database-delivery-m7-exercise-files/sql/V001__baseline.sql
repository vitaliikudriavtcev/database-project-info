/****** Object:  Table [dbo].[employees]    Script Date: 4/12/2015 7:23:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[employees](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title_id] [int] NOT NULL,
	[phone_number] [varchar](20) NULL,
	[name] [varchar](80) NULL,
	[birth_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[titles]    Script Date: 4/12/2015 7:23:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[titles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[employee_positions]    Script Date: 4/12/2015 7:23:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[employee_positions] AS
SELECT employees.id AS employee_id,
	name,
	title
FROM employees
	LEFT JOIN titles on employees.title_id = titles.id
GO
ALTER TABLE [dbo].[employees]  WITH CHECK ADD  CONSTRAINT [employees_titles_title_id] FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([id])
GO
ALTER TABLE [dbo].[employees] CHECK CONSTRAINT [employees_titles_title_id]
GO