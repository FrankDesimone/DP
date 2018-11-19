CREATE TABLE [dbo].[WorkOrderStatus]
(
    [WorkOrderStatusID] INT NOT NULL, 
    [WorkOrderStatus] NVARCHAR(100) NOT NULL, 
    CONSTRAINT [PK_WorkOrderState] PRIMARY KEY ([WorkOrderStatusID])
)

GO

CREATE UNIQUE INDEX [IX_WorkOrderState_WorkOrderState] ON [dbo].[WorkOrderStatus] ([WorkOrderStatus])
