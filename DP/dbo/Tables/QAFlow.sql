CREATE TABLE [dbo].[QAFlow]
(
    [QAFlowID] INT NOT NULL IDENTITY, 
    [WorkOrderID] INT NOT NULL, 
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
    CONSTRAINT [FK_QAFlow_WorkOrder] FOREIGN KEY ([WorkOrderID]) REFERENCES [WorkOrder]([WorkOrderID]) 
)

GO


CREATE INDEX [IX_QAFlow_WorkOrderID] ON [dbo].[QAFlow] ([WorkOrderID])
