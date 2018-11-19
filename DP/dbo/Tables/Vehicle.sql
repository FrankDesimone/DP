CREATE TABLE [dbo].[Vehicle]
(
	[VehicleID] INT NOT NULL IDENTITY,
    [SerialNumber]   NVARCHAR (50) NOT NULL,
	[AssetNumber]	NVARCHAR (50) NULL,
	[ManufacturerID] INT          NOT NULL,
    [Model]          NVARCHAR (50) NOT NULL,
	[Year] DATE NOT NULL, 
    CONSTRAINT [PK_Vehicle] PRIMARY KEY ([VehicleID]), 
    CONSTRAINT [FK_Vehicle_Manufacturer] FOREIGN KEY ([ManufacturerID]) REFERENCES [Manufacturer]([ManufacturerID])
);
