CREATE TABLE [dbo].[WorkOrder]
(
	[WorkOrderID] INT NOT NULL IDENTITY, 
	[SalesID] INT NOT NULL,
	[WorkOrderStatusID] INT NOT NULL,
	[VehicleID] INT NULL,
	[EngineID] INT NULL,
	[ECDID] INT NOT NULL,	
	[PreventMaintAshCleanInter] bit NOT NULL DEFAULT 0 ,
	[HighSootCEL]bit NOT NULL DEFAULT 0,
	[EngineFailureFluidsInExhaust] bit NOT NULL DEFAULT 0,
	[CleaningReasonID] INT,
	[RoadHighway] bit NOT NULL DEFAULT 0 ,
	[StartStop]bit NOT NULL DEFAULT 0,
	[HighIdle]bit NOT NULL DEFAULT 0,
	[DrivingTypeID] INT,
	[VehicleMileage] INT ,
	[VehicleHours] INT  ,
	[DateAdded] DATETIME NOT NULL DEFAULT getdate(), 
	CONSTRAINT [PK_WorkOrder] PRIMARY KEY ([WorkOrderID]), 
	CONSTRAINT [FK_WorkOrder_WorkOrderState] FOREIGN KEY ([WorkOrderStatusID]) REFERENCES [WorkOrderStatus]([WorkOrderStatusID]), 
	CONSTRAINT [FK_WorkOrder_Engine] FOREIGN KEY ([EngineID]) REFERENCES [Engine]([EngineID]), 
	CONSTRAINT [FK_WorkOrder_Vehicle] FOREIGN KEY ([VehicleID]) REFERENCES [Vehicle]([VehicleID]), 
	CONSTRAINT [FK_WorkOrder_ECD] FOREIGN KEY ([ECDID]) REFERENCES [ECD]([ECDID]), 
	CONSTRAINT [FK_WorkOrder_CleaningReason] FOREIGN KEY ([CleaningReasonID]) REFERENCES [CleaningReason]([CleaningReasonID]), 
	CONSTRAINT [FK_WorkOrder_DrivingType] FOREIGN KEY ([DrivingTypeID]) REFERENCES [DrivingType]([DrivingTypeID]), 
	CONSTRAINT [FK_WorkOrder_Sales] FOREIGN KEY ([SalesID]) REFERENCES [Sales]([SalesID])
)

GO


CREATE INDEX [IX_WorkOrder_WorkOrderStatusID] ON [dbo].[WorkOrder] ([WorkOrderStatusID])

GO

CREATE INDEX [IX_WorkOrder_SalesID] ON [dbo].[WorkOrder] ([SalesID])
