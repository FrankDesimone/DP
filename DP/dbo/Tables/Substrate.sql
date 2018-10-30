CREATE TABLE [dbo].[Substrate] (
    [SubstrateID]   INT           NOT NULL IDENTITY,
    [Substrate] NVARCHAR (100) NOT NULL, 
    CONSTRAINT [PK_Substrate] PRIMARY KEY ([SubstrateID]),
);


GO

CREATE UNIQUE INDEX [IX_Substrate_Substrate] ON [dbo].[Substrate] ([Substrate])
