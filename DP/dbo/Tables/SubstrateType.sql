CREATE TABLE [dbo].[SubstrateType] (
    [SubstrateTypeID]   INT           NOT NULL IDENTITY,
    [SubstrateType] NVARCHAR (100) NOT NULL, 
    CONSTRAINT [PK_Substrate] PRIMARY KEY ([SubstrateTypeID]),
);


GO

CREATE UNIQUE INDEX [IX_SubstrateType_Substrate] ON [dbo].[SubstrateType] ([SubstrateType])
