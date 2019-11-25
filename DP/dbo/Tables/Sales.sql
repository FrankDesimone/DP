CREATE TABLE [dbo].[Sales] (
    [SalesID]            INT            IDENTITY (1, 1) NOT NULL,
    [BillingCompanyID]   INT            NOT NULL,
    [CleaningLocationID] INT            NOT NULL,
    [SalesNo]            NVARCHAR (250) NOT NULL,
    [CompanyID]          INT            NULL,
    [CompanyLocationsID] INT            NOT NULL,
    [SalesStatusID]      INT            DEFAULT ((1)) NOT NULL,
    [DateAdded]          DATETIME       DEFAULT (getdate()) NOT NULL,
    [Contact]            NVARCHAR (250) NULL,
    [TrackingNo]         NVARCHAR (250) NULL,
    [LegacyJobID]        NVARCHAR (250) NULL,
    CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED ([SalesID] ASC),
    CONSTRAINT [FK_Sales_BillCompany] FOREIGN KEY ([BillingCompanyID]) REFERENCES [dbo].[Company] ([CompanyID]),
    CONSTRAINT [FK_Sales_Company] FOREIGN KEY ([CompanyID]) REFERENCES [dbo].[Company] ([CompanyID]),
    CONSTRAINT [FK_Sales_Company_CleaningLocation] FOREIGN KEY ([CleaningLocationID]) REFERENCES [dbo].[CompanyLocations] ([CompanyLocationsID]),
    CONSTRAINT [FK_Sales_CompanyLocation] FOREIGN KEY ([CompanyLocationsID]) REFERENCES [dbo].[CompanyLocations] ([CompanyLocationsID]),
    CONSTRAINT [FK_Sales_SalesStatus] FOREIGN KEY ([SalesStatusID]) REFERENCES [dbo].[SalesStatus] ([SalesStatusID])
);



GO

CREATE UNIQUE INDEX [IX_Sales_SalesNo] ON [dbo].[Sales] ([SalesNo])

GO

CREATE INDEX [IX_Sales_CompanyID] ON [dbo].[Sales] ([CompanyID])
