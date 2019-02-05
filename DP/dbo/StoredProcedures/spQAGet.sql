CREATE PROCEDURE [dbo].[spQAGet]
	@WorkOrderID     INT  
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	set @ErrorCode = 0;
	set @ErrorMsg = '';


	select 
		e.[ECDID]
		,e.SerialNumber + ' / ' + e.[PartNumber] as ECD	
		,qa.QASootOnFaceID
		,qa.QAAshOnFaceID
		,qa.QAAshColorID
		,qa.QASubstrateID
		,qa.Coolant
		,qa.RedAsh
		,qa.USignalReceived
		,qa.ECDPinDropDepth
		,qa.CleanChannels
		,qa.TargetMaxSpaceVelocity
        ,qa.MaxHertz
		,e.SubstrateDiameter
		,e.SubstrateLength
	from WorkOrder as w
		inner join ECD as e on w.ECDID = e.ECDID
		left join QA as qa on  w.WorkOrderID = qa.WorkOrderID	
	where w.WorkOrderID = @WorkOrderID;
	
END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = 'spQAGet:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH