CREATE TABLE [dbo].[FlowTestProcess]
(
    [FlowTestProcessID] INT NOT NULL IDENTITY, 
    [FlowTestID] INT NOT NULL, 
    [ProcessID] INT NOT NULL, 
	[Temperature] REAL,
	[BarometricPressure] REAL,
	[Coefficient_A] REAL,
	[Coefficient_B] REAL,
	[Coefficient_C] REAL,
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_FlowTestProcess] PRIMARY KEY ([FlowTestProcessID]), 
    CONSTRAINT [FK_FlowTestProcess_FlowTest] FOREIGN KEY ([FlowTestID]) REFERENCES [FlowTest]([FlowTestID]), 
    CONSTRAINT [FK_FlowTestProcess_Process] FOREIGN KEY ([ProcessID]) REFERENCES [Process]([ProcessID])
)

GO

CREATE INDEX [IX_FlowTestProcess_FlowTestID] ON [dbo].[FlowTestProcess] ([FlowTestID])

GO

CREATE UNIQUE INDEX [IX_FlowTestProcess_FlowTestID_ProcessID] ON [dbo].[FlowTestProcess] ([FlowTestID],[ProcessID])
