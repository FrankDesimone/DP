CREATE TABLE [dbo].[QualityControl]
(
    [QualityControlID] INT NOT NULL IDENTITY, 
	[WorkOrderID] INT NOT NULL,
    [QASootOnFaceID] INT NOT NULL, 
    [QAAshOnFaceID] INT NOT NULL, 
	[QAAshColorID] INT NOT NULL,
    [QASubstrateID] INT NOT NULL, 
    [QACoolantID] INT NOT NULL, 
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_QualityControl] PRIMARY KEY ([QualityControlID]), 
    CONSTRAINT [FK_QualityControl_WorkOrder] FOREIGN KEY ([WorkOrderID]) REFERENCES [WorkOrder]([WorkOrderID]), 
    CONSTRAINT [FK_QualityControl_QAAshOnFace] FOREIGN KEY ([QAAshOnFaceID]) REFERENCES [QAAshOnFace]([QAAshOnFaceID]),
    CONSTRAINT [FK_QualityControl_QASootOnFace] FOREIGN KEY ([QASootOnFaceID]) REFERENCES [QASootOnFace]([QASootOnFaceID]),
    CONSTRAINT [FK_QualityControl_QACoolant] FOREIGN KEY ([QACoolantID]) REFERENCES [QACoolant]([QACoolantID]), 
    CONSTRAINT [FK_QualityControl_QAAshColor] FOREIGN KEY ([QAAshColorID]) REFERENCES [QAAshColor]([QAAshColorID])
)

GO

CREATE INDEX [IX_QualityControl_WorkOrderID] ON [dbo].[QualityControl] ([WorkOrderID])
