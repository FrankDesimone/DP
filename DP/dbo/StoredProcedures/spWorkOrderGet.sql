﻿CREATE PROCEDURE [dbo].[spWorkOrderGet]
	@WorkOrderID     INT  
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

SELECT  w.[WorkOrderID]
		,w.[SalesID]
		,s.[SalesNo]
		,cl.[CompanyID]
		,s.BillingCompanyID
		,s.[CompanyLocationID]
		,s.Contact
		,w.[VehicleID]
		,w.[EngineID]
		,e.[ECDID]
		,w.[PreventMaintAshCleanInter]
		,w.[HighSootCEL]
		,w.[EngineFailureFluidsInExhaust]
		,w.[CleaningReasonID]
		,w.[RoadHighway]
		,w.[StartStop]
		,w.[HighIdle]
		,w.[DrivingTypeID]
		,w.[VehicleMileage] 
		,w.VehicleHours
		,w.[DateAdded]
  FROM [dbo].[WorkOrder] as w
		inner join Sales as s on w.SalesID = s.SalesID
		inner join dbo.CompanyLocations as cl on s.CompanyLocationID = cl.CompanyLocationsID
		left outer join ECD as e on w.WorkOrderID = e.WorkOrderID
  where w.WorkOrderID = @WorkOrderID;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = 'spWorkOrderGet:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH