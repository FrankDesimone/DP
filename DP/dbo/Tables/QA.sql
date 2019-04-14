CREATE TABLE [dbo].[QA]
(
    [QAID] INT NOT NULL IDENTITY, 
	[WorkOrderID] INT NOT NULL,
    [QASootOnFaceID] INT NULL, 
    [QAAshOnFaceID] INT NULL, 
	[QAAshColorID] INT NULL,
	[QAOutletColorID] INT NULL,
    [QASubstrateID] INT NULL,
	[QASubstrateCrakingID] INT NULL,
	[QASubstrateOveralConditionID] INT NULL,
    [Coolant] BIT NOT NULL DEFAULT 0, 
    [RedAsh] BIT NOT NULL DEFAULT 0, 
    [USignalReceived] BIT NOT NULL DEFAULT 0, 
    [ECDPinDropDepth] BIT NOT NULL DEFAULT 0, 
	[EngineEGRCoolant] BIT NOT NULL DEFAULT 0, 
	[WearCorrosion] BIT NOT NULL DEFAULT 0, 
	[FuelOil] BIT NOT NULL DEFAULT 0, 
 	[ContaminantsOther] NVARCHAR (255)  NULL,

    [CleanChannels] REAL NULL,
	[TargetMaxSpaceVelocity] FLOAT,
	[MaxHertz] FLOAT,
	[DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [FK_QA_WorkOrder] FOREIGN KEY ([WorkOrderID]) REFERENCES [WorkOrder]([WorkOrderID]), 
    CONSTRAINT [FK_QA_QAAshOnFace] FOREIGN KEY ([QAAshOnFaceID]) REFERENCES [QAAshOnFace]([QAAshOnFaceID]),
    CONSTRAINT [FK_QA_QASootOnFace] FOREIGN KEY ([QASootOnFaceID]) REFERENCES [QASootOnFace]([QASootOnFaceID]),
    CONSTRAINT [FK_QA_QAAshColor] FOREIGN KEY ([QAAshColorID]) REFERENCES [QAAshColor]([QAAshColorID]), 
    CONSTRAINT [FK_QA_QAAshColor_QAOutletColor] FOREIGN KEY ([QAOutletColorID]) REFERENCES [QAAshColor]([QAAshColorID]),
    CONSTRAINT [PK_QA] PRIMARY KEY (QAID), 
    CONSTRAINT [FK_QA_QASubstrateOveralCondition] FOREIGN KEY (QASubstrateOveralConditionID) REFERENCES [QASubstrateOveralCondition]([QASubstrateOveralConditionID]), 
    CONSTRAINT [FK_QA_QASubstrateCraking] FOREIGN KEY ([QASubstrateCrakingID]) REFERENCES [QASubstrateCraking]([QASubstrateCrakingID])
)

GO

CREATE UNIQUE INDEX [IX_QA_WorkOrderID] ON [dbo].QA ([WorkOrderID])
