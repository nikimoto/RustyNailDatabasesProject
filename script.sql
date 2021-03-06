USE [master]
GO
/****** Object:  Database [Supermarket]    Script Date: 22.7.2013 г. 23:11:20 ******/
CREATE DATABASE [Supermarket]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Supermarket', FILENAME = N'D:\School\Data\MSSQL11.MSSQLSERVER\MSSQL\DATA\Supermarket.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Supermarket_log', FILENAME = N'D:\School\Data\MSSQL11.MSSQLSERVER\MSSQL\DATA\Supermarket_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Supermarket] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Supermarket].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Supermarket] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Supermarket] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Supermarket] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Supermarket] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Supermarket] SET ARITHABORT OFF 
GO
ALTER DATABASE [Supermarket] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Supermarket] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Supermarket] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Supermarket] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Supermarket] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Supermarket] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Supermarket] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Supermarket] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Supermarket] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Supermarket] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Supermarket] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Supermarket] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Supermarket] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Supermarket] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Supermarket] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Supermarket] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Supermarket] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Supermarket] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Supermarket] SET RECOVERY FULL 
GO
ALTER DATABASE [Supermarket] SET  MULTI_USER 
GO
ALTER DATABASE [Supermarket] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Supermarket] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Supermarket] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Supermarket] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Supermarket', N'ON'
GO
USE [Supermarket]
GO
/****** Object:  Table [dbo].[DailyReports]    Script Date: 22.7.2013 г. 23:11:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyReports](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Day] [datetime] NOT NULL,
	[SuperMarketId] [int] NOT NULL,
 CONSTRAINT [PK_DailyReports] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Measures]    Script Date: 22.7.2013 г. 23:11:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Measures](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MeasureName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Measures] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Products]    Script Date: 22.7.2013 г. 23:11:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[MeasureId] [int] NOT NULL,
	[BasePrice] [money] NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SalesReport]    Script Date: 22.7.2013 г. 23:11:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [float] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[Sum] [money] NOT NULL,
 CONSTRAINT [PK_SalesReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Supermarkets]    Script Date: 22.7.2013 г. 23:11:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supermarkets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SupermarketName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Supermarkets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VendorExpenses]    Script Date: 22.7.2013 г. 23:11:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorExpenses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[Month] [date] NOT NULL,
	[Expenses] [money] NOT NULL,
 CONSTRAINT [PK_VendorExpenses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Vendors]    Script Date: 22.7.2013 г. 23:11:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vendors](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendorName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Vendors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[DailyReports] ON 

INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (70, CAST(0x0000A20100000000 AS DateTime), 3)
INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (71, CAST(0x0000A20100000000 AS DateTime), 4)
INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (72, CAST(0x0000A20100000000 AS DateTime), 5)
INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (73, CAST(0x0000A20200000000 AS DateTime), 3)
INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (74, CAST(0x0000A20200000000 AS DateTime), 4)
INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (75, CAST(0x0000A20200000000 AS DateTime), 6)
INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (76, CAST(0x0000A20200000000 AS DateTime), 5)
INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (77, CAST(0x0000A20300000000 AS DateTime), 3)
INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (78, CAST(0x0000A20300000000 AS DateTime), 4)
INSERT [dbo].[DailyReports] ([Id], [Day], [SuperMarketId]) VALUES (79, CAST(0x0000A20300000000 AS DateTime), 6)
SET IDENTITY_INSERT [dbo].[DailyReports] OFF
SET IDENTITY_INSERT [dbo].[Measures] ON 

INSERT [dbo].[Measures] ([Id], [MeasureName]) VALUES (13, N'Bottles')
INSERT [dbo].[Measures] ([Id], [MeasureName]) VALUES (14, N'Units')
INSERT [dbo].[Measures] ([Id], [MeasureName]) VALUES (15, N'Packs')
INSERT [dbo].[Measures] ([Id], [MeasureName]) VALUES (16, N'Cans')
INSERT [dbo].[Measures] ([Id], [MeasureName]) VALUES (17, N'Kg')
SET IDENTITY_INSERT [dbo].[Measures] OFF
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (40, 36, N'Beer "Zagorka"', 13, 0.8600)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (41, 37, N'Vodka "Targovishte"', 13, 7.5600)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (42, 50, N'Beer "Beck''s"', 13, 1.0300)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (43, 42, N'Chocolate "Milka"', 14, 2.8000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (44, 35, N'Nestle Lion', 14, 0.8000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (45, 35, N'KitKat', 14, 0.6800)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (46, 35, N'Mura', 14, 0.5000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (47, 35, N'Chocolate LZ', 14, 1.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (48, 35, N'Cholocates Nestle', 15, 3.5900)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (49, 35, N'Nesquik', 15, 5.6000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (50, 35, N'Nescafe 3in1', 15, 4.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (51, 38, N'Coca-Cola', 13, 1.8900)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (52, 38, N'Fanta', 13, 1.8900)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (53, 38, N'Nestea', 13, 3.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (54, 38, N'Sprite', 13, 1.8900)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (55, 38, N'Lift', 13, 1.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (56, 38, N'Coca-Cola Light', 13, 1.8900)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (57, 38, N'Coca-Cola Zero', 13, 1.8900)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (58, 40, N'Chocolates Lindt', 15, 5.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (59, 40, N'Chocolate Lindt', 14, 2.5000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (60, 41, N'Marlboro Gold', 15, 5.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (61, 41, N'Marlboro White', 15, 5.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (62, 39, N'RedBull Energy Drink', 16, 2.5000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (63, 43, N'Lutenitsa Deroni', 14, 2.2000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (64, 43, N'Mustard Deroni', 14, 1.5000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (65, 43, N'Mayonaise Deroni', 14, 2.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (66, 44, N'Toilet Paper Belana', 14, 2.6000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (67, 45, N'Irish Whiskey Bushmills 12yo', 13, 45.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (68, 45, N'Irish Whiskey Bushmills ', 13, 20.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (69, 46, N'Victory White 100', 15, 4.7000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (70, 46, N'Victory Silver', 15, 4.6000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (71, 46, N'Victory Blue 100', 15, 4.7000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (72, 46, N'Victory Slims White', 15, 4.7000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (73, 46, N'Victory Ultra', 15, 4.6000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (74, 46, N'Eva Blue Slims', 15, 4.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (75, 46, N'Eva Slims', 15, 4.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (76, 46, N'Melnik', 15, 4.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (77, 46, N'MM', 15, 4.4000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (78, 46, N'MM 100', 15, 4.5000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (79, 47, N'Beer "Kamenitza"', 13, 2.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (80, 47, N'Beer "Kamenitza Fresh Lemon"', 13, 1.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (81, 47, N'Beer "Kamenitza Fresh Grapefruit"', 13, 1.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (82, 36, N'Beer "Zagorka Fusion"', 13, 1.6000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (83, 48, N'Beer "Heineken"', 13, 2.2000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (84, 49, N'Water "Devin"', 13, 0.8000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (85, 50, N'Beer "Becks"', 13, 2.2900)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (86, 51, N'Irish Whiskey Johnnie Walker Red Label', 13, 18.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (87, 51, N'Irish Whiskey Johnnie Walker Black Label', 13, 45.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (88, 51, N'Irish Whiskey Johnnie Walker Yellow Label', 13, 100.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (89, 51, N'Irish Whiskey Johnnie Walker Blue Label', 13, 250.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (90, 51, N'Irish Whiskey Johnnie Walker Green Label', 13, 180.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (91, 52, N'Davidoff Gold', 15, 5.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (92, 52, N'Davidoff Classic', 15, 5.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (93, 52, N'Davidoff Slims', 15, 5.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (94, 52, N'Davidoff Superslims Gold', 15, 5.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (95, 52, N'Davidoff One', 15, 5.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (96, 53, N'Mustard Olineza', 14, 1.5000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (97, 53, N'Ketchup Olineza', 14, 2.0000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (98, 53, N'Lutenitza Olineza', 14, 2.2000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (99, 53, N'Mayonaise Olineza', 14, 2.3000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (100, 54, N'Orehite Lukanka', 14, 4.5000)
INSERT [dbo].[Products] ([Id], [VendorId], [ProductName], [MeasureId], [BasePrice]) VALUES (101, 54, N'Orehite Salam', 14, 2.3000)
SET IDENTITY_INSERT [dbo].[Products] OFF
SET IDENTITY_INSERT [dbo].[SalesReport] ON 

INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (166, 70, 40, 37, 1.0000, 37.0000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (167, 70, 41, 14, 8.5000, 119.0000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (168, 71, 42, 40, 1.2000, 48.0000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (169, 71, 40, 65, 0.9200, 59.8000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (170, 71, 43, 12, 2.9000, 34.8000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (171, 72, 43, 7, 2.8500, 19.9500)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (172, 72, 41, 4, 7.8000, 31.2000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (173, 73, 40, 11, 1.0000, 11.0000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (174, 73, 41, 20, 8.5000, 170.0000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (175, 74, 42, 43, 1.2000, 51.6000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (176, 74, 40, 78, 0.9200, 71.7600)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (177, 74, 43, 9, 2.9000, 26.1000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (178, 75, 42, 75, 1.0500, 78.7500)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (179, 75, 40, 146, 0.8800, 128.4800)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (180, 75, 41, 67, 7.7000, 515.9000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (181, 76, 43, 5, 2.8500, 14.2500)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (182, 76, 41, 3, 7.8000, 23.4000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (183, 77, 41, 24, 8.5000, 204.0000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (184, 77, 40, 16, 1.0000, 16.0000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (185, 78, 40, 90, 0.9200, 82.8000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (186, 78, 43, 14, 2.9000, 40.6000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (187, 78, 42, 18, 1.2000, 21.6000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (188, 79, 41, 12, 7.7000, 92.4000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (189, 79, 42, 60, 1.0500, 63.0000)
INSERT [dbo].[SalesReport] ([Id], [ReportId], [ProductId], [Quantity], [UnitPrice], [Sum]) VALUES (190, 79, 40, 230, 0.8800, 202.4000)
SET IDENTITY_INSERT [dbo].[SalesReport] OFF
SET IDENTITY_INSERT [dbo].[Supermarkets] ON 

INSERT [dbo].[Supermarkets] ([Id], [SupermarketName]) VALUES (1, N'Fantastico')
INSERT [dbo].[Supermarkets] ([Id], [SupermarketName]) VALUES (3, N'Supermarket “Bourgas – Plaza”')
INSERT [dbo].[Supermarkets] ([Id], [SupermarketName]) VALUES (4, N'Supermarket “Kaspichan – Center”')
INSERT [dbo].[Supermarkets] ([Id], [SupermarketName]) VALUES (5, N'Supermarket “Bay Ivan” – Zmeyovo')
INSERT [dbo].[Supermarkets] ([Id], [SupermarketName]) VALUES (6, N'Supermarket “Plovdiv – Stolipinovo”')
SET IDENTITY_INSERT [dbo].[Supermarkets] OFF
SET IDENTITY_INSERT [dbo].[Vendors] ON 

INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (35, N'Nestle Sofia Corp.')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (36, N'Zagorka Corp.')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (37, N'Targovishte Bottling Company Ltd.')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (38, N'Coca-Cola Corp.')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (39, N'Red Bull')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (40, N'Lindt')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (41, N'Marlboro')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (42, N'Milka')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (43, N'Deroni')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (44, N'Belana')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (45, N'Bushmills Delivery Co.')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (46, N'Bulgartabac AD')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (47, N'Kamenitza AD')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (48, N'Heineken ')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (49, N'Devin AD')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (50, N'Becks')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (51, N'Johnie Walker Co')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (52, N'Davidoff')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (53, N'Olineza AD')
INSERT [dbo].[Vendors] ([Id], [VendorName]) VALUES (54, N'Orehite OOD')
SET IDENTITY_INSERT [dbo].[Vendors] OFF
ALTER TABLE [dbo].[DailyReports]  WITH CHECK ADD  CONSTRAINT [FK_DailyReports_Supermarkets] FOREIGN KEY([SuperMarketId])
REFERENCES [dbo].[Supermarkets] ([Id])
GO
ALTER TABLE [dbo].[DailyReports] CHECK CONSTRAINT [FK_DailyReports_Supermarkets]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Measures] FOREIGN KEY([MeasureId])
REFERENCES [dbo].[Measures] ([Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Measures]
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Vendors] FOREIGN KEY([VendorId])
REFERENCES [dbo].[Vendors] ([Id])
GO
ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Vendors]
GO
ALTER TABLE [dbo].[SalesReport]  WITH CHECK ADD  CONSTRAINT [FK_SalesReport_DailyReports] FOREIGN KEY([ReportId])
REFERENCES [dbo].[DailyReports] ([Id])
GO
ALTER TABLE [dbo].[SalesReport] CHECK CONSTRAINT [FK_SalesReport_DailyReports]
GO
ALTER TABLE [dbo].[SalesReport]  WITH CHECK ADD  CONSTRAINT [FK_SalesReport_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([Id])
GO
ALTER TABLE [dbo].[SalesReport] CHECK CONSTRAINT [FK_SalesReport_Products]
GO
ALTER TABLE [dbo].[VendorExpenses]  WITH CHECK ADD  CONSTRAINT [FK_VendorExpenses_Vendors] FOREIGN KEY([VendorId])
REFERENCES [dbo].[Vendors] ([Id])
GO
ALTER TABLE [dbo].[VendorExpenses] CHECK CONSTRAINT [FK_VendorExpenses_Vendors]
GO
USE [master]
GO
ALTER DATABASE [Supermarket] SET  READ_WRITE 
GO
