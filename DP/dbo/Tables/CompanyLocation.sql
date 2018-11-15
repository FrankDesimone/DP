CREATE TABLE [dbo].[CompanyLocations] (
	[CompanyLocationsID]	INT	NOT NULL IDENTITY,
	[CompanyID] INT NOT NULL,
    [Location] NVARCHAR (100) NOT NULL,
    [Address1] NVARCHAR (100)          NULL,
    [Address2] NVARCHAR (100)          NULL,
    [City] NVARCHAR (100)          NULL,
    [Zip] NVARCHAR (20)          NULL,
	[StateID]	INT	NULL,
    CONSTRAINT [PK_CompanyLocations] PRIMARY KEY (CompanyLocationsID), 
    CONSTRAINT [FK_CompanyLocations_State] FOREIGN KEY ([StateID]) REFERENCES [State]([StateID]), 
    CONSTRAINT [FK_CompanyLocations_Company] FOREIGN KEY ([CompanyID]) REFERENCES [Company]([CompanyID]) 
);

