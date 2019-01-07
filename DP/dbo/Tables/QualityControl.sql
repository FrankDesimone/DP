CREATE TABLE [dbo].[QualityControl]
(
    [QualityControlID] INT NOT NULL IDENTITY, 
	[WorkOrderID] INT NOT NULL,
    [QASootOnFaceID] INT NULL, 
    [QAAshOnFaceID] INT NULL, 
	[QAAshColorID] INT NULL,
    [QASubstrateID] INT NULL, 
    [QACoolantID] INT NULL, 
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_QualityControl] PRIMARY KEY ([QualityControlID]), 
    CONSTRAINT [FK_QualityControl_WorkOrder] FOREIGN KEY ([WorkOrderID]) REFERENCES [WorkOrder]([WorkOrderID]), 
    CONSTRAINT [FK_QualityControl_QAAshOnFace] FOREIGN KEY ([QAAshOnFaceID]) REFERENCES [QAAshOnFace]([QAAshOnFaceID]),
    CONSTRAINT [FK_QualityControl_QASootOnFace] FOREIGN KEY ([QASootOnFaceID]) REFERENCES [QASootOnFace]([QASootOnFaceID]),
    CONSTRAINT [FK_QualityControl_QACoolant] FOREIGN KEY ([QACoolantID]) REFERENCES [QACoolant]([QACoolantID]), 
    CONSTRAINT [FK_QualityControl_QAAshColor] FOREIGN KEY ([QAAshColorID]) REFERENCES [QAAshColor]([QAAshColorID])
)

GO

CREATE UNIQUE INDEX [IX_QualityControl_WorkOrderID] ON [dbo].[QualityControl] ([WorkOrderID])
