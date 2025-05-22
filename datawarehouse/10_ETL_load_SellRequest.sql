USE EstateAgency;
GO

MERGE FactSellRequest AS FSR
USING ( SELECT
			DT.TimeKey,
			DD.DateKey,
			DJ.JunkKey,
			DU.UserKey,
			DE.EstateKey,
			S.AskingPrice
		FROM Estate.dbo.SELLREQUEST AS S
		INNER JOIN Estate.dbo.[USER] AS U
			ON S.CreatedBy = U.Email
		INNER JOIN Estate.dbo.ESTATE AS E
			ON S.FK_Estate = E.EstateId
		INNER JOIN Estate.dbo.ADDRESS AS A
			ON E.FK_Address = A.AddressId
		INNER JOIN Estate.dbo.CITY AS C
			ON A.FK_City = C.CityId
		INNER JOIN DimTime AS DT
			ON DT.Hour = DATEPART(HOUR, S.CreatedAt) AND DT.Minute = DATEPART(MINUTE, S.CreatedAt)
		INNER JOIN DimDate AS DD
			ON DD.Year = DATEPART(YEAR, S.CreatedAt) AND DD.Month = DATENAME(MONTH, S.CreatedAt) AND DD.Day = DATEPART(DAY, S.CreatedAt)
		INNER JOIN DimJunk AS DJ
			ON DJ.CreatedOnline = S.IsMadeOnline AND DJ.WasAgentAssigned = S.IsAgentAssigned AND
			   DJ.UserCategory = CASE WHEN CAST(S.CreatedAt AS DATE) = CAST(U.CreatedAt AS DATE) THEN 'New' ELSE 'Old' END
		INNER JOIN DimUser AS DU
			ON DU.Email = U.Email
		INNER JOIN DimAddress AS DA
			ON A.PostCode = DA.PostCode AND A.StreetName = DA.StreetName AND A.StreetNumber = DA.StreetNumber AND LEFT(C.CityName, 16) = DA.CityName AND LEFT(C.District, 32) = DA.CityDistrict
		INNER JOIN DimEstate AS DE
			ON DE.FK_Address = DA.AddressKey AND DE.EstateType = E.EstateType AND DE.MarketType = E.MarketType AND DE.DecorCondition = E.DecorCondition AND DE.Area = E.Area AND
			   DE.NoFloors = E.NoFloors ) AS SRC
ON FSR.FK_TimeKey = SRC.TimeKey
	AND FSR.FK_DateKey = SRC.DateKey
	AND FSR.FK_Junk = SRC.JunkKey
	AND FSR.FK_User = SRC.UserKey
	AND FSR.FK_EstateKey = SRC.EstateKey
	AND FSR.AskingPrice = SRC.AskingPrice

WHEN NOT MATCHED THEN
	INSERT (FK_TimeKey, FK_DateKey, FK_Junk, FK_User, FK_EstateKey, AskingPrice)
	VALUES (SRC.TimeKey, SRC.DateKey, SRC.JunkKey, SRC.UserKey, SRC.EstateKey, SRC.AskingPrice);
GO

