-- Stored procedure to load data from the exchange CSV
exec LoadExchangeData @FilePath = 'C:\Users\n.bhiva.metkari\Downloads\stock.csv';


exec LoadDepositoryData @FilePath = 'C:\Users\n.bhiva.metkari\Downloads\depository_data.csv';

CREATE PROCEDURE LoadExchangeData
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


-- Stored procedure to load data from the depository CSV
CREATE PROCEDURE LoadDepositoryData
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
