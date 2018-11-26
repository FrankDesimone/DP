CREATE PROCEDURE [dbo].[spWorkOrderGet]
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
      ,w.[CompanyLocationID]
      ,w.[WorkOrderStatusID]
      ,w.[VehicleID]
      ,w.[EngineID]
      ,w.[ECDID]
      ,w.[PreventMaintAshCleanInter]
      ,w.[HighSootCEL]
      ,w.[EngineFailureFluidsInExhaust]
      ,w.[CleanReasonOther]
      ,w.[RoadHighway]
      ,w.[StartStop]
      ,w.[HighIdle]
      ,w.[DrivingTypeOther]
      ,w.[FirstCleaning]
      ,w.[VehicleTotalMileage]
      ,w.[VehicleTotalHours]
      ,w.[DateAdded]
  FROM [dbo].[WorkOrder] as w
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
