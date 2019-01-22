CREATE PROCEDURE [dbo].[spQASave]
	@WorkOrderID as int
    ,@QASootOnFaceID as int = null
    ,@QAAshOnFaceID as int = null
	,@QAAshColorID as int = null
    ,@QASubstrateID as int = null
    ,@Coolant as  BIT = 0
    ,@RedAsh as BIT = 0
    ,@USignalReceived as BIT = 0 
    ,@ECDPinDropDepth as BIT = 0
    ,@CleanChannels as  FLOAT  = null
	,@TargetMaxSpaceVelocity as FLOAT = null
	,@MaxHertz as FLOAT = null
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
	declare @True as bit = 1
		,@False as bit = 0;

	declare @QualityControlID as int = null;

	set @ErrorCode = 0;
	set @ErrorMsg = '';

	set @Coolant = coalesce(@Coolant, @False);
	set @RedAsh = coalesce(@RedAsh, @False);
	set @USignalReceived = coalesce(@USignalReceived, @False);
	set @ECDPinDropDepth = coalesce(@ECDPinDropDepth, @False);

	update qa set qa.QASootOnFaceID = @QASootOnFaceID
		,qa.QAAshOnFaceID = @QAAshOnFaceID
		,qa.QAAshColorID = @QAAshColorID
		,qa.QASubstrateID = @QASubstrateID
		,qa.Coolant = @Coolant
		,qa.RedAsh = @RedAsh
		,qa.USignalReceived = @USignalReceived
		,qa.ECDPinDropDepth = @ECDPinDropDepth
		,qa.CleanChannels = @CleanChannels
		,qa.TargetMaxSpaceVelocity = @TargetMaxSpaceVelocity
		,qa.MaxHertz = @MaxHertz
	from QA as qa
	where qa.WorkOrderID = @WorkOrderID;

	if @@ROWCOUNT = 0
	begin
		insert into QA (WorkOrderID, QASootOnFaceID, QAAshOnFaceID, QAAshColorID, QASubstrateID, Coolant, RedAsh, USignalReceived, ECDPinDropDepth, CleanChannels,TargetMaxSpaceVelocity,MaxHertz)
		values (@WorkOrderID, @QASootOnFaceID, @QAAshOnFaceID, @QAAshColorID, @QASubstrateID, @Coolant, @RedAsh, @USignalReceived, @ECDPinDropDepth, @CleanChannels,@TargetMaxSpaceVelocity,@MaxHertz);
	end

	select @QualityControlID = qc.QAID
	from QA as qc
	where qc.WorkOrderID = @WorkOrderID;

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