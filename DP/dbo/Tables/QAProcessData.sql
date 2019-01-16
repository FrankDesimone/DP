CREATE TABLE [dbo].[QAFlowResults]
(
	[QAFlowResultsID] INT NOT NULL IDENTITY,
	[QAFlowID] INT NOT NULL, 
    [PSI] REAL NULL, 
    [SpaceVelocity] FLOAT NULL, 
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_QAFlowResults] PRIMARY KEY ([QAFlowResultsID]), 
    CONSTRAINT [FK_QAFlowResults_QAFlow] FOREIGN KEY ([QAFlowID]) REFERENCES [QAFlow]([QAFlowID])
)

GO

CREATE INDEX [IX_QAFlowDtl_QAFlowResults] ON [dbo].[QAFlowResults] ([QAFlowID])
