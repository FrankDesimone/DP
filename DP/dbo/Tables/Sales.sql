CREATE TABLE [dbo].[Sales]
(
	[SalesID] INT NOT NULL IDENTITY,
	[BillingCompanyID] INT NOT NULL,
	[DateAdded] DATETIME NOT NULL DEFAULT getdate(), 	
	CONSTRAINT [PK_Sales] PRIMARY KEY ([SalesID]), 
	CONSTRAINT [FK_Sales_Company] FOREIGN KEY ([BillingCompanyID]) REFERENCES [Company]([CompanyID])
)
