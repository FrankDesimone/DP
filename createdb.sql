CREATE TABLE State
(
  State CHAR(2) NOT NULL,
  StateName VARCHAR(20) NOT NULL,
  PRIMARY KEY (State)
);


CREATE TABLE Substrate
(
  SubstrateID INT NOT NULL,
  SubstrateType VARCHAR(100) NOT NULL,
  PRIMARY KEY (SubstrateID),
  UNIQUE (SubstrateType)
);



CREATE TABLE Manufacturer
(
  ManufacturerID INT NOT NULL,
  ManufacturerName VARCHAR(50) NOT NULL,
  PRIMARY KEY (ManufacturerID),
  UNIQUE (ManufacturerName)
);



CREATE TABLE DeviceType
(
  Description CHAR NOT NULL,
  DeviceID INT NOT NULL,
  PRIMARY KEY (DeviceID),
  UNIQUE (Description)
);



CREATE TABLE EngineManufacturer
(
  EngineManufacturerID INT NOT NULL,
  EngineManufacturer VARCHAR(50) NOT NULL,
  PRIMARY KEY (EngineManufacturerID),
  UNIQUE (EngineManufacturer)
);



CREATE TABLE PartNumber
(
  PartNumberID INT NOT NULL,
  PartNumber VARCHAR(20) NOT NULL,
  PRIMARY KEY (PartNumberID),
  UNIQUE (PartNumber)
);



CREATE TABLE CleaningReason
(
  ReasonID INT NOT NULL,
  ReasonDescription INT NOT NULL,
  PRIMARY KEY (ReasonID),
  UNIQUE (ReasonDescription)
);



CREATE TABLE DrivingType
(
  DrivingTypeID INT NOT NULL,
  DrivingTypeDescription INT NOT NULL,
  PRIMARY KEY (DrivingTypeID),
  UNIQUE (DrivingTypeDescription)
);



CREATE TABLE ServiceLocation
(
  LocationID INT NOT NULL,
  LocationDescription VARCHAR(50) NOT NULL,
  Address1 INT,
  Address2 INT,
  City INT,
  Zip INT,
  State CHAR(2),
  PRIMARY KEY (LocationID),
  FOREIGN KEY (State) REFERENCES State(State),
  UNIQUE (LocationDescription)
);



CREATE TABLE VehicleMake
(
  MakeID INT NOT NULL,
  MakeDescription VARCHAR(50) NOT NULL,
  PRIMARY KEY (MakeID),
  UNIQUE (MakeDescription)
);



CREATE TABLE Company
(
  CompanyID INT NOT NULL,
  CompanyName VARCHAR(50) NOT NULL,
  BillingAddress1 VARCHAR(50) NOT NULL,
  BillingCity VARCHAR(50) NOT NULL,
  BillingZip VARCHAR(10) NOT NULL,
  BillingAddress2 VARCHAR(50),
  Active INT NOT NULL,
  BillingState CHAR(2) NOT NULL,
  ContactID INT NOT NULL,
  PRIMARY KEY (CompanyID),
  FOREIGN KEY (BillingState) REFERENCES State(State),
  FOREIGN KEY (ContactID) REFERENCES Contacts(ContactID),
  UNIQUE (CompanyName)
);



CREATE TABLE Contacts
(
  ContactID INT NOT NULL,
  Address1 VARCHAR(50) NOT NULL,
  Address2 VARCHAR(50),
  City VARCHAR(50) NOT NULL,
  Zip VARCHAR(11) NOT NULL,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  PhoneNumber VARCHAR(15) NOT NULL,
  EmailAddress VARCHAR(100) NOT NULL,
  Active INT NOT NULL,
  CompanyID INT NOT NULL,
  State CHAR(2) NOT NULL,
  PRIMARY KEY (ContactID),
  FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID),
  FOREIGN KEY (State) REFERENCES State(State)
);



CREATE TABLE ECD
(
  TimesCleaned INT NOT NULL,
  SerialNumber VARCHAR(50) NOT NULL,
  OtherNumber VARCHAR(50),
  ECD_ID INT NOT NULL,
  CompanyID INT NOT NULL,
  SubstrateID INT NOT NULL,
  ManfacturerID INT NOT NULL,
  PartNumberID INT NOT NULL,
  DeviceID INT NOT NULL,
  PRIMARY KEY (ECD_ID),
  FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID),
  FOREIGN KEY (SubstrateID) REFERENCES Substrate(SubstrateID),
  FOREIGN KEY (ManfacturerID) REFERENCES Manufacturer(ManufacturerID),
  FOREIGN KEY (PartNumberID) REFERENCES PartNumber(PartNumberID),
  FOREIGN KEY (DeviceID) REFERENCES DeviceType(DeviceID)
);



CREATE TABLE ECD_ID_VIN
(
  VIN CHAR(17) NOT NULL,
  ECD_ID INT NOT NULL,
  PRIMARY KEY (VIN, ECD_ID),
  FOREIGN KEY (ECD_ID) REFERENCES ECD(ECD_ID)
);



CREATE TABLE Engine
(
  EngineID INT NOT NULL,
  EngineSerialNumber VARCHAR(50) NOT NULL,
  EngineModel VARCHAR(50) NOT NULL,
  EngineManufacturerID INT,
  VIN CHAR(17) NOT NULL,
  ECD_ID INT NOT NULL,
  PRIMARY KEY (EngineID),
  FOREIGN KEY (EngineManufacturerID) REFERENCES EngineManufacturer(EngineManufacturerID),
  FOREIGN KEY (VIN, ECD_ID) REFERENCES ECD_ID_VIN(VIN, ECD_ID)
);



CREATE TABLE Measurements
(
  OuterDiameter FLOAT NOT NULL,
  SubstrateDiameter FLOAT NOT NULL,
  OuterLength FLOAT NOT NULL,
  SubstrateLength FLOAT NOT NULL,
  SerialNumber VARCHAR(50) NOT NULL,
  ManufacturerID INT NOT NULL,
  PartNumberID INT NOT NULL,
  ECD_ID INT NOT NULL,
  PRIMARY KEY (ManufacturerID, PartNumberID),
  FOREIGN KEY (ManufacturerID) REFERENCES Manufacturer(ManufacturerID),
  FOREIGN KEY (PartNumberID) REFERENCES PartNumber(PartNumberID),
  FOREIGN KEY (ECD_ID) REFERENCES ECD(ECD_ID)
);



CREATE TABLE Job
(
  JobID CHAR(10) NOT NULL,
  WorkOrder VARCHAR(10),
  PONumber VARCHAR(10),
  StartTime DATE,
  EndTime INT,
  TotalMilage FLOAT,
  TotalHours FLOAT,
  SaleOrderReceipt VARCHAR(10),
  ReasonID INT,
  DrivingTypeID INT,
  LocationID INT NOT NULL,
  VIN CHAR(17) NOT NULL,
  ECD_ID INT NOT NULL,
  PRIMARY KEY (JobID),
  FOREIGN KEY (ReasonID) REFERENCES CleaningReason(ReasonID),
  FOREIGN KEY (DrivingTypeID) REFERENCES DrivingType(DrivingTypeID),
  FOREIGN KEY (LocationID) REFERENCES ServiceLocation(LocationID),
  FOREIGN KEY (VIN, ECD_ID) REFERENCES ECD_ID_VIN(VIN, ECD_ID)
);



CREATE TABLE Vehicle
(
  VehicleID INT NOT NULL,
  UnitNumber VARCHAR(10),
  Model INT NOT NULL,
  Year INT NOT NULL,
  OffRoad INT NOT NULL,
  MakeID INT NOT NULL,
  VIN CHAR(17) NOT NULL,
  ECD_ID INT NOT NULL,
  PRIMARY KEY (VehicleID),
  FOREIGN KEY (MakeID) REFERENCES VehicleMake(MakeID),
  FOREIGN KEY (VIN, ECD_ID) REFERENCES ECD_ID_VIN(VIN, ECD_ID)
);



CREATE TABLE ComapnyLocation
(
  CompanyLocationID INT NOT NULL,
  Address1 VARCHAR(50) NOT NULL,
  Address2 VARCHAR(50) NOT NULL,
  City VARCHAR(50) NOT NULL,
  Zip VARCHAR(10) NOT NULL,
  Active INT NOT NULL,
  CompanyID INT NOT NULL,
  State CHAR(2) NOT NULL,
  ContactID INT NOT NULL,
  PRIMARY KEY (CompanyLocationID),
  FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID),
  FOREIGN KEY (State) REFERENCES State(State),
  FOREIGN KEY (ContactID) REFERENCES Contacts(ContactID)
);