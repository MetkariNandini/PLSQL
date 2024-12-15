EXEC CompareStockOwnership;

SELECT * FROM StockComparisonLog;

CREATE PROCEDURE CompareStockOwnership
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