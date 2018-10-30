CREATE TABLE [dbo].[Manufacturer] (
    [ManufacturerID]   INT          NOT NULL IDENTITY,
    [Manufacturer] NVARCHAR (100) NOT NULL, 
    CONSTRAINT [PK_Manufacturer] PRIMARY KEY ([ManufacturerID]) 
);


GO

CREATE UNIQUE INDEX [IX_Manufacturer_Manufacturer] ON [dbo].[Manufacturer] ([Manufacturer])
