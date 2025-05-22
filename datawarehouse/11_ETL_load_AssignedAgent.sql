USE EstateAgency;
GO

MERGE FactAssignedAgent AS FAA
USING ( SELECT
			FSR.RequestKey,
			DA.AgentKey,
			DAS.StatusKey,
			DT.TimeKey,
			DD.DateKey,
			DA.CommissionFee * DBSR.AskingPrice AS Commision
		FROM Estate.dbo.REQUEST_AGENT AS RA
		INNER JOIN DimAssignStatus AS DAS
			ON DAS.Status = RA.Status
		INNER JOIN DimTime AS DT
			ON DT.Hour = DATEPART(HOUR, RA.UpdatedAt) AND DT.Minute = DATEPART(MINUTE, RA.UpdatedAt)
		INNER JOIN DimDate AS DD
			ON DD.DateKey = RA.UpdatedAt
		INNER JOIN DimAgent AS DA
			ON DA.Email = RA.Email
		INNER JOIN Estate.dbo.SELLREQUEST as DBSR
			ON DBSR.RequestId = RA.RequestId
		INNER JOIN DimTime AS DT2
			ON DATEPART(HOUR, DBSR.CreatedAt) = DT2.Hour AND DATEPART(MINUTE, DBSR.CreatedAt) = DT2.Minute
		INNER JOIN DimDate AS DD2
			ON DD2.DateKey = DBSR.CreatedAt
		INNER JOIN Estate.dbo.[USER] as DBU
			ON DBU.Email = DBSR.CreatedBy
		INNER JOIN DimUser as DU
			ON DU.Email = DBU.Email
		INNER JOIN FactSellRequest as FSR
			ON FSR.FK_DateKey = DD2.DateKey AND FSR.FK_TimeKey = DT2.TimeKey AND FSR.FK_User = DU.UserKey ) AS SRC
ON FAA.FK_RequestKey = SRC.RequestKey
	AND FAA.FK_AgentKey = SRC.AgentKey
	AND FAA.FK_StatusKey = SRC.StatusKey
	AND FAA.FK_TimeKey = SRC.TimeKey
	AND FAA.FK_DateKey = SRC.DateKey
	AND FAA.Commission = SRC.Commision

WHEN NOT MATCHED THEN
	INSERT (FK_RequestKey, FK_AgentKey, FK_StatusKey, FK_TimeKey, FK_DateKey, Commission)
	VALUES (SRC.RequestKey, SRC.AgentKey, SRC.StatusKey, SRC.TimeKey, SRC.DateKey, SRC.Commision);
GO
