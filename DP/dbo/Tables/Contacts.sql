CREATE TABLE [dbo].[Contacts] (
    [ContactsID]    INT           NOT NULL IDENTITY,
    [CompanyID]    INT           NOT NULL,
    [Address1]     NVARCHAR (100)  NOT NULL,
    [Address2]     NVARCHAR (100)  NULL,
    [City]         NVARCHAR (100)  NOT NULL,
    [Zip]          NVARCHAR (20)  NOT NULL,
    [FirstName]    NVARCHAR (100)  NOT NULL,
    [LastName]     NVARCHAR (100)  NOT NULL,
    [Phone]  NVARCHAR (15)  NOT NULL,
    [Email] NVARCHAR (100) NOT NULL,
    [Active]       BIT           NOT NULL DEFAULT 1,
    [StateID]       INT      NOT NULL, 
    CONSTRAINT [FK_Contacts_State] FOREIGN KEY ([StateID]) REFERENCES [State]([StateID]), 
    CONSTRAINT [FK_Contacts_Company] FOREIGN KEY ([CompanyID]) REFERENCES [Company]([CompanyID]), 
    CONSTRAINT [PK_Contacts] PRIMARY KEY ([ContactsID])
);


GO
