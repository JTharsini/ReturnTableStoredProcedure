USE [Test]
GO
/****** Object:  Table [dbo].[OwnerTypeAData]    Script Date: 7/28/2021 4:06:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OwnerTypeAData](
	[primaryKey] [bigint] IDENTITY(1,1) NOT NULL,
	[id] [varchar](15) NULL,
	[latest] [tinyint] NULL,
	[active] [tinyint] NULL
) ON [MAIN]
GO
/****** Object:  Table [dbo].[OwnerTypeBData]    Script Date: 7/28/2021 4:06:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OwnerTypeBData](
	[primaryKey] [bigint] IDENTITY(1,1) NOT NULL,
	[id] [varchar](15) NULL,
	[subclass] [tinyint] NULL,
	[latest] [tinyint] NULL,
	[active] [tinyint] NULL
) ON [MAIN]
GO
/****** Object:  Table [dbo].[TypeTable]    Script Date: 7/28/2021 4:06:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeTable](
	[primaryKey] [bigint] IDENTITY(1,1) NOT NULL,
	[id] [varchar](100) NULL,
	[value] [varchar](50) NULL
) ON [MAIN]
GO
/****** Object:  Table [dbo].[TypeUsingTableC]    Script Date: 7/28/2021 4:06:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeUsingTableC](
	[primaryKey] [bigint] IDENTITY(1,1) NOT NULL,
	[id] [varchar](15) NULL,
	[type] [int] NULL,
	[subtype] [int] NULL,
	[active] [tinyint] NULL,
	[created] [varchar](20) NULL,
	[latest] [tinyint] NULL,
	[timestamp] [varchar](20) NULL
) ON [MAIN]
GO
/****** Object:  Table [dbo].[TypeUsingTableD]    Script Date: 7/28/2021 4:06:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeUsingTableD](
	[primaryKey] [bigint] IDENTITY(1,1) NOT NULL,
	[label] [varchar](50) NULL,
	[type] [int] NULL,
	[common] [varchar](50) NULL,
	[comments] [varchar](200) NULL,
	[owner] [int] NULL
) ON [MAIN]
GO
SET IDENTITY_INSERT [dbo].[OwnerTypeAData] ON 

INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (1, N'1', 1, 0)
INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (2, N'1', 0, 1)
INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (3, N'1', 1, 1)
INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (4, N'4', 1, 1)
INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (5, N'5', 1, 1)
INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (6, N'6', 1, 1)
INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (7, N'7', 1, 1)
INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (8, N'8', 1, 1)
INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (9, N'9', 1, 1)
INSERT [dbo].[OwnerTypeAData] ([primaryKey], [id], [latest], [active]) VALUES (10, N'10', 1, 1)
SET IDENTITY_INSERT [dbo].[OwnerTypeAData] OFF
GO
SET IDENTITY_INSERT [dbo].[OwnerTypeBData] ON 

INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (1, N'1', 1, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (2, N'2', 2, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (3, N'3', 3, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (4, N'4', 0, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (5, N'5', 1, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (6, N'6', 2, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (7, N'7', 1, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (8, N'8', 0, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (9, N'9', 1, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (10, N'10', 2, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (11, N'11', 0, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (12, N'12', 3, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (13, N'13', 2, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (14, N'14', 3, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (15, N'15', 0, 1, 1)
INSERT [dbo].[OwnerTypeBData] ([primaryKey], [id], [subclass], [latest], [active]) VALUES (16, N'16', 3, 1, 1)
SET IDENTITY_INSERT [dbo].[OwnerTypeBData] OFF
GO
SET IDENTITY_INSERT [dbo].[TypeTable] ON 

INSERT [dbo].[TypeTable] ([primaryKey], [id], [value]) VALUES (1, N'ownerTypeA', N'3579')
INSERT [dbo].[TypeTable] ([primaryKey], [id], [value]) VALUES (2, N'ownerTypeB', N'3578')
INSERT [dbo].[TypeTable] ([primaryKey], [id], [value]) VALUES (3, N'ownerTypeCommon', N'661')
INSERT [dbo].[TypeTable] ([primaryKey], [id], [value]) VALUES (4, N'subTypeC', N'660')
INSERT [dbo].[TypeTable] ([primaryKey], [id], [value]) VALUES (5, N'entityType', N'657')
INSERT [dbo].[TypeTable] ([primaryKey], [id], [value]) VALUES (6, N'subTypeD', N'659')
SET IDENTITY_INSERT [dbo].[TypeTable] OFF
GO
SET IDENTITY_INSERT [dbo].[TypeUsingTableC] ON 

INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (1, N'1', 657, 659, 1, N'2021-07-28 16:03:18', 1, N'2021-07-19 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (2, N'2', 657, 659, 1, N'2021-07-28 16:03:18', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (3, N'3', 657, 660, 1, N'2021-07-28 16:03:18', 1, N'2021-07-19 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (4, N'4', 657, 660, 1, N'2021-07-20 12:58:08', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (5, N'5', 657, 660, 1, N'2021-07-20 12:58:08', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (6, N'6', 657, 660, 1, N'2021-07-20 12:58:08', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (8, N'8', 657, 659, 1, N'2021-07-28 16:03:18', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (9, N'9', 657, 660, 1, N'2021-07-28 16:03:18', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (10, N'10', 657, 660, 1, N'2021-07-20 12:58:08', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (11, N'11', 657, 660, 1, N'2021-07-28 16:03:18', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (12, N'12', 657, 660, 1, N'2021-07-28 16:03:18', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (13, N'13', 657, 660, 1, N'2021-07-28 16:03:18', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (14, N'14', 657, 660, 1, N'2021-07-20 12:58:08', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (15, N'15', 657, 660, 1, N'2021-07-20 12:58:08', 1, N'2021-07-20 12:58:08')
INSERT [dbo].[TypeUsingTableC] ([primaryKey], [id], [type], [subtype], [active], [created], [latest], [timestamp]) VALUES (16, N'16', 657, 660, 1, N'2021-07-20 12:58:08', 1, N'2021-07-20 12:58:08')
SET IDENTITY_INSERT [dbo].[TypeUsingTableC] OFF
GO
SET IDENTITY_INSERT [dbo].[TypeUsingTableD] ON 

INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (1, N'', 661, N'1 : 2021-07-19', N'res', 1)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (2, N'', 661, N'2 : 2021-07-20', N'res', 2)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (3, N'', 661, N'16 : 2021-07-19', N'res', 3)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (4, N'', 661, N'8 : 2021-07-20', N'off', 4)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (5, N'', 661, N'1 : 2021-07-20', N'not', 5)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (6, N'', 661, N'2 : 2021-07-20', N'not', 6)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (7, N'', 661, N'3 : 2021-07-20', N'res', 8)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (8, N'', 661, N'16 : 2021-07-20', N'res', 9)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (9, N'', 661, N'4 : 2021-07-20', N'off', 10)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (10, N'', 661, N'14 : 2021-07-20', N'res', 11)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (11, N'', 661, N'13 : 2021-07-20', N'res', 12)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (12, N'', 661, N'12 : 2021-07-20', N'res', 13)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (13, N'', 661, N'5 : 2021-07-20', N'not', 14)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (14, N'', 661, N'10 : 2021-07-20', N'not', 15)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (15, N'', 661, N'9 : 2021-07-20', N'not', 16)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (854, N'PATCH-Id', 3578, N'1 : 2021-07-19', N'res', 1)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (855, N'PATCH-Id', 3578, N'2 : 2021-07-20', N'res', 2)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (856, N'PATCH-Id', 3578, N'3 : 2021-07-20', N'res', 8)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (857, N'PATCH-Id', 3578, N'16 : 2021-07-19', N'res', 3)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (858, N'PATCH-Id', 3578, N'16 : 2021-07-20', N'res', 9)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (859, N'PATCH-Id', 3578, N'14 : 2021-07-20', N'res', 11)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (860, N'PATCH-Id', 3578, N'13 : 2021-07-20', N'res', 12)
INSERT [dbo].[TypeUsingTableD] ([primaryKey], [label], [type], [common], [comments], [owner]) VALUES (861, N'PATCH-Id', 3578, N'12 : 2021-07-20', N'res', 13)
SET IDENTITY_INSERT [dbo].[TypeUsingTableD] OFF
GO
