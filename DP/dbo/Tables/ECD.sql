﻿CREATE TABLE [dbo].[ECD] (
	[ECDID]	INT	NOT NULL IDENTITY,
    [CompanyID]     INT          NOT NULL,
    [SubstrateID]   INT          NOT NULL,
    [ManfacturerID] INT          NOT NULL,
    [PartNumberID]  INT          NOT NULL,
    [DeviceTypeID]      INT          NOT NULL, 
    [TimesCleaned]  INT          NOT NULL,
    [SerialNumber]  NVARCHAR (50) NOT NULL,
    [OtherNumber]   NVARCHAR (50) NULL,
    CONSTRAINT [PK_ECD] PRIMARY KEY ([ECDID]), 
    CONSTRAINT [FK_ECD_Company] FOREIGN KEY ([CompanyID]) REFERENCES [Company]([CompanyID]), 
    CONSTRAINT [FK_ECD_Substrate] FOREIGN KEY ([SubstrateID]) REFERENCES [Substrate]([SubstrateID]), 
    CONSTRAINT [FK_ECD_Manfacturer] FOREIGN KEY ([ManfacturerID]) REFERENCES [Manufacturer]([ManufacturerID]), 
    CONSTRAINT [FK_ECD_PartNumber] FOREIGN KEY ([PartNumberID]) REFERENCES [PartNumber]([PartNumberID]), 
    CONSTRAINT [FK_ECD_DeviceType] FOREIGN KEY ([DeviceTypeID]) REFERENCES [DeviceType]([DeviceTypeID])
);

