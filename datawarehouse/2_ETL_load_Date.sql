USE EstateAgency;
GO

DECLARE @StartDate DATE = '2000-01-01';
DECLARE @EndDate DATE = '2100-12-31';
DECLARE @CurrentDate DATE = @StartDate;

WHILE @CurrentDate <= @EndDate
BEGIN
    MERGE INTO DimDate AS target
    USING (
        SELECT
            @CurrentDate AS DateKey,
            DATEPART(DAY, @CurrentDate) AS [Day],
            DATEPART(YEAR, @CurrentDate) AS [Year],
            DATENAME(MONTH, @CurrentDate) AS [Month],
            DATENAME(WEEKDAY, @CurrentDate) AS [DayOfWeek]
    ) AS source
    ON target.DateKey = source.DateKey
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (DateKey, [Day], [Year], [Month], [DayOfWeek])
        VALUES (source.DateKey, source.[Day], source.[Year], source.[Month], source.[DayOfWeek]);

    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END;
GO