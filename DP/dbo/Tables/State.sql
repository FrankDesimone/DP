CREATE TABLE [dbo].[State] (
	[StateID]	INT NOT NULL IDENTITY,
    [State]     CHAR (2)     NOT NULL,
    [StateName] NVARCHAR (100) NOT NULL, 
    CONSTRAINT [PK_State] PRIMARY KEY ([StateID])
);


GO

CREATE UNIQUE INDEX [IX_State_State] ON [dbo].[State] ([State])

GO

CREATE UNIQUE INDEX [IX_State_StateName] ON [dbo].[State] ([StateName])
