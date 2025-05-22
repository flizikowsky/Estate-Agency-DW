USE Estate;

-- Drop tables if they exist
DROP TABLE IF EXISTS REQUEST_AGENT;
DROP TABLE IF EXISTS SELLREQUEST;
DROP TABLE IF EXISTS ESTATE;
DROP TABLE IF EXISTS ADDRESS;
DROP TABLE IF EXISTS CITY;
DROP TABLE IF EXISTS [USER];

-- Create USER table
CREATE TABLE [USER] (
    Email NVARCHAR(128) PRIMARY KEY,
    Name NVARCHAR(32) NOT NULL,
    Surname NVARCHAR(64) NOT NULL,
    PasswordHash NVARCHAR(256) NOT NULL,
    PhoneNumber CHAR(9) CHECK (PhoneNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    IsActive NVARCHAR(20) CHECK (IsActive IN ('Active', 'Inactive', 'NotVerified')),
    IsStaff BIT NOT NULL,
    BirthDate DATE,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Create CITY table
CREATE TABLE CITY (
    CityId INT IDENTITY PRIMARY KEY,
    CityName NVARCHAR(128) NOT NULL,
    District NVARCHAR(64) NOT NULL
);

-- Create ADDRESS table
CREATE TABLE ADDRESS (
    AddressId INT IDENTITY PRIMARY KEY,
    PostCode CHAR(6) CHECK (PostCode LIKE '[0-9][0-9][0-9][0-9][0-9]'),
    StreetName NVARCHAR(128) NOT NULL,
    StreetNumber NVARCHAR(16) NOT NULL,
    Lat DECIMAL(8,6),
    Long DECIMAL(9,6),
    FK_City INT NOT NULL,
    FOREIGN KEY (FK_City) REFERENCES CITY(CityId)
);

-- Create ESTATE table
CREATE TABLE ESTATE (
    EstateId INT IDENTITY PRIMARY KEY,
    EstateType NVARCHAR(64) CHECK (EstateType IN ('Flat', 'SingleFamily', 'Condo')),
    Area DECIMAL(10,2) CHECK (Area > 0),
    NoFloors INT CHECK (NoFloors >= 0),
    MarketType NVARCHAR(20) CHECK (MarketType IN ('New', 'Used', 'Old', 'Renovated')),
    DecorCondition NVARCHAR(20) CHECK (DecorCondition IN ('FullyDecorated', 'Unfinished', 'InDevelopment', 'BareShell')),
    FK_Address INT NOT NULL,
    OwnedBy NVARCHAR(128) NULL,
    FOREIGN KEY (FK_Address) REFERENCES ADDRESS(AddressId),
    FOREIGN KEY (OwnedBy) REFERENCES [USER](Email) ON DELETE SET NULL
);

-- Create SELLREQUEST table
CREATE TABLE SELLREQUEST (
	RequestId INT IDENTITY PRIMARY KEY,
	AskingPrice DECIMAL(18,2) CHECK (AskingPrice >= 0),
	BuyRent NVARCHAR(10) CHECK (BuyRent IN ('Buy', 'Rent')),
	IsAgentAssigned BIT NOT NULL,
	IsMadeOnline BIT NOT NULL,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FK_Estate INT NOT NULL,
	CreatedBy NVARCHAR(128) NOT NULL,
	FOREIGN KEY (FK_Estate) REFERENCES ESTATE(EstateId) ON DELETE CASCADE,
	FOREIGN KEY (CreatedBy) REFERENCES [USER](Email)
);

-- Create REQUEST_AGENT table
CREATE TABLE REQUEST_AGENT (
    Email NVARCHAR(128) NOT NULL,
    RequestId INT NOT NULL,
    Status NVARCHAR(12) CHECK (Status IN ('Accepted', 'Rejected', 'Pending', 'NotInterested')),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (Email, RequestId),
    FOREIGN KEY (Email) REFERENCES [USER](Email),
    FOREIGN KEY (RequestId) REFERENCES SELLREQUEST(RequestId) ON DELETE CASCADE
);
