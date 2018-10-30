﻿CREATE TABLE [dbo].[Company] (
    [CompanyID]       INT          NOT NULL IDENTITY,
    [CompanyName]     NVARCHAR (50) NOT NULL,
    [BillingAddress1] NVARCHAR (50) NOT NULL,
    [BillingCity]     NVARCHAR (50) NOT NULL,
    [BillingZip]      NVARCHAR (10) NOT NULL,
    [BillingAddress2] NVARCHAR (50) NULL,
    [Active]          BIT          NOT NULL DEFAULT 1,
    [StateID]    INT     NOT NULL,
    [ContactsID]       INT          NOT NULL,
    CONSTRAINT [PK_Company] PRIMARY KEY ([CompanyID]), 
    CONSTRAINT [FK_Company_State] FOREIGN KEY ([StateID]) REFERENCES [State]([StateID]), 
    CONSTRAINT [FK_Company_Contacts] FOREIGN KEY ([ContactsID]) REFERENCES [Contacts]([ContactsID]),
);

