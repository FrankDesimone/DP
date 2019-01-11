CREATE PROCEDURE [dbo].[spQAFlowProcessGet]
	@WorkOrderID     INT
	,@ProcessID INT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	set @ErrorCode = 0;
	set @ErrorMsg = '';

	select
		w.WorkOrderID
		,@ProcessID  as ProcessID
        ,0 as MaxSpaceVelocity
        ,0 as MaxHertz
        ,ecd.SubstrateDiameter as Diameter
        ,ecd.SubstrateLength as [Length]
        ,0 as AirTemp
        ,0 as BaroPress
        ,0 as BackPress
        ,0 as a
        ,0 as b
        ,0 as c
        ,0 as PSI1        
		,0 as PSI2        
		,0 as PSI3        
		,0 as PSI4        
		,0 as PSI5        
		,0 as PSI6
		,0 as PSI7        
		,0 as PSI8        
		,0 as PSI9		
		,0 as PSI10        
		,0 as PSI11
		,0 as SV1        
		,0 as SV2        
		,0 as SV3        
		,0 as SV4        
		,0 as SV5        
		,0 as SV6
		,0 as SV7        
		,0 as SV8        
		,0 as SV9		
		,0 as SV10        
		,0 as SV11
	from WorkOrder as w
		left outer join QualityControl as qa on w.WorkOrderID = qa.WorkOrderID
		left outer join ECD as ecd on w.ECDID = ecd.ECDID
	where w.WorkOrderID = @WorkOrderID;
	
END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = 'spQAFlowProcessGet:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH