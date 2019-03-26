﻿CREATE PROCEDURE [dbo].[spWorkOrderUpsert]
	@WorkOrderID INT = null
	,@SalesID int = null
	,@CompanyLocationID INT = null
	,@BillingCompanyID  INT = NULL
	,@ContactsID INT = NULL
	,@WorkOrderStatusID  INT 
	,@VehicleID  INT = NULL 
	,@EngineID  INT = NULL 
	,@ECDID INT  = null
	,@PreventMaintAshCleanInter  bit 
	,@HighSootCEL bit 
	,@EngineFailureFluidsInExhaust  bit
	,@CleanReasonOther  INT = NULL
	,@RoadHighway  bit 
	,@StartStop bit 
	,@HighIdle bit
	,@DrivingTypeOther  INT = NULL
	,@VehicleMileage  INT = NULL
	,@VehicleHours  INT  = NULL	
	,@NewWorkOrderID INT = NULL OUTPUT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	declare @Message as varchar(8000) = ''
		,@Fail as bit = @False;

	set @ErrorCode = 1;
	set @ErrorMsg = 'Unable to update company';
	set @NewWorkOrderID = NULL;

	if @CompanyLocationID is null
	begin
		set @Fail = @True;
		set @Message = 'Site Address must be entered';

		goto ExitProc;
	end

	
	IF @BillingCompanyID IS NULL
	BEGIN
		 select @BillingCompanyID = cl.CompanyID FROM CompanyLocations as cl where cl.CompanyLocationsID = @CompanyLocationID;
	END

	update s set s.ContactsID = @ContactsID
	from Sales as s
	where s.SalesID = @SalesID;

	UPDATE w
	set 
		w.[WorkOrderStatusID]				  = @WorkOrderStatusID
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
		,w.[VehicleMileage]						= @VehicleMileage
		,w.[VehicleHours]						= @VehicleHours
	FROM [dbo].[WorkOrder] as w
	where w.WorkOrderID = @WorkOrderID;


	if @@ROWCOUNT = 0
	begin
		if @SalesID is null
		begin
			insert into Sales (SalesNo,BillingCompanyID,CompanyLocationID,ContactsID)
			select cast(getdate() as nvarchar)
				,@BillingCompanyID
				,@CompanyLocationID
				,@ContactsID;

			set @SalesID = SCOPE_IDENTITY();

			update s set s.SalesNo = c.CompanyInitials + '-' + cast(s.SalesID as nvarchar)
			from Sales as s
				inner join Company as c on s.BillingCompanyID = c.CompanyID
			where s.SalesID = @SalesID;
		end


		INSERT INTO [dbo].[WorkOrder]
					([SalesID]
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
				   ,[VehicleMileage]
				   ,[VehicleHours])
			 VALUES
				   ( @SalesID
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
				   ,@VehicleMileage
				   ,@VehicleHours)
	
		SET @WorkOrderID	=  SCOPE_IDENTITY();
	END

	set @NewWorkOrderID = @WorkOrderID;

ExitProc:
	set @ErrorMsg = (case when @Fail = @False then 'Record Saved' else @Message end);
	set @ErrorCode = @Fail;

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