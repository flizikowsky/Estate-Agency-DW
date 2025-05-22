USE EstateAgency;
GO

WITH StatusSource AS (
	SELECT
		'Accepted' AS Status
	UNION ALL
	SELECT
		'Rejected'
	UNION ALL
	SELECT
		'Pending'
	UNION ALL
	SELECT
		'NotInterested'
	)
	MERGE INTO DimAssignStatus AS target
USING StatusSource AS source
ON target.Status = source.Status
WHEN NOT MATCHED BY TARGET THEN
	INSERT (Status)
	VALUES (source.Status);
GO
