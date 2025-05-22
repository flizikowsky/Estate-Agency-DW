USE Estate;

----------------------------- data t1 ----------------------------------------------------------------------------
BULK INSERT [USER]
FROM 'D:\Studies\Projects\Estate-Agency-DW\database\Data\users.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A'
);

BULK INSERT CITY
FROM 'D:\Studies\Projects\Estate-Agency-DW\database\Data\city.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A'
);

BULK INSERT ADDRESS
FROM 'D:\Studies\Projects\Estate-Agency-DW\database\Data\address.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT ESTATE
FROM 'D:\Studies\Projects\Estate-Agency-DW\database\Data\estates.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT SELLREQUEST
FROM 'D:\Studies\Projects\Estate-Agency-DW\database\Data\sellRequests.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT REQUEST_AGENT
FROM 'D:\Studies\Projects\Estate-Agency-DW\database\Data\reqAgent.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);