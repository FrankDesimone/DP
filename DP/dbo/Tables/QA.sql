CREATE TABLE [dbo].[QA]
(
    [QAID] INT NOT NULL IDENTITY, 
	[WorkOrderID] INT NOT NULL,
    [QASootOnFaceID] INT NULL, 
    [QAAshOnFaceID] INT NULL, 
	[QAAshColorID] INT NULL,
    [QASubstrateID] INT NULL, 
    [Coolant] BIT NOT NULL DEFAULT 0, 
    [RedAsh] BIT NOT NULL DEFAULT 0, 
    [USignalReceived] BIT NOT NULL DEFAULT 0, 
    [ECDPinDropDepth] BIT NOT NULL DEFAULT 0, 
    [CleanChannels] REAL NULL, 
	[DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [FK_QA_WorkOrder] FOREIGN KEY ([WorkOrderID]) REFERENCES [WorkOrder]([WorkOrderID]), 
    CONSTRAINT [FK_QA_QAAshOnFace] FOREIGN KEY ([QAAshOnFaceID]) REFERENCES [QAAshOnFace]([QAAshOnFaceID]),
    CONSTRAINT [FK_QA_QASootOnFace] FOREIGN KEY ([QASootOnFaceID]) REFERENCES [QASootOnFace]([QASootOnFaceID]),
    CONSTRAINT [FK_QA_QAAshColor] FOREIGN KEY ([QAAshColorID]) REFERENCES [QAAshColor]([QAAshColorID]), 
    CONSTRAINT [PK_QA] PRIMARY KEY (QAID)
)

GO

CREATE UNIQUE INDEX [IX_QA_WorkOrderID] ON [dbo].QA ([WorkOrderID])
