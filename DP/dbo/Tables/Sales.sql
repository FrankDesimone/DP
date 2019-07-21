﻿CREATE TABLE [dbo].[Sales]
(
	[SalesID] INT NOT NULL IDENTITY,
	[BillingCompanyID] INT NOT NULL,
	[SalesNo] nvarchar(250) NOT null,
	[CompanyID] INT NULL,
	[CompanyLocationsID] INT NOT NULL,
	[DateAdded] DATETIME NOT NULL DEFAULT getdate(), 	
	[Contact] NVARCHAR(250) NULL, 
	[TrackingNo] NVARCHAR(250) NULL, 
    CONSTRAINT [PK_Sales] PRIMARY KEY ([SalesID]), 
	CONSTRAINT [FK_Sales_BillCompany] FOREIGN KEY ([BillingCompanyID]) REFERENCES [Company]([CompanyID]), 
	CONSTRAINT [FK_Sales_CompanyLocation] FOREIGN KEY (CompanyLocationsID) REFERENCES CompanyLocations(CompanyLocationsID), 
    CONSTRAINT [FK_Sales_Company] FOREIGN KEY ([CompanyID]) REFERENCES [Company]([CompanyID]), 
)

GO

CREATE UNIQUE INDEX [IX_Sales_SalesNo] ON [dbo].[Sales] ([SalesNo])

GO

CREATE INDEX [IX_Sales_CompanyID] ON [dbo].[Sales] ([CompanyID])
