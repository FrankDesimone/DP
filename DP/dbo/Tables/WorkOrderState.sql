CREATE TABLE [dbo].[WorkOrderState]
(
    [WorkOrderStateID] INT NOT NULL, 
    [WorkOrderState] NVARCHAR(100) NOT NULL, 
    CONSTRAINT [PK_WorkOrderState] PRIMARY KEY ([WorkOrderStateID])
)

GO

CREATE UNIQUE INDEX [IX_WorkOrderState_WorkOrderState] ON [dbo].[WorkOrderState] ([WorkOrderState])
