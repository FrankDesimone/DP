CREATE TABLE [dbo].[QAProcessData]
(
	[QAProcessDataID] INT NOT NULL IDENTITY,
	[QAProcessID] INT NOT NULL,
	[TestLine] INT NOT NULL,
    [PSI] FLOAT NULL, 
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_QAProcessData] PRIMARY KEY ([QAProcessDataID]), 
    CONSTRAINT [FK_QAProcessData_QAProcess] FOREIGN KEY ([QAProcessID]) REFERENCES [QAProcess]([QAProcessID])
)

GO



CREATE INDEX [IX_QAProcessData_QAProcessID] ON [dbo].[QAProcessData] ([QAProcessID])
