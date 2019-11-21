CREATE TABLE [dbo].[SalesStatus]
(
    [SalesStatusID] INT NOT NULL, 
    [SalesStatus] NVARCHAR(250) NOT NULL, 
    [Locked] BIT NOT NULL DEFAULT 0, 
    CONSTRAINT [PK_SalesStatus] PRIMARY KEY ([SalesStatusID])
)
