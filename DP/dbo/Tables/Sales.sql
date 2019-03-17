CREATE TABLE [dbo].[Sales]
(
	[SalesID] INT NOT NULL IDENTITY,
	[BillingCompanyID] INT NOT NULL,
	[SalesNo] nvarchar(250) NOT null,
	[CompanyLocationID] INT NOT NULL,
	[ContactsID] INT NULL,
	[DateAdded] DATETIME NOT NULL DEFAULT getdate(), 	
	CONSTRAINT [PK_Sales] PRIMARY KEY ([SalesID]), 
	CONSTRAINT [FK_Sales_Company] FOREIGN KEY ([BillingCompanyID]) REFERENCES [Company]([CompanyID]), 
	CONSTRAINT [FK_Sales_Contacts] FOREIGN KEY (ContactsID) REFERENCES [Contacts]([ContactsID]), 
	CONSTRAINT [FK_Sales_CompanyLocation] FOREIGN KEY ([CompanyLocationID]) REFERENCES CompanyLocations(CompanyLocationsID), 
)

GO

CREATE UNIQUE INDEX [IX_Sales_SalesNo] ON [dbo].[Sales] ([SalesNo])
