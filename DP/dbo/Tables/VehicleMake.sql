CREATE TABLE [dbo].[VehicleMake] (
    [VehicleMakeID]          INT          NOT NULL IDENTITY,
    [VehicleMake] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([VehicleMakeID]),
);


GO

CREATE UNIQUE INDEX [IX_VehicleMake_VehicleMake] ON [dbo].[VehicleMake] ([VehicleMake])
