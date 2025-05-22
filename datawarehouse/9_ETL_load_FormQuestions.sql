USE EstateAgency;
GO

WITH FormQuestionSource AS (
	SELECT
		R.RequestType,
		C.CreatedOnline,
		A.AgeGroup,
		F.FinalStatus
	FROM ( SELECT 'Sale' AS RequestType UNION ALL SELECT 'Rent' ) AS R
	CROSS JOIN ( SELECT 'True' AS CreatedOnline UNION ALL SELECT 'False' ) AS C
	CROSS JOIN ( SELECT '18-29' AS AgeGroup UNION ALL SELECT '30-49' UNION ALL SELECT '50-69' UNION ALL SELECT '70+' ) AS A
	CROSS JOIN ( SELECT 'Successful' AS FinalStatus UNION ALL SELECT 'Terminated' ) AS F
	)
	MERGE INTO DimFormQuestions AS target
USING FormQuestionSource AS source
ON target.RequestType = source.RequestType
	AND target.CreatedOnline = source.CreatedOnline
	AND target.AgeGroup = source.AgeGroup
	AND target.FinalStatus = source.FinalStatus
WHEN NOT MATCHED BY TARGET THEN
	INSERT (RequestType, CreatedOnline, AgeGroup, FinalStatus)
	VALUES (source.RequestType, source.CreatedOnline, source.AgeGroup, source.FinalStatus);
GO