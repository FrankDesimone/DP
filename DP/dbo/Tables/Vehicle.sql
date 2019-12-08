CREATE TABLE [dbo].[Vehicle]
(
	[VehicleID] INT NOT NULL IDENTITY,
	[CompanyID] INT NOT NULL,
	[ManufacturerID] INT          NOT NULL,	
	[VehicleTypeID] INT NOT NULL DEFAULT 1,
	[SerialNumber]   NVARCHAR (50) NULL,
	[AssetNumber]	NVARCHAR (50) NULL,
	[Model]          NVARCHAR (50) NULL,
	[Year] INT NULL,
	[InitialCleaningMiles] float  ,
	[InitialCleaningHours] float  ,
	[DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
	CONSTRAINT [PK_Vehicle] PRIMARY KEY ([VehicleID]), 
	CONSTRAINT [FK_Vehicle_Company] FOREIGN KEY ([CompanyID]) REFERENCES [Company]([CompanyID]) ,
	CONSTRAINT [FK_Vehicle_Manufacturer] FOREIGN KEY ([ManufacturerID]) REFERENCES [Manufacturer]([ManufacturerID]), 
    CONSTRAINT [FK_Vehicle_ToTable] FOREIGN KEY ([VehicleTypeID]) REFERENCES [VehicleType]([VehicleTypeID])
);

GO

CREATE UNIQUE INDEX [IX_Vehicle_SerialNumber_CompanyID] ON [dbo].[Engine] ([SerialNumber], [CompanyID])

GO

CREATE INDEX [IX_Vehicle_CompanyID] ON [dbo].[Vehicle] ([CompanyID])
