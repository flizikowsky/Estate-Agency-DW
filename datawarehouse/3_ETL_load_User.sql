USE EstateAgency;
GO

MERGE DimUser AS DU
USING ( SELECT
			U.Email,
			U.Name + ' ' + U.Surname AS NameSurname
		FROM Estate.dbo.[USER] AS U
		WHERE U.IsStaff = 0 ) AS SRC
ON DU.Email = SRC.Email

WHEN NOT MATCHED THEN
	INSERT (Email, NameSurname)
	VALUES (SRC.Email, SRC.NameSurname);
GO
