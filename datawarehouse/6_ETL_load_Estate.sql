USE EstateAgency;
GO

MERGE DimEstate AS DE
USING ( SELECT
			E.EstateType,
			E.MarketType,
			E.DecorCondition,
			CASE WHEN S.BuyRent = 'Buy' THEN 'Sale' WHEN S.BuyRent = 'Rent' THEN 'Rent' END AS BuyRent,
			E.Area,
			E.NoFloors,
			DA.AddressKey                                                                   AS AddressKey
		FROM Estate.dbo.ESTATE AS E
		INNER JOIN Estate.dbo.SELLREQUEST AS S
			ON E.EstateId = S.FK_Estate
		INNER JOIN Estate.dbo.ADDRESS AS A
			ON E.FK_Address = A.AddressId
		INNER JOIN Estate.dbo.CITY AS C
			ON A.FK_City = C.CityId
		INNER JOIN DimAddress AS DA
			ON A.PostCode = DA.PostCode AND A.StreetName = DA.StreetName AND A.StreetNumber = DA.StreetNumber AND LEFT(C.CityName, 16) = DA.CityName AND LEFT(C.District, 32) = DA.CityDistrict ) AS SRC
ON DE.EstateType = SRC.EstateType AND DE.MarketType = SRC.MarketType AND DE.DecorCondition = SRC.DecorCondition AND DE.BuyRent = SRC.BuyRent AND DE.Area = SRC.Area AND DE.NoFloors = SRC.NoFloors AND
   DE.FK_Address = SRC.AddressKey
WHEN NOT MATCHED THEN
	INSERT (EstateType, MarketType, DecorCondition, BuyRent, Area, NoFloors, FK_Address)
	VALUES (SRC.EstateType, SRC.MarketType, SRC.DecorCondition, SRC.BuyRent, SRC.Area, SRC.NoFloors, SRC.AddressKey);
GO

