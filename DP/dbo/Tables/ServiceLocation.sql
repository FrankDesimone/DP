CREATE TABLE [dbo].[ServiceLocation] (
	[ServiceLocationID]	INT	NOT NULL IDENTITY,
	[CompanyID] INT NOT NULL,
    [Location] NVARCHAR (100) NOT NULL,
    [Address1] NVARCHAR (100)          NULL,
    [Address2] NVARCHAR (100)          NULL,
    [City] NVARCHAR (100)          NULL,
    [Zip] NVARCHAR (20)          NULL,
	[StateID]	INT	NULL,
    CONSTRAINT [PK_ServiceLocation] PRIMARY KEY ([ServiceLocationID]), 
    CONSTRAINT [FK_ServiceLocation_State] FOREIGN KEY ([StateID]) REFERENCES [State]([StateID]), 
    CONSTRAINT [FK_ServiceLocation_Company] FOREIGN KEY ([CompanyID]) REFERENCES [Company]([CompanyID]) 
);

