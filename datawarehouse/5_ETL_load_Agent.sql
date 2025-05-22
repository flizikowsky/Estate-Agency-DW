USE EstateAgency;
GO

-- Create temp table to load CSV into.
IF OBJECT_ID('tempdb.dbo.#TempAgent') IS NOT NULL DROP TABLE #TempAgent;
GO

CREATE TABLE #TempAgent (
	LicenceNumber      INT                  NOT NULL UNIQUE CHECK (LicenceNumber BETWEEN 10000 AND 99999),
	Name               VARCHAR(255)         NOT NULL,
	Surname            VARCHAR(255)         NOT NULL,
	PhoneNumber        CHAR(9) CHECK (PhoneNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	EmailAddress       NVARCHAR(128) UNIQUE NOT NULL,
	Address            VARCHAR(255)         NOT NULL,
	EmploymentStatus   VARCHAR(20)          NOT NULL CHECK (EmploymentStatus IN ('Full-time', 'Part-time', 'Contract')),
	StartDate          DATE                 NOT NULL CHECK (StartDate BETWEEN '2020-01-01' AND getdate()),
	Specialization     VARCHAR(20)          NOT NULL CHECK (Specialization IN ('Residential', 'Commercial', 'Rental')),
	WorkingHours       VARCHAR(10)          NOT NULL,
	AvailabilityStatus VARCHAR(20)          NOT NULL CHECK (AvailabilityStatus IN ('Available', 'Busy', 'On Leave')),
	CommissionFee      DECIMAL(3, 1)        NOT NULL CHECK (CommissionFee >= 0),
	Remarks            varchar(max),
);

-- Bulk insert into the temp table data from csv file
BULK INSERT #TempAgent FROM 'D:\Studies\Projects\Estate-Agency-DW\Data\agents.csv' WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0A' );
GO

WITH Source AS ( SELECT
					 TA.LicenceNumber,
					 TA.EmailAddress,
					 TA.Name + ' ' + TA.Surname AS NameSurname,
					 TA.EmploymentStatus,
					 TA.AvailabilityStatus,
					 TA.Specialization,
					 TA.WorkingHours,
					 TA.CommissionFee,
					 CASE
						 WHEN DATEDIFF(YEAR, TA.StartDate, GETDATE()) BETWEEN 0 AND 5 THEN '1-5'
						 WHEN DATEDIFF(YEAR, TA.StartDate, GETDATE()) BETWEEN 6 AND 10 THEN '5-10'
						 WHEN DATEDIFF(YEAR, TA.StartDate, GETDATE()) BETWEEN 11 AND 20 THEN '10-15'
						 ELSE '20+' END         AS YearsOfExperience,
					 GETDATE()                  AS StartDate
				 FROM #TempAgent AS TA )

UPDATE DA
SET DA.DeactivationDate = SRC.StartDate
FROM DimAgent AS DA
INNER JOIN Source AS SRC
	ON DA.BK_LicenceNumber = SRC.LicenceNumber
WHERE
	  DA.DeactivationDate IS NULL
  AND (DA.CommissionFee <> SRC.CommissionFee);



WITH Source AS ( SELECT
					 TA.LicenceNumber,
					 TA.EmailAddress,
					 TA.Name + ' ' + TA.Surname AS NameSurname,
					 TA.EmploymentStatus,
					 TA.AvailabilityStatus,
					 TA.Specialization,
					 TA.WorkingHours,
					 TA.CommissionFee,
					 CASE
						 WHEN DATEDIFF(YEAR, TA.StartDate, GETDATE()) BETWEEN 0 AND 5 THEN '1-5'
						 WHEN DATEDIFF(YEAR, TA.StartDate, GETDATE()) BETWEEN 6 AND 10 THEN '5-10'
						 WHEN DATEDIFF(YEAR, TA.StartDate, GETDATE()) BETWEEN 11 AND 20 THEN '10-15'
						 ELSE '20+' END         AS YearsOfExperience,
					 GETDATE()                  AS StartDate
				 FROM #TempAgent AS TA )

INSERT
INTO DimAgent (BK_LicenceNumber, Email, NameSurname, EmploymentStatus, AvailabilityStatus, Specialization, WorkingHours, CommissionFee, ActivationDate, DeactivationDate, YearsOfExperience)
SELECT
	SRC.LicenceNumber,
	SRC.EmailAddress,
	SRC.NameSurname,
	SRC.EmploymentStatus,
	SRC.AvailabilityStatus,
	SRC.Specialization,
	SRC.WorkingHours,
	SRC.CommissionFee,
	SRC.StartDate,
	NULL AS EndDate,
	SRC.YearsOfExperience
FROM Source AS SRC
LEFT JOIN DimAgent AS DA
	ON SRC.LicenceNumber = DA.BK_LicenceNumber AND DA.DeactivationDate IS NULL
WHERE DA.BK_LicenceNumber IS NULL OR SRC.CommissionFee <> DA.CommissionFee;
