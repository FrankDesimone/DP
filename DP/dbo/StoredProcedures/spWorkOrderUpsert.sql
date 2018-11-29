CREATE PROCEDURE [dbo].[spWorkOrderUpsert]
	@WorkOrderID      INT		 
    ,@CompanyLocationID  INT
	,@ContactsID INT = NULL
	,@WorkOrderStatusID  INT 
	,@VehicleID  INT = NULL 
	,@EngineID  INT = NULL 
	,@ECDID  INT 
	,@PreventMaintAshCleanInter  bit 
	,@HighSootCEL bit 
	,@EngineFailureFluidsInExhaust  bit
	,@CleanReasonOther  INT = NULL
	,@RoadHighway  bit 
	,@StartStop bit 
	,@HighIdle bit
	,@DrivingTypeOther  INT = NULL
	,@FirstCleaning  bit 
	,@VehicleTotalMileage  INT = NULL
	,@VehicleTotalHours  INT  = NULL	
	,@NewWorkOrderID      INT          = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	set @ErrorCode = 0;
	set @ErrorMsg = ''
	set @NewWorkOrderID = NULL;

	UPDATE w
	set 
		w.[CompanyLocationID]				  = @CompanyLocationID
		,w.[ContactsID]								= @ContactsID
		,w.[WorkOrderStatusID]				  = @WorkOrderStatusID
		,w.[VehicleID]						  = @VehicleID
		,w.[EngineID]						  = @EngineID
		,w.[ECDID]							  = @ECDID
		,w.[PreventMaintAshCleanInter]		  = @PreventMaintAshCleanInter
		,w.[HighSootCEL]					  = @HighSootCEL
		,w.[EngineFailureFluidsInExhaust]	  = @EngineFailureFluidsInExhaust
		,w.[CleaningReasonID]				  = @CleanReasonOther
		,w.[RoadHighway]					  = @RoadHighway
		,w.[StartStop]						  = @StartStop
		,w.[HighIdle]						  = @HighIdle
		,w.[DrivingTypeID]						= @DrivingTypeOther
		,w.[FirstCleaning]					  = @FirstCleaning
		,w.[VehicleTotalMileage]			  = @VehicleTotalMileage
		,w.[VehicleTotalHours]				  = @VehicleTotalHours
	FROM [dbo].[WorkOrder] as w
	where w.WorkOrderID = @WorkOrderID;


	if @@ROWCOUNT = 0
	begin

		INSERT INTO [dbo].[WorkOrder]
				   ([CompanyLocationID]
				   ,[ContactsID]
				   ,[WorkOrderStatusID]
				   ,[VehicleID]
				   ,[EngineID]
				   ,[ECDID]
				   ,[PreventMaintAshCleanInter]
				   ,[HighSootCEL]
				   ,[EngineFailureFluidsInExhaust]
				   ,[CleaningReasonID]
				   ,[RoadHighway]
				   ,[StartStop]
				   ,[HighIdle]
				   ,[DrivingTypeID]
				   ,[FirstCleaning]
				   ,[VehicleTotalMileage]
				   ,[VehicleTotalHours])
			 VALUES
				   ( @CompanyLocationID
				   ,@ContactsID
				   ,@WorkOrderStatusID
				   ,@VehicleID
				   ,@EngineID
				   ,@ECDID
				   ,@PreventMaintAshCleanInter
				   ,@HighSootCEL
				   ,@EngineFailureFluidsInExhaust 
				   ,@CleanReasonOther
				   ,@RoadHighway
				   ,@StartStop
				   ,@HighIdle
				   ,@DrivingTypeOther
				   ,@FirstCleaning
				   ,@VehicleTotalMileage
				   ,@VehicleTotalHours)
	
		SET @WorkOrderID	=  SCOPE_IDENTITY();
	END

	set @NewWorkOrderID = @WorkOrderID;

END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spWorkOrderUpsert] :: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH