CREATE TABLE [dbo].[SalesStatus] (
    [SalesStatusID] INT            NOT NULL,
    [SalesStatus]   NVARCHAR (250) NOT NULL,
    [Locked]        BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SalesStatus] PRIMARY KEY CLUSTERED ([SalesStatusID] ASC)
);

