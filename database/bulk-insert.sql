


----------------------------- data t1 ----------------------------------------------------------------------------
BULK INSERT [USER]
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\users.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A'
);

BULK INSERT CITY
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\city.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A'
);

BULK INSERT ADDRESS
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\address.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT ESTATE
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\estates.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT SELLREQUEST
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\sellRequests.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT REQUEST_AGENT
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\reqAgent.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

----------------------------- data t2 ----------------------------------------------------------------------------
BULK INSERT [USER]
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\users.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT CITY
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\city.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT ADDRESS
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\address.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT ESTATE
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\estates.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT SELLREQUEST
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\requests.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);

BULK INSERT REQUEST_AGENT
FROM 'C:\Users\smew\Desktop\DataWaehousy\Data\reqAgent.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001'
);