USE EstateAgency;
GO

WITH JunkSource AS (
	SELECT
		C.CreatedOnline,
		W.WasAgentAssigned,
		U.UserCategory
	FROM ( SELECT 'True' AS CreatedOnline UNION ALL SELECT 'False' ) AS C
	CROSS JOIN ( SELECT 'True' AS WasAgentAssigned UNION ALL SELECT 'False' ) AS W
	CROSS JOIN ( SELECT 'New' AS UserCategory UNION ALL SELECT 'Old' ) AS U
	)
	MERGE INTO DimJunk AS target
USING JunkSource AS source
ON target.CreatedOnline = source.CreatedOnline
	AND target.WasAgentAssigned = source.WasAgentAssigned
	AND target.UserCategory = source.UserCategory
WHEN NOT MATCHED BY TARGET THEN
	INSERT (CreatedOnline, WasAgentAssigned, UserCategory)
	VALUES (source.CreatedOnline, source.WasAgentAssigned, source.UserCategory);
GO
