CREATE TABLE [dbo].[QAProcess]
(
    [QAProcessID] INT NOT NULL IDENTITY, 
    [QAID] INT NOT NULL, 
    [ProcessID] INT NOT NULL, 
    [ECDMass] FLOAT NULL, 
    [InletCell12] FLOAT NULL, 
    [InletCell03] FLOAT NULL, 
    [InletCell06] FLOAT NULL, 
    [InletCell09] FLOAT NULL, 
    [InletCellCenter] FLOAT NULL, 
	[AirTemp] FLOAT,
	[BarometricPressure] FLOAT,
	[BackPressure] FLOAT,
	[Coefficient_a] FLOAT,
	[Coefficient_b] FLOAT,
	[Coefficient_c] FLOAT,
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [FK_QAProcess_QA] FOREIGN KEY ([QAID]) REFERENCES QA(QAID), 
    CONSTRAINT [FK_QAProcess_Process] FOREIGN KEY ([ProcessID]) REFERENCES [Process]([ProcessID]), 
    CONSTRAINT [PK_QAProcess] PRIMARY KEY ([QAProcessID])
)

GO

CREATE INDEX [IX_QAProcess_QAID] ON [dbo].[QAProcess] ([QAID])

GO

CREATE UNIQUE INDEX [IX_QAProcess_QAID_ProcessID] ON [dbo].[QAProcess] ([QAID],[ProcessID])
