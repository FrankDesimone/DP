CREATE PROCEDURE [dbo].[spWorkOrderUpsert]
	@WorkOrderID INT = null
	,@SalesID int = null
	,@SalesStatusID int = 1
	,@CleaningLocationID as int = null
	,@CompanyID as int = null
	,@CompanyLocationID INT = null
	,@BillingCompanyID  INT = NULL
	,@Contact nvarchar(250) = NULL
	,@VehicleID  INT = NULL 
	,@EngineID  INT = NULL 
	,@ECDID INT = null
	,@PreventMaintAshCleanInter  bit 
	,@HighSootCEL bit 
	,@EngineFailureFluidsInExhaust  bit
	,@CleanReasonOther  INT = NULL
	,@RoadHighway  bit 
	,@StartStop bit 
	,@HighIdle bit
	,@DrivingTypeOther  INT = NULL
	,@Miles  real = NULL
	,@MPG  real = NULL
	,@Hours  real = NULL
	,@HPG  real = NULL
	,@TrackingNo as nvarchar(250) = null
	,@LegacyJobID  as nvarchar(250) = null
	,@NewWorkOrderID INT = NULL OUTPUT
	,@NewSalesID int = null output
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	declare  @True as bit = 1
		,@False as bit = 0;

	declare @Message as varchar(8000) = null
		,@Fail as bit = @False;

	set @ErrorCode = 1;
	set @ErrorMsg = 'Unable to update work order';
	set @NewWorkOrderID = NULL;

	if EXISTS (select SalesStatusID from [SalesStatus] where @SalesStatusID = SalesStatusID  and Locked = 1)
	BEGIN

		update s set s.SalesStatusID =@SalesStatusID
			from Sales as s
			where s.SalesID = @SalesID
		and s.SalesStatusID <> @SalesStatusID

		if @SalesID is not NULL
		begin
			set @Fail = @True;
			set @Message = 'WorkOrder is now Locked';

			goto ExitProc;
		END
	end




	if @BillingCompanyID is null
	begin
		set @Fail = @True;
		set @Message = 'Billing Company must be selected';

		goto ExitProc;
	end

	if @CompanyID is null
	begin
		set @Fail = @True;
		set @Message = 'Customer Information must be selected';

		goto ExitProc;
	end

	if @CompanyLocationID is null
	begin
		set @Fail = @True;
		set @Message = 'Site Address must be selected';

		goto ExitProc;
	end

	if @ECDID is null
	begin
		set @Message = 'ECU Information must be selected';
	end

	update s set s.Contact = @Contact
		,s.TrackingNo = @TrackingNo
		,s.SalesStatusID = @SalesStatusID
	from Sales as s
	where s.SalesID = @SalesID;

	UPDATE w
	set 
		w.[VehicleID] = @VehicleID
		,w.[EngineID] = @EngineID
		,w.[PreventMaintAshCleanInter] = @PreventMaintAshCleanInter
		,w.[HighSootCEL] = @HighSootCEL
		,w.[EngineFailureFluidsInExhaust] = @EngineFailureFluidsInExhaust
		,w.[CleaningReasonID] = @CleanReasonOther
		,w.[RoadHighway] = @RoadHighway
		,w.[StartStop] = @StartStop
		,w.[HighIdle] = @HighIdle
		,w.[DrivingTypeID] = @DrivingTypeOther
		,w.[Miles] = @Miles
		,w.[MPG]= @MPG
		,w.[Hours]=@Hours 
		,w.[HPG]=@HPG
	FROM [dbo].[WorkOrder] as w
	where w.WorkOrderID = @WorkOrderID;

	if @@ROWCOUNT = 0
	begin
		if @SalesID is null
		begin
			insert into Sales (SalesNo,CleaningLocationID, BillingCompanyID,CompanyID,CompanyLocationsID)
			select cast(getdate() as nvarchar)
				,@CleaningLocationID
				,@BillingCompanyID
				,@CompanyID
				,@CompanyLocationID;

			set @SalesID = SCOPE_IDENTITY();

			update s set s.SalesNo = c.CompanyInitials + '-' + cast(s.SalesID as nvarchar)
			from Sales as s
				inner join Company as c on s.BillingCompanyID = c.CompanyID
			where s.SalesID = @SalesID;
		end

		update s set s.LegacyJobID = @LegacyJobID
			,s.TrackingNo = @TrackingNo
			,s.Contact = @Contact
		from Sales as s
		where s.SalesID = @SalesID;

		INSERT INTO [dbo].[WorkOrder]
					([SalesID]
				   ,[VehicleID]
				   ,[EngineID]
				   ,[PreventMaintAshCleanInter]
				   ,[HighSootCEL]
				   ,[EngineFailureFluidsInExhaust]
				   ,[CleaningReasonID]
				   ,[RoadHighway]
				   ,[StartStop]
				   ,[HighIdle]
				   ,[DrivingTypeID]
					,[Miles] 
					,[MPG]
					,[Hours] 
					,[HPG]		   
				   )
			 VALUES
				   ( @SalesID
				   ,@VehicleID
				   ,@EngineID
				   ,@PreventMaintAshCleanInter
				   ,@HighSootCEL
				   ,@EngineFailureFluidsInExhaust 
				   ,@CleanReasonOther
				   ,@RoadHighway
				   ,@StartStop
				   ,@HighIdle
				   ,@DrivingTypeOther
					,@Miles
					,@MPG
					,@Hours 
					,@HPG)
	
		SET @WorkOrderID	=  SCOPE_IDENTITY();
	END

	set @NewWorkOrderID = @WorkOrderID;
	set @NewSalesID = @SalesID;

ExitProc:
	set @ErrorMsg = coalesce(@Message, 'Record Saved');
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