﻿CREATE TABLE [dbo].[ECD] (
	[ECDID]	INT	NOT NULL IDENTITY,
    [CompanyID]     INT          NOT NULL,
    [SubstrateTypeID]   INT          NOT NULL,
    [ManufacturerID] INT          NOT NULL,
    [DeviceTypeID]      INT          NOT NULL, 
    [TimesCleaned]  INT          NOT NULL DEFAULT 0,
    [PartNumber]	nvarchar(100)	NOT NULL,	
    [SerialNumber]  NVARCHAR (100) NOT NULL,
    [OtherNumber]   NVARCHAR (100) NULL,
	[OuterDiameter]     FLOAT (53)   NOT NULL,
    [SubstrateDiameter] FLOAT (53)   NOT NULL,
    [OuterLength]       FLOAT (53)   NOT NULL,
    [SubstrateLength]   FLOAT (53)   NOT NULL,
	[DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_ECD] PRIMARY KEY ([ECDID]), 
    CONSTRAINT [FK_ECD_Company] FOREIGN KEY ([CompanyID]) REFERENCES [Company]([CompanyID]), 
    CONSTRAINT [FK_ECD_Substrate] FOREIGN KEY ([SubstrateTypeID]) REFERENCES [SubstrateType]([SubstrateTypeID]), 
    CONSTRAINT [FK_ECD_Manfacturer] FOREIGN KEY (ManufacturerID) REFERENCES [Manufacturer]([ManufacturerID]), 
    CONSTRAINT [FK_ECD_DeviceType] FOREIGN KEY ([DeviceTypeID]) REFERENCES [DeviceType]([DeviceTypeID])
);

