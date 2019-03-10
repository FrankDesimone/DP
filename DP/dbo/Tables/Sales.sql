CREATE TABLE [dbo].[Sales]
(
	[SalesID] INT NOT NULL IDENTITY,
	[BillingCompanyID] INT NOT NULL,
	[SalesNo] nvarchar(250) NOT null,
	[DateAdded] DATETIME NOT NULL DEFAULT getdate(), 	
	CONSTRAINT [PK_Sales] PRIMARY KEY ([SalesID]), 
	CONSTRAINT [FK_Sales_Company] FOREIGN KEY ([BillingCompanyID]) REFERENCES [Company]([CompanyID])
)

GO

CREATE UNIQUE INDEX [IX_Sales_SalesNo] ON [dbo].[Sales] ([SalesNo])
