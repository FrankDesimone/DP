CREATE TABLE [dbo].[Engine] (
    [EngineID]             INT          NOT NULL IDENTITY,
	[CompanyID] INT NOT NULL,	
    [ManufacturerID] INT          NOT NULL,
    [SerialNumber]   NVARCHAR (50) NOT NULL,
    [Model]          NVARCHAR (50) NOT NULL,
	[Year] DATE NOT NULL, 
    CONSTRAINT [PK_Engine] PRIMARY KEY ([EngineID]), 
	CONSTRAINT [FK_Engine_Company] FOREIGN KEY ([CompanyID]) REFERENCES [Company]([CompanyID]) ,
    CONSTRAINT [FK_Engine_Manufacturer] FOREIGN KEY ([ManufacturerID]) REFERENCES [Manufacturer]([ManufacturerID])
);

