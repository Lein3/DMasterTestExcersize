SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Articuls](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_Articuls] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Xarticuls](
	[RecID] [int] NOT NULL,
	[ParentID] [int] NOT NULL,
 CONSTRAINT [PK_Xarticuls] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC,
	[ParentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [dbo].[Articuls] ON 
INSERT [dbo].[Articuls] ([ID], [Name]) VALUES (1, N'Чай')
INSERT [dbo].[Articuls] ([ID], [Name]) VALUES (2, N'Заварка')
INSERT [dbo].[Articuls] ([ID], [Name]) VALUES (3, N'Сахар')
INSERT [dbo].[Articuls] ([ID], [Name]) VALUES (4, N'Торт')
INSERT [dbo].[Articuls] ([ID], [Name]) VALUES (5, N'Тесто')
INSERT [dbo].[Articuls] ([ID], [Name]) VALUES (6, N'Мука')
INSERT [dbo].[Articuls] ([ID], [Name]) VALUES (7, N'Яйцо')
INSERT [dbo].[Articuls] ([ID], [Name]) VALUES (8, N'Яблоко')
SET IDENTITY_INSERT [dbo].[Articuls] OFF
GO

INSERT [dbo].[Xarticuls] ([RecID], [ParentID]) VALUES (1, 2)
INSERT [dbo].[Xarticuls] ([RecID], [ParentID]) VALUES (1, 3)
INSERT [dbo].[Xarticuls] ([RecID], [ParentID]) VALUES (4, 3)
INSERT [dbo].[Xarticuls] ([RecID], [ParentID]) VALUES (4, 5)
INSERT [dbo].[Xarticuls] ([RecID], [ParentID]) VALUES (5, 6)
INSERT [dbo].[Xarticuls] ([RecID], [ParentID]) VALUES (5, 7)
GO
