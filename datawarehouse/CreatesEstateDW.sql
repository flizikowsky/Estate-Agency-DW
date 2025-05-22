USE EstateAgency;

DROP TABLE IF EXISTS FactForm;
DROP TABLE IF EXISTS FactAssignedAgent;
DROP TABLE IF EXISTS FactSellRequest;
DROP TABLE IF EXISTS DimFormQuestions;
DROP TABLE IF EXISTS DimAgent;
DROP TABLE IF EXISTS DimAssignStatus;
DROP TABLE IF EXISTS DimJunk;
DROP TABLE IF EXISTS DimEstate;
DROP TABLE IF EXISTS DimAddress;
DROP TABLE IF EXISTS DimUser;
DROP TABLE IF EXISTS DimDate;
DROP TABLE IF EXISTS DimTime;

CREATE TABLE DimTime (
    TimeKey INT PRIMARY KEY IDENTITY(1,1),
    [Hour] TINYINT CHECK ([Hour] BETWEEN 0 AND 23),
    [Minute] TINYINT CHECK ([Minute] BETWEEN 0 AND 59)
);

CREATE TABLE DimDate (
    DateKey DATE PRIMARY KEY,
    [Day] TINYINT CHECK ([Day] BETWEEN 1 AND 31),
    [Year] SMALLINT CHECK ([Year] BETWEEN 1800 AND 2100),
    [Month] VARCHAR(10) CHECK ([Month] IN ('January', 'February', 'March', 'April', 'May', 'June', 
                                       'July', 'August', 'September', 'October', 'November', 'December')),
    [DayOfWeek] VARCHAR(10) CHECK ([DayOfWeek] IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'))
);

CREATE TABLE DimUser (
	UserKey INT PRIMARY KEY IDENTITY(1,1),
    Email VARCHAR(128) UNIQUE,
    NameSurname VARCHAR(128)
);

CREATE TABLE DimAddress (
	AddressKey INT PRIMARY KEY IDENTITY(1,1),
    PostCode VARCHAR(6),
    StreetName VARCHAR(128),
    StreetNumber VARCHAR(16),
    CityName VARCHAR(16),
    CityDistrict VARCHAR(32)
);

CREATE TABLE DimEstate (
    EstateKey INT PRIMARY KEY IDENTITY(1,1),
    EstateType VARCHAR(32) CHECK (EstateType IN ('Flat', 'SingleFamily', 'Condo')),
    MarketType VARCHAR(32) CHECK (MarketType IN ('New', 'Used', 'Old', 'Renovated')),
    DecorCondition VARCHAR(32) CHECK (DecorCondition IN ('FullyDecorated', 'Unfinished', 'InDevelopment', 'BareShell')),
    BuyRent VARCHAR(8) CHECK (BuyRent IN ('Rent', 'Sale')),
    Area DECIMAL(10,2) CHECK (Area >0),
    NoFloors INT CHECK (NoFloors >0),
    FK_Address INT FOREIGN KEY REFERENCES DimAddress(AddressKey),
);

CREATE TABLE DimJunk (
    JunkKey INT PRIMARY KEY IDENTITY(1,1),
    CreatedOnline VARCHAR(5) CHECK(CreatedOnline IN ('True','False')),
    WasAgentAssigned VARCHAR(5) CHECK(WasAgentAssigned IN ('True','False')),
    UserCategory VARCHAR(5) CHECK(UserCategory IN ('New','Old'))
);

CREATE TABLE DimAssignStatus (
    StatusKey INT PRIMARY KEY IDENTITY(1,1),
    Status VARCHAR(16) CHECK(Status IN ('Accepted','Rejected', 'Pending','NotInterested'))
);

CREATE TABLE DimAgent (
    AgentKey INT PRIMARY KEY IDENTITY(1,1),
    BK_LicenceNumber VARCHAR(16),
    Email VARCHAR(128),
    NameSurname VARCHAR(128),
    EmploymentStatus VARCHAR(32) CHECK (EmploymentStatus IN ('Full-time', 'Part-time', 'Contract')),
    AvailabilityStatus VARCHAR(16) CHECK (AvailabilityStatus IN ('Available', 'Busy', 'On leave')),
    Specialization VARCHAR(32) CHECK (Specialization IN ('Residential', 'Commercial', 'Rental')),
    WorkingHours VARCHAR(16) CHECK (
		WorkingHours LIKE '[0-9]-[0-9]' OR
		WorkingHours LIKE '[0-9]-[0-2][0-9]' OR
		WorkingHours LIKE '[0-2][0-9]-[0-9]' OR
		WorkingHours LIKE '[0-2][0-9]-[0-2][0-9]'),
    CommissionFee DECIMAL(3, 1) NOT NULL CHECK (CommissionFee >= 0),
    ActivationDate DATETIME CHECK (ActivationDate BETWEEN 2010 AND getdate()),
    DeactivationDate DATETIME CHECK (DeactivationDate BETWEEN 2010 AND getdate()),
    YearsOfExperience VARCHAR(5) CHECK(YearsOfExperience IN ('1-5','5-10', '10-15', '20+'))
);

CREATE TABLE DimFormQuestions (
    QuestionKey INT PRIMARY KEY IDENTITY(1,1),
    RequestType VARCHAR(32) CHECK (RequestType IN ('Sale', 'Rent')),
    CreatedOnline VARCHAR(5) CHECK(CreatedOnline IN ('True','False')),
    AgeGroup VARCHAR(8) CHECK (AgeGroup IN ('18-29', '30-49', '50-69', '70+')),
    FinalStatus VARCHAR(16) CHECK (FinalStatus IN ('Successful', 'Terminated'))
);

CREATE TABLE FactSellRequest (
    RequestKey INT PRIMARY KEY IDENTITY(1,1),
    FK_TimeKey INT FOREIGN KEY REFERENCES DimTime(TimeKey),
    FK_DateKey DATE FOREIGN KEY REFERENCES DimDate(DateKey),
    FK_Junk INT FOREIGN KEY REFERENCES DimJunk(JunkKey),
    FK_User INT FOREIGN KEY REFERENCES DimUser(UserKey),
    FK_EstateKey INT FOREIGN KEY REFERENCES DimEstate(EstateKey),
    AskingPrice DECIMAL(18,2)
);

CREATE TABLE FactAssignedAgent (
    FK_RequestKey INT FOREIGN KEY REFERENCES FactSellRequest(RequestKey),
    FK_AgentKey INT FOREIGN KEY REFERENCES DimAgent(AgentKey),
    FK_StatusKey INT FOREIGN KEY REFERENCES DimAssignStatus(StatusKey),
    FK_TimeKey INT FOREIGN KEY REFERENCES DimTime(TimeKey),
    FK_DateKey DATE FOREIGN KEY REFERENCES DimDate(DateKey),
    Commission DECIMAL(18,2),
    PRIMARY KEY (FK_RequestKey, FK_AgentKey, FK_StatusKey, FK_TimeKey, FK_DateKey)
);

CREATE TABLE FactForm (
    FK_CreatedBy INT FOREIGN KEY REFERENCES DimUser(UserKey),
    FK_ReqDate DATE FOREIGN KEY REFERENCES DimDate(DateKey),
    FK_QuestionAns INT FOREIGN KEY REFERENCES DimFormQuestions(QuestionKey),
    FK_RequestKey INT FOREIGN KEY REFERENCES FactSellRequest(RequestKey),
    RequestDuration INT
    PRIMARY KEY (FK_CreatedBy, FK_ReqDate, FK_QuestionAns, FK_RequestKey) 
);