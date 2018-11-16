CREATE TABLE [dbo].[WorkOrder]
(
    [WorkOrderID] INT NOT NULL, 
    [CompanyLocationID] INT NOT NULL, 
	[WorkOrderStateID] INT NOT NULL,
	[VehicleID] INT NULL,
	[EngineID] INT NULL,
	[ECDID] INT NOT NULL,
    [DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [PK_WorkOrder] PRIMARY KEY ([WorkOrderID]), 
    CONSTRAINT [FK_WorkOrder_CompanyLocation] FOREIGN KEY ([CompanyLocationID]) REFERENCES CompanyLocations(CompanyLocationsID), 
    CONSTRAINT [FK_WorkOrder_WorkOrderState] FOREIGN KEY ([WorkOrderStateID]) REFERENCES [WorkOrderStatus]([WorkOrderStatusID]), 
    CONSTRAINT [FK_WorkOrder_Engine] FOREIGN KEY ([EngineID]) REFERENCES [Engine]([EngineID]), 
    CONSTRAINT [FK_WorkOrder_Vehicle] FOREIGN KEY ([VehicleID]) REFERENCES [Vehicle]([VehicleID]), 
    CONSTRAINT [FK_WorkOrder_ECD] FOREIGN KEY ([ECDID]) REFERENCES [ECD]([ECDID])
)

GO

CREATE INDEX [IX_WorkOrder_CompanyLocationID] ON [dbo].[WorkOrder] ([CompanyLocationID])

GO

CREATE INDEX [IX_WorkOrder_WorkOrderStateID] ON [dbo].[WorkOrder] ([WorkOrderStateID])
