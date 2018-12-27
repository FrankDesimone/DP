CREATE TABLE [dbo].[QualityControlProcess]
(
    [QualityControlProcessID] INT NOT NULL IDENTITY, 
    [QualityControlID] INT NOT NULL, 
    [ProcessID] INT NOT NULL, 
    [ECDMass] REAL NULL, 
    [InletCell12] REAL NULL, 
    [InletCell03] REAL NULL, 
    [InletCell06] REAL NULL, 
    [InletCell09] REAL NULL, 
    [InletCellCenter] REAL NULL, 
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_QualityControlProcess] PRIMARY KEY ([QualityControlProcessID]), 
    CONSTRAINT [FK_QualityControlProcess_QualityControl] FOREIGN KEY ([QualityControlID]) REFERENCES [QualityControl]([QualityControlID]), 
    CONSTRAINT [FK_QualityControlProcess_Process] FOREIGN KEY ([ProcessID]) REFERENCES [Process]([ProcessID])
)

GO

CREATE INDEX [IX_QualityControlProcess_QualityControlID] ON [dbo].[QualityControlProcess] ([QualityControlID])

GO

CREATE UNIQUE INDEX [IX_QualityControlProcess_QualityControlID_ProcessID] ON [dbo].[QualityControlProcess] ([QualityControlID],[ProcessID])
