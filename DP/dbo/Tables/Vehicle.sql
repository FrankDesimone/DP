CREATE TABLE [dbo].[Vehicle]
(
	[VehicleID] INT NOT NULL IDENTITY,
	[CompanyID] INT NOT NULL,
	[ManufacturerID] INT          NOT NULL,	
    [SerialNumber]   NVARCHAR (50) NOT NULL,
	[AssetNumber]	NVARCHAR (50) NULL,
    [Model]          NVARCHAR (50) NOT NULL,
	[Year] INT NOT NULL, 
    CONSTRAINT [PK_Vehicle] PRIMARY KEY ([VehicleID]), 
	CONSTRAINT [FK_Vehicle_Company] FOREIGN KEY ([CompanyID]) REFERENCES [Company]([CompanyID]) ,
    CONSTRAINT [FK_Vehicle_Manufacturer] FOREIGN KEY ([ManufacturerID]) REFERENCES [Manufacturer]([ManufacturerID])
);
