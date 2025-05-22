USE EstateAgency;
GO

IF OBJECT_ID('tempdb.dbo.#TempForm') IS NOT NULL DROP TABLE #TempForm;
GO

CREATE TABLE #TempForm (
	IsSuccessful          BIT,
	DateOfBirth           DATE,
	AccountCreated        BIT,
	IsCreatedOnline       BIT,
	RequestType           VARCHAR(4) CHECK (RequestType IN ('Sale', 'Rent')),
	RequestStartDate      DATE,
	RequestStartTime      TIME,
	RequestSubmissionTime TIME,
	CreatedBy             VARCHAR(128),
);

BULK INSERT #TempForm FROM 'data\form.csv' WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0A' );
GO

MERGE FactForm AS FF
USING ( SELECT
			DU.UserKey,
			DD.DateKey,
			FQ.QuestionKey,
			SR.RequestKey,
			DATEDIFF(MINUTE, TF.RequestStartTime, TF.RequestSubmissionTime) AS Duration

		FROM #TempForm AS TF
		INNER JOIN DimUser AS DU
			ON TF.CreatedBy = DU.Email
		INNER JOIN DimDate AS DD
			ON DD.Year = DATEPART(YEAR, TF.RequestStartDate) AND DD.Month = DATENAME(MONTH, TF.RequestStartDate) AND DD.Day = DATEPART(DAY, TF.RequestStartDate)
		INNER JOIN DimTime AS DT
			ON DATEPART(HOUR, TF.RequestStartTime) = DT.[Hour] AND DATEPART(MINUTE, TF.RequestStartTime) = DT.[Minute]
		INNER JOIN FactSellRequest AS SR
			ON TF.RequestStartDate = SR.FK_DateKey AND DT.TimeKey = SR.FK_TimeKey AND DU.UserKey = SR.FK_User
		INNER JOIN DimFormQuestions AS FQ
			ON
			CASE
				WHEN DATEDIFF(YEAR, TF.DateOfBirth, GETDATE()) BETWEEN 18 AND 29 THEN '18-29'
				WHEN DATEDIFF(YEAR, TF.DateOfBirth, GETDATE()) BETWEEN 30 AND 49 THEN '30-49'
				WHEN DATEDIFF(YEAR, TF.DateOfBirth, GETDATE()) BETWEEN 50 AND 69 THEN '50-69'
				ELSE '70+' END = FQ.AgeGroup
				AND
			TF.RequestType = FQ.RequestType
				AND
			CASE
				WHEN TF.IsCreatedOnline = 0 THEN 'False'
				ELSE 'True' END = FQ.CreatedOnline
				AND
			CASE
				WHEN TF.IsSuccessful = 0 THEN 'Terminated'
				ELSE 'Successful' END = FQ.FinalStatus ) AS SRC
ON FF.FK_CreatedBy = SRC.UserKey
	AND FF.FK_ReqDate = SRC.DateKey
	AND FF.FK_QuestionAns = SRC.QuestionKey
	AND FF.FK_RequestKey = SRC.RequestKey

WHEN NOT MATCHED THEN
	INSERT (FK_CreatedBy, FK_ReqDate, FK_QuestionAns, FK_RequestKey, RequestDuration)
	VALUES (SRC.UserKey, SRC.DateKey, SRC.QuestionKey, SRC.RequestKey, SRC.Duration);
GO
