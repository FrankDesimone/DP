CREATE TABLE [dbo].[Engine] (
    [EngineID]             INT          NOT NULL IDENTITY,
    [EngineManufacturerID] INT          NOT NULL,
    [VINID] INT NOT NULL, 
    [EngineSerialNumber]   NVARCHAR (50) NOT NULL,
    [EngineModel]          NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Engine] PRIMARY KEY ([EngineID]), 
    CONSTRAINT [FK_Engine_EngineManufacturer] FOREIGN KEY ([EngineManufacturerID]) REFERENCES [EngineManufacturer]([EngineManufacturerID]), 
    CONSTRAINT [FK_Engine_VIN] FOREIGN KEY ([VINID]) REFERENCES [VIN]([VINID])
);

