USE [master]
GO
/****** Object:  Database [PLSQL]    Script Date: 12/15/2024 5:37:51 PM ******/
CREATE DATABASE [PLSQL]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PLSQL', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PLSQL.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PLSQL_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PLSQL_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [PLSQL] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PLSQL].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PLSQL] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PLSQL] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PLSQL] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PLSQL] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PLSQL] SET ARITHABORT OFF 
GO
ALTER DATABASE [PLSQL] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PLSQL] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PLSQL] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PLSQL] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PLSQL] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PLSQL] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PLSQL] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PLSQL] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PLSQL] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PLSQL] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PLSQL] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PLSQL] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PLSQL] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PLSQL] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PLSQL] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PLSQL] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PLSQL] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PLSQL] SET RECOVERY FULL 
GO
ALTER DATABASE [PLSQL] SET  MULTI_USER 
GO
ALTER DATABASE [PLSQL] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PLSQL] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PLSQL] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PLSQL] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PLSQL] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PLSQL] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'PLSQL', N'ON'
GO
ALTER DATABASE [PLSQL] SET QUERY_STORE = ON
GO
ALTER DATABASE [PLSQL] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PLSQL]
GO
/****** Object:  Table [dbo].[DepositoryStock]    Script Date: 12/15/2024 5:37:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DepositoryStock](
	[User_ID] [int] NULL,
	[Stock_ID] [varchar](10) NULL,
	[Stock_Name] [varchar](100) NULL,
	[Stock_Count] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[error_log]    Script Date: 12/15/2024 5:37:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[error_log](
	[error_message] [varchar](4000) NULL,
	[error_date] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExchangeStock]    Script Date: 12/15/2024 5:37:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExchangeStock](
	[User_ID] [int] NULL,
	[Stock_ID] [varchar](10) NULL,
	[Stock_Name] [varchar](100) NULL,
	[Stock_Count] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockComparisonLog]    Script Date: 12/15/2024 5:37:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockComparisonLog](
	[Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_ID] [int] NULL,
	[Stock_ID] [varchar](10) NULL,
	[Stock_Name] [varchar](100) NULL,
	[Exchange_Count] [int] NULL,
	[Depository_Count] [int] NULL,
	[Comparison_Result] [varchar](50) NULL,
	[Comparison_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Log_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[error_log] ADD  DEFAULT (getdate()) FOR [error_date]
GO
ALTER TABLE [dbo].[StockComparisonLog] ADD  DEFAULT (getdate()) FOR [Comparison_Date]
GO
/****** Object:  StoredProcedure [dbo].[CompareStockOwnership]    Script Date: 12/15/2024 5:37:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CompareStockOwnership]
AS
BEGIN
    -- Declare variables to hold data from the cursor
    DECLARE @User_ID INT;
    DECLARE @Stock_ID VARCHAR(10);
    DECLARE @Stock_Name VARCHAR(100);
    DECLARE @Exchange_Count INT;
    DECLARE @Depository_Count INT;

    -- Declare the cursor to fetch data from the ExchangeStock table
    DECLARE exchange_cursor CURSOR FOR
    SELECT e.User_ID, e.Stock_ID, e.Stock_Name, e.Stock_Count
    FROM ExchangeStock e;

    OPEN exchange_cursor;

    -- Fetch the first row from the cursor into the declared variables
    FETCH NEXT FROM exchange_cursor INTO @User_ID, @Stock_ID, @Stock_Name, @Exchange_Count;

    -- Start looping through the cursor
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Retrieve the stock count from the DepositoryStock table for the same user and stock ID
        SELECT @Depository_Count = Stock_Count
        FROM DepositoryStock
        WHERE User_ID = @User_ID AND Stock_ID = @Stock_ID;

        -- If the stock exists in the DepositoryStock table, compare the stock counts
        IF @Depository_Count IS NOT NULL
        BEGIN
            IF @Exchange_Count = @Depository_Count
            BEGIN
                -- Log as a match
                INSERT INTO StockComparisonLog (User_ID, Stock_ID, Stock_Name, Exchange_Count, Depository_Count, Comparison_Result)
                VALUES (@User_ID, @Stock_ID, @Stock_Name, @Exchange_Count, @Depository_Count, 'MATCH');
            END
            ELSE
            BEGIN
                -- Log as a mismatch
                INSERT INTO StockComparisonLog (User_ID, Stock_ID, Stock_Name, Exchange_Count, Depository_Count, Comparison_Result)
                VALUES (@User_ID, @Stock_ID, @Stock_Name, @Exchange_Count, @Depository_Count, 'MISMATCH');
            END
        END
        ELSE
        BEGIN
            -- Log missing stock in the Depository table
            INSERT INTO StockComparisonLog (User_ID, Stock_ID, Stock_Name, Exchange_Count, Depository_Count, Comparison_Result)
            VALUES (@User_ID, @Stock_ID, @Stock_Name, @Exchange_Count, NULL, 'MISSING IN DEPOSITORY');
        END

        -- Fetch the next row from the cursor
        FETCH NEXT FROM exchange_cursor INTO @User_ID, @Stock_ID, @Stock_Name, @Exchange_Count;
    END

    -- Close and deallocate the cursor
    CLOSE exchange_cursor;
    DEALLOCATE exchange_cursor;
END;

GO
/****** Object:  StoredProcedure [dbo].[LoadDepositoryData]    Script Date: 12/15/2024 5:37:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored procedure to load data from the depository CSV
CREATE PROCEDURE [dbo].[LoadDepositoryData]
    @FilePath VARCHAR(255)
AS
BEGIN
    -- Use BULK INSERT to load data from CSV
    BULK INSERT DepositoryStock
    FROM 'C:\Users\n.bhiva.metkari\Downloads\depository_data.csv'
    WITH (
        FIELDTERMINATOR = ',',  -- Column delimiter
        ROWTERMINATOR = '\n',    -- Row delimiter
        FIRSTROW = 2            -- Skip the header row
    );
END;

GO
/****** Object:  StoredProcedure [dbo].[LoadExchangeData]    Script Date: 12/15/2024 5:37:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored procedure to load data from the exchange CSV
CREATE PROCEDURE [dbo].[LoadExchangeData]
    @FilePath VARCHAR(255)
AS
BEGIN
    -- Use BULK INSERT to load data from CSV
    BULK INSERT ExchangeStock
    FROM 'C:\Users\n.bhiva.metkari\Downloads\stock.csv'
    WITH (
        FIELDTERMINATOR = ',',  -- Column delimiter
        ROWTERMINATOR = '\n',    -- Row delimiter
        FIRSTROW = 4            -- Skip the header row
    );
END;

GO
USE [master]
GO
ALTER DATABASE [PLSQL] SET  READ_WRITE 
GO
