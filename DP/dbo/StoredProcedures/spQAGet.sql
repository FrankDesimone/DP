CREATE PROCEDURE [dbo].[spQAGet]
	@WorkOrderID     INT  
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	set @ErrorCode = 0;
	set @ErrorMsg = '';

	;with qap0 as
	(
		select qap.QualityControlID
			,qap.ECDMass
		from QualityControlProcess as qap
		where qap.ProcessID = 0
	)
	select qa.QASootOnFaceID
		,qa.QAAshOnFaceID
		,qa.QAAshColorID
		,qa.QASubstrateID
		,qa.QACoolantID
		,p.Process
		,0 as CleanChannels
	    ,qap.ECDMass as P0ECDMass
	    ,qap.ECDMass as P1ECDMass
	    ,qap.ECDMass as P2ECDMass
		,qap.InletCell12		as P0InletCell12 
		,qap.InletCell03		as P0InletCell03 
		,qap.InletCell06		as P0InletCell06 
		,qap.InletCell09		as P0InletCell09 
		,qap.InletCellCenter	as P0InletCellCenter
		,qap.InletCell12		as P1InletCell12 
		,qap.InletCell03		as P1InletCell03 
		,qap.InletCell06		as P1InletCell06 
		,qap.InletCell09		as P1InletCell09 
		,qap.InletCellCenter	as P1InletCellCenter
		,(case when coalesce(qap.ProcessID, 0) = 0 then null else (qap0.ECDMass - qap.ECDMass) end) as WeightLoss 
	from QualityControl as qa
		left outer join QualityControlProcess as qap on qa.QualityControlID = qap.QualityControlID
		left outer join Process as p on qap.ProcessID = p.ProcessID
		left outer join qap0 on qa.QualityControlID = qap0.QualityControlID
	where qa.WorkOrderID = @WorkOrderID;
	
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