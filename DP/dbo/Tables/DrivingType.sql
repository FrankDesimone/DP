CREATE TABLE [dbo].[DrivingType] (
    [DrivingTypeID]          INT NOT NULL IDENTITY,
    [DrivingType] NVARCHAR(100) NOT NULL, 
    CONSTRAINT [PK_DrivingType] PRIMARY KEY ([DrivingTypeID])
);


GO

CREATE UNIQUE INDEX [IX_DrivingType_DrivingType] ON [dbo].[DrivingType] ([DrivingType])
