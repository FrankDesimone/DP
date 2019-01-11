CREATE TABLE [dbo].[QAFlowTest]
(
    [QAFlowTestID] INT NOT NULL IDENTITY, 
    [QAFlowID] INT NOT NULL, 
    [BlowerSettings] REAL NOT NULL, 
    [TheoreticalACDM] INT NOT NULL, 
    [CorrectedASFM] INT NOT NULL, 
    [MeasuredPSI] REAL NOT NULL, 
    [SpaceVel] INT NOT NULL, 
    CONSTRAINT [PK_QAFlowTest] PRIMARY KEY ([QAFlowTestID]), 
    CONSTRAINT [FK_QAFlowTest_QAFlow] FOREIGN KEY ([QAFlowID]) REFERENCES [QAFlow]([QAFlowID])
)

GO

CREATE INDEX [IX_QAFlowTest_QAFlowID] ON [dbo].[QAFlowTest] ([QAFlowID])
