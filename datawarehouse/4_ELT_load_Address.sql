USE EstateAgency;
GO

MERGE DimAddress as DA
USING ( SELECT
			A.PostCode,
			A.StreetName,
			A.StreetNumber,
			LEFT(C.CityName, 16) as CityName,
			LEFT(C.District, 32) as District
		FROM Estate.dbo.ADDRESS AS A
		INNER JOIN Estate.dbo.CITY AS C
			ON A.FK_City = C.CityId ) AS SRC
ON DA.PostCode = SRC.PostCode AND DA.StreetName = SRC.StreetName AND DA.StreetNumber = SRC.StreetNumber AND DA.CityName = SRC.CityName AND DA.CityDistrict = SRC.District

WHEN NOT MATCHED THEN
	INSERT (PostCode, StreetName, StreetNumber, CityName, CityDistrict)
	VALUES (SRC.PostCode, SRC.StreetName, SRC.StreetNumber, SRC.CityName, SRC.District);
GO
