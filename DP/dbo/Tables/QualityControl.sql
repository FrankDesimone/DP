CREATE TABLE [dbo].[QualityControl]
(
    [QualityControlID] INT NOT NULL IDENTITY, 
	[WorkOrderID] INT NOT NULL,
    [SootOnFace] INT NOT NULL, 
    [AshOnFace] INT NOT NULL, 
    [Breach] INT NOT NULL, 
    [Substrate] INT NOT NULL, 
    [Coolant] INT NOT NULL, 
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_QualityControl] PRIMARY KEY ([QualityControlID]), 
    CONSTRAINT [FK_QualityControl_WorkOrder] FOREIGN KEY ([WorkOrderID]) REFERENCES [WorkOrder]([WorkOrderID]), 
    CONSTRAINT [FK_QualityControl_AshOnFace] FOREIGN KEY ([AshOnFace]) REFERENCES [DropdownValues]([DropdownValuesID]),
    CONSTRAINT [FK_QualityControl_Breach] FOREIGN KEY ([Breach]) REFERENCES [DropdownValues]([DropdownValuesID]),
    CONSTRAINT [FK_QualityControl_SootOnFace] FOREIGN KEY ([SootOnFace]) REFERENCES [DropdownValues]([DropdownValuesID]),
    CONSTRAINT [FK_QualityControl_Coolant] FOREIGN KEY ([Coolant]) REFERENCES [DropdownValues]([DropdownValuesID])
)

GO

CREATE INDEX [IX_QualityControl_WorkOrderID] ON [dbo].[QualityControl] ([WorkOrderID])
