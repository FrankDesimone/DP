CREATE TABLE [dbo].[WorkOrder]
(
    [WorkOrderID] INT NOT NULL, 
    [ServiceLocationID] INT NOT NULL, 
	[WorkOrderStateID] INT NOT NULL,
	[VehicleMakeID] INT NULL,
	[EngineID] INT NULL,
	[ECDID] INT NOT NULL,
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_WorkOrder] PRIMARY KEY ([WorkOrderID]), 
    CONSTRAINT [FK_WorkOrder_ServiceLocation] FOREIGN KEY ([ServiceLocationID]) REFERENCES CompanyLocations(CompanyLocationsID), 
    CONSTRAINT [FK_WorkOrder_WorkOrderState] FOREIGN KEY ([WorkOrderStateID]) REFERENCES [WorkOrderState]([WorkOrderStateID]), 
    CONSTRAINT [FK_WorkOrder_Engine] FOREIGN KEY ([EngineID]) REFERENCES [Engine]([EngineID]), 
    CONSTRAINT [FK_WorkOrder_VehicleMake] FOREIGN KEY ([VehicleMakeID]) REFERENCES [VehicleMake]([VehicleMakeID]), 
    CONSTRAINT [FK_WorkOrder_ECD] FOREIGN KEY ([ECDID]) REFERENCES [ECD]([ECDID])
)

GO

CREATE INDEX [IX_WorkOrder_ServiceLocationID] ON [dbo].[WorkOrder] ([ServiceLocationID])

GO

CREATE INDEX [IX_WorkOrder_WorkOrderStateID] ON [dbo].[WorkOrder] ([WorkOrderStateID])
