CREATE TABLE [dbo].[QualityControl]
(
    [QualityControlID] INT NOT NULL IDENTITY, 
	[WorkOrderID] INT NOT NULL,
    [SootOnFace] INT NULL, 
    [AshOnFace] INT NULL, 
    [Breach] INT NULL, 
    [Substrate] INT NULL, 
    [Coolant] INT NULL, 
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_QualityControl] PRIMARY KEY ([QualityControlID]), 
    CONSTRAINT [FK_QualityControl_WorkOrder] FOREIGN KEY ([WorkOrderID]) REFERENCES [WorkOrder]([WorkOrderID])
)

GO

CREATE INDEX [IX_QualityControl_WorkOrderID] ON [dbo].[QualityControl] ([WorkOrderID])
