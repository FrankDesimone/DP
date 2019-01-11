CREATE TABLE [dbo].[QAFlow]
(
    [QAFlowID] INT NOT NULL IDENTITY, 
    [WorkOrderID] INT NOT NULL, 
    CONSTRAINT [PK_QAFlow] PRIMARY KEY ([QAFlowID]), 
    CONSTRAINT [FK_QAFlow_ToTable] FOREIGN KEY ([WorkOrderID]) REFERENCES [WorkOrder]([WorkOrderID])
)

GO

CREATE INDEX [IX_QAFlow_WorkOrderID] ON [dbo].[QAFlow] ([WorkOrderID])
