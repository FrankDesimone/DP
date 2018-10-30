CREATE TABLE [dbo].[PartNumber] (
    [PartNumberID] INT          NOT NULL IDENTITY,
    [PartNumber]   NVARCHAR (100) NOT NULL, 
    CONSTRAINT [PK_PartNumber] PRIMARY KEY ([PartNumberID])
);


GO

