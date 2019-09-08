CREATE PROCEDURE [dbo].[spQASave]
	@WorkOrderID as int
	,@QASootOnFaceID as int = null
	,@QAAshOnFaceID as int = null
	,@QAAshColorID as int = null
	,@QAOutletColorID as int = null
	,@QABreachChannelsID as int = null
	,@QASubstrateCrakingID as int = null
	,@QASubstrateOveralConditionID as INT = NULL
	,@Coolant as  BIT = 0
	,@RedAsh as BIT = 0
	,@USignalReceived as BIT = 0 
	,@PinTest as BIT = 0 
	,@EngineEGRCoolant as BIT = 0
	,@WearCorrosion as BIT = 0 
	,@FuelOil as BIT = 0 
	,@ContaminantsOther as NVARCHAR (255)  =NULL
	,@CleanChannels as  FLOAT  = null
	,@Summary as nvarchar(4000) = null
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
	declare @True as bit = 1
		,@False as bit = 0;

	declare @QualityControlID as int = null
		,@Fail as bit = @True;

	set @ErrorCode = 1;
	set @ErrorMsg = 'Unable to update quality';

	set @Coolant = coalesce(@Coolant, @False);
	set @RedAsh = coalesce(@RedAsh, @False);
	set @USignalReceived = coalesce(@USignalReceived, @False);
	set @PinTest = coalesce(@PinTest,@False);

	declare @TargetMaxSpaceVelocity as float = 110000
		,@MaxHertz as float = 60;
	
	update qa set qa.QASootOnFaceID = @QASootOnFaceID
		,qa.QAAshOnFaceID = @QAAshOnFaceID
		,qa.QAAshColorID = @QAAshColorID
		,qa.QAOutletColorID = @QAOutletColorID
		,qa.QABreachChannelsID = @QABreachChannelsID
		,qa.QASubstrateCrakingID = @QASubstrateCrakingID
		,qa.QASubstrateOveralConditionID =@QASubstrateOveralConditionID
		,qa.Coolant = @Coolant
		,qa.RedAsh = @RedAsh
		,qa.USignalReceived = @USignalReceived
		,qa.PinTest=@PinTest
		,qa.EngineEGRCoolant = @EngineEGRCoolant
		,qa.WearCorrosion = @WearCorrosion 
		,qa.FuelOil = @FuelOil 
		,qa.ContaminantsOther = @ContaminantsOther 
		,qa.CleanChannels = @CleanChannels
		,qa.TargetMaxSpaceVelocity = @TargetMaxSpaceVelocity
		,qa.MaxHertz = @MaxHertz
		,qa.Summary = @Summary
	from QA as qa
	where qa.WorkOrderID = @WorkOrderID;

	if @@ROWCOUNT = 0
	begin
		insert into QA (WorkOrderID, QASootOnFaceID, QAAshOnFaceID, QAAshColorID, QAOutletColorID, QABreachChannelsID, QASubstrateCrakingID, QASubstrateOveralConditionID, Coolant, RedAsh, USignalReceived, EngineEGRCoolant ,  WearCorrosion ,  FuelOil , PinTest,  ContaminantsOther,   CleanChannels,TargetMaxSpaceVelocity,MaxHertz, Summary)
		values (@WorkOrderID, @QASootOnFaceID, @QAAshOnFaceID, @QAAshColorID, @QAOutletColorID, @QABreachChannelsID, @QASubstrateCrakingID,  @QASubstrateOveralConditionID, @Coolant, @RedAsh, @USignalReceived, @EngineEGRCoolant  ,@WearCorrosion  ,@FuelOil  ,@PinTest, @ContaminantsOther,  @CleanChannels,@TargetMaxSpaceVelocity,@MaxHertz, @Summary);
	end																																			   
	
	select @QualityControlID = qc.QAID																												
	from QA as qc
	where qc.WorkOrderID = @WorkOrderID;

	set @Fail = @False;
	
ExitProc:
	set @ErrorMsg = (case when @Fail = @False then 'Record Saved' else @ErrorMsg end);
	set @ErrorCode = @Fail;

COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;

	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = 'spQASave:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH