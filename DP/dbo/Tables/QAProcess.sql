CREATE TABLE [dbo].[QAProcess]
(
    [QAProcessID] INT NOT NULL IDENTITY, 
    [QAID] INT NOT NULL, 
    [ProcessID] INT NOT NULL, 
    [ECDMass] REAL NULL, 
    [InletCell12] REAL NULL, 
    [InletCell03] REAL NULL, 
    [InletCell06] REAL NULL, 
    [InletCell09] REAL NULL, 
    [InletCellCenter] REAL NULL, 
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [FK_QAProcess_QA] FOREIGN KEY ([QAID]) REFERENCES QA(QAlID), 
    CONSTRAINT [FK_QAProcess_Process] FOREIGN KEY ([ProcessID]) REFERENCES [Process]([ProcessID]), 
    CONSTRAINT [PK_QAProcess] PRIMARY KEY ([QAProcessID])
)

GO

CREATE INDEX [IX_QAProcess_QAID] ON [dbo].[QAProcess] ([QAID])

GO

CREATE UNIQUE INDEX [IX_QAProcess_QAID_ProcessID] ON [dbo].[QAProcess] ([QAID],[ProcessID])
