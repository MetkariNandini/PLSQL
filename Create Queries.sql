-- Table to store exchange stock data
CREATE TABLE ExchangeStock (
    User_ID INT,
    Stock_ID VARCHAR(10),
    Stock_Name VARCHAR(100),
    Stock_Count INT
);

select * from ExchangeStock;

-- Table to store depository stock data
CREATE TABLE DepositoryStock (
    User_ID INT,
    Stock_ID VARCHAR(10),
    Stock_Name VARCHAR(100),
    Stock_Count INT
);
select * from DepositoryStock;

-- Table to log the comparison results
CREATE TABLE StockComparisonLog (
    Log_ID INT IDENTITY(1,1) PRIMARY KEY,
    User_ID INT,
    Stock_ID VARCHAR(10),
    Stock_Name VARCHAR(100),
    Exchange_Count INT,
    Depository_Count INT,
    Comparison_Result VARCHAR(50),
    Comparison_Date DATETIME DEFAULT GETDATE()
);

select * from StockComparisonLog;

CREATE TABLE error_log (
    error_message VARCHAR(4000),              -- Error message text
    error_date DATETIME DEFAULT GETDATE()    -- Date and time of the error
);
