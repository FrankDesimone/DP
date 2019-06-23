CREATE TABLE [dbo].[QA]
(
    [QAID] INT NOT NULL IDENTITY, 
	[WorkOrderID] INT NOT NULL,
    [QASootOnFaceID] INT NULL, 
    [QAAshOnFaceID] INT NULL, 
	[QAAshColorID] INT NULL,
	[QAOutletColorID] INT NULL,
    [QABreachChannelsID] INT NULL,
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
    CONSTRAINT [FK_QAPresence_Ash] FOREIGN KEY ([QAAshOnFaceID]) REFERENCES [QAPresence]([QAPresenceID]),
    CONSTRAINT [FK_QAPresence_Soot] FOREIGN KEY ([QASootOnFaceID]) REFERENCES QAPresence(QAPresenceID),
    CONSTRAINT [FK_QA_QAColor] FOREIGN KEY ([QAAshColorID]) REFERENCES QAColor(QAColorID), 
    CONSTRAINT [FK_QA_QAColor_QAOutletColor] FOREIGN KEY ([QAOutletColorID]) REFERENCES QAColor(QAColorID),
    CONSTRAINT [PK_QA] PRIMARY KEY (QAID), 
    CONSTRAINT [FK_QA_QASubstrateOveralCondition] FOREIGN KEY (QASubstrateOveralConditionID) REFERENCES [QASubstrateOveralCondition]([QASubstrateOveralConditionID]), 
    CONSTRAINT [FK_QA_QASubstrateCraking] FOREIGN KEY ([QASubstrateCrakingID]) REFERENCES [QASubstrateCraking]([QASubstrateCrakingID]), 
    CONSTRAINT [FK_QABreachChannels] FOREIGN KEY ([QABreachChannelsID]) REFERENCES [QABreachChannels]([QABreachChannelsID])
)

GO

CREATE UNIQUE INDEX [IX_QA_WorkOrderID] ON [dbo].QA ([WorkOrderID])
