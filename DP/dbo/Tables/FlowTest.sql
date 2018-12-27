CREATE TABLE [dbo].[FlowTest]
(
    [FlowTestID] INT NOT NULL IDENTITY, 
    [WorkOrderID] INT NOT NULL, 
    [DateAdded] NCHAR(10) NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_FlowTest] PRIMARY KEY ([FlowTestID]), 
    CONSTRAINT [FK_FlowTest_WorkOrderID] FOREIGN KEY ([WorkOrderID]) REFERENCES [WorkOrder]([WorkOrderID])
)

GO

CREATE INDEX [IX_FlowTest_WorkOrderID] ON [dbo].[FlowTest] ([WorkOrderID])
