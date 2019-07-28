CREATE PROCEDURE [dbo].[spQAProcessGet]
	@WorkOrderID as INT
	,@ProcessID as INT
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
	set @ErrorCode = 0;
	set @ErrorMsg = '';

	;with qapd as
	(
		select qapd.QAProcessID
			,sum(case when qapd.TestLine = 1 then qapd.PSI else 0 end) as PSI1
			,sum(case when qapd.TestLine = 2 then qapd.PSI else 0 end) as PSI2
			,sum(case when qapd.TestLine = 3 then qapd.PSI else 0 end) as PSI3
			,sum(case when qapd.TestLine = 4 then qapd.PSI else 0 end) as PSI4
			,sum(case when qapd.TestLine = 5 then qapd.PSI else 0 end) as PSI5
			,sum(case when qapd.TestLine = 6 then qapd.PSI else 0 end) as PSI6
			,sum(case when qapd.TestLine = 7 then qapd.PSI else 0 end) as PSI7
			,sum(case when qapd.TestLine = 8 then qapd.PSI else 0 end) as PSI8
			,sum(case when qapd.TestLine = 9 then qapd.PSI else 0 end) as PSI9
			,sum(case when qapd.TestLine = 10 then qapd.PSI else 0 end) as PSI10
			,sum(case when qapd.TestLine = 11 then qapd.PSI else 0 end) as PSI11

		from QAProcessData as qapd
		group by qapd.QAProcessID
	)
	select
		w.WorkOrderID
		,@ProcessID as ProcessID
		,qap.AirTemp 
		,qap.BarometricPressure 
		,qap.BackPressure
		,qap.ECDMass
		,qap.InletCell03
		,qap.InletCell06
		,qap.InletCell09
		,qap.InletCell12
		,qap.InletCellCenter
		,qap.Coefficient_a 
		,qap.Coefficient_b 
		,qap.Coefficient_c 
		,qapd.PSI1
		,qapd.PSI2
		,qapd.PSI3
		,qapd.PSI4
		,qapd.PSI5
		,qapd.PSI6
		,qapd.PSI7
		,qapd.PSI8
		,qapd.PSI9
		,qapd.PSI10
		,qapd.PSI11
	from WorkOrder as w
		inner join QA as qa on w.WorkOrderID = qa.WorkOrderID
		inner join QAProcess as qap on qa.QAID = qap.QAID
		left outer join qapd on qap.QAProcessID = qapd.QAProcessID
	where w.WorkOrderID = @WorkOrderID
		and qap.ProcessID = @ProcessID;
	
END TRY

BEGIN CATCH
	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spQAProcessGet]:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH