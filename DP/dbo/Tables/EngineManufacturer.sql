CREATE TABLE [dbo].[EngineManufacturer] (
    [EngineManufacturerID] INT          NOT NULL IDENTITY,
    [EngineManufacturer]   NVARCHAR (100) NOT NULL, 
    CONSTRAINT [PK_EngineManufacturer] PRIMARY KEY ([EngineManufacturerID])
);


GO

CREATE UNIQUE INDEX [IX_EngineManufacturer_EngineManufacturer] ON [dbo].[EngineManufacturer] ([EngineManufacturer])
