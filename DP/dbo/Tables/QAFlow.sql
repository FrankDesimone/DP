CREATE TABLE [dbo].[QAFlow]
(
    [QAFlowID] INT NOT NULL IDENTITY, 
    [QualityControlID] INT NOT NULL, 
	[TargetVelocity] FLOAT,
	[MaxHertz] REAL,
	[AirTemp] REAL,
	[BarometricPressure] REAL,
	[BackPressure] REAL,
	[Coefficient_a] FLOAT,
	[Coefficient_b] FLOAT,
	[Coefficient_c] FLOAT,
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_QAFlow] PRIMARY KEY ([QAFlowID]), 
    CONSTRAINT [FK_QAFlow_QualityControl] FOREIGN KEY ([QualityControlID]) REFERENCES QA(QAlID) 
)

GO


CREATE INDEX [IX_QAFlow_QualityControlID] ON [dbo].[QAFlow] ([QualityControlID])
