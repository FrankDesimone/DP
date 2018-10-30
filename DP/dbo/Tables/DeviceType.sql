CREATE TABLE [dbo].[DeviceType] (
	[DeviceTypeID]	int not null IDENTITY,
    [DeviceType] NVARCHAR(100) not null, 
    CONSTRAINT [PK_DeviceType] PRIMARY KEY ([DeviceTypeID]),
);


GO

CREATE UNIQUE INDEX [IX_DeviceType_DeviceType] ON [dbo].[DeviceType] ([DeviceType])
