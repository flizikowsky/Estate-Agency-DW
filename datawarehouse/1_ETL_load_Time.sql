USE EstateAgency;
GO

WITH TimeSeries AS (
	SELECT
		CAST('00:00:00' AS TIME) AS TimeValue
	UNION ALL
	SELECT
		DATEADD(MINUTE, 1, TimeValue)
	FROM TimeSeries
	WHERE
		TimeValue < '23:59:00'
	)
	MERGE INTO DimTime AS target
USING ( SELECT
			DATEPART(HOUR, TimeValue)   AS [Hour],
			DATEPART(MINUTE, TimeValue) AS [Minute]
		FROM TimeSeries ) AS source
ON target.Hour = source.Hour AND target.Minute = source.Minute
WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Hour], [Minute])
	VALUES (source.[Hour], source.[Minute])
	OPTION (MAXRECURSION 0);
Go