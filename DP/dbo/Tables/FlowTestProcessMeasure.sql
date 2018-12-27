CREATE TABLE [dbo].[FlowTestProcessMeasure]
(
    [FlowTestProcessMeasureID] INT NOT NULL, 
    [FlowTestProcessID] INT NOT NULL, 
	[BlowerHZ] REAL,
	[PSI] REAL,
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_FlowTestProcessMeasure] PRIMARY KEY ([FlowTestProcessMeasureID]), 
    CONSTRAINT [FK_FlowTestProcessMeasure_FlowTestProcess] FOREIGN KEY ([FlowTestProcessID]) REFERENCES [FlowTestProcess]([FlowTestProcessID])
)

GO

CREATE INDEX [IX_FlowTestProcessMeasure_FlowTestProcessID] ON [dbo].[FlowTestProcessMeasure] ([FlowTestProcessID])
