BEGIN TRY
    -- Load data from CSVs (Exchange and Depository)
    -- (For demonstration, BULK INSERT is used)
    BULK INSERT exchangestock
    FROM 'C:\Users\n.bhiva.metkari\Downloads\stock.csv'
    WITH (
        FIELDTERMINATOR = ',', 
        ROWTERMINATOR = '\n', 
        FIRSTROW = 2
    );

    BULK INSERT depositorystock
    FROM 'C:\Users\n.bhiva.metkari\Downloads\depository_data.csv'
    WITH (
        FIELDTERMINATOR = ',', 
        ROWTERMINATOR = '\n', 
        FIRSTROW = 2
    );

    -- Call the stored procedure to compare data
    EXEC CompareStockOwnership;
    
END TRY
BEGIN CATCH
    -- Handle the error (log it, raise it, etc.)
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    -- Optionally, log the error to an error log table
    INSERT INTO error_log (error_message, error_date)
    VALUES (ERROR_MESSAGE(), GETDATE());
END CATCH;


select * from error_log