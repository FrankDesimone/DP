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
			,sum(case when qapd.TestLine = 12 then qapd.PSI else 0 end) as PSI12
			,sum(case when qapd.TestLine = 1 then qapd.SpaceVelocity else 0 end) as SV1
			,sum(case when qapd.TestLine = 2 then qapd.SpaceVelocity else 0 end) as SV2
			,sum(case when qapd.TestLine = 3 then qapd.SpaceVelocity else 0 end) as SV3
			,sum(case when qapd.TestLine = 4 then qapd.SpaceVelocity else 0 end) as SV4
			,sum(case when qapd.TestLine = 5 then qapd.SpaceVelocity else 0 end) as SV5
			,sum(case when qapd.TestLine = 6 then qapd.SpaceVelocity else 0 end) as SV6
			,sum(case when qapd.TestLine = 7 then qapd.SpaceVelocity else 0 end) as SV7
			,sum(case when qapd.TestLine = 8 then qapd.SpaceVelocity else 0 end) as SV8
			,sum(case when qapd.TestLine = 9 then qapd.SpaceVelocity else 0 end) as SV9
			,sum(case when qapd.TestLine = 10 then qapd.SpaceVelocity else 0 end) as SV10
			,sum(case when qapd.TestLine = 11 then qapd.SpaceVelocity else 0 end) as SV11
			,sum(case when qapd.TestLine = 12 then qapd.SpaceVelocity else 0 end) as SV12
		from QAProcessData as qapd
		group by qapd.QAProcessID
	)
	select
		w.WorkOrderID
		,@ProcessID as ProcessID
        ,qap.MaxSpaceVelocity
        ,qap.MaxHertz
        ,ecd.SubstrateDiameter as Diameter
        ,ecd.SubstrateLength as [Length]
        ,qap.AirTemp 
        ,qap.BarometricPressure as BaroPress
        ,qap.BackPressure as BackPress
        ,qap.InletCell03
		,qap.InletCell06
		,qap.InletCell09
		,qap.InletCell12
		,qap.InletCellCenter
		,qap.Coefficient_a as a
        ,qap.Coefficient_b as b
        ,qap.Coefficient_c as c
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
        ,qapd.SV11
        ,qapd.SV12
        ,qapd.SV1
        ,qapd.SV2
        ,qapd.SV3
        ,qapd.SV4
        ,qapd.SV5
        ,qapd.SV6
        ,qapd.SV7
        ,qapd.SV8
        ,qapd.SV9
        ,qapd.SV10
        ,qapd.SV11
        ,qapd.SV12
	from WorkOrder as w
		left outer join QA as qa on w.WorkOrderID = qa.WorkOrderID
		left outer join QAProcess as qap on qa.QAlID = qap.QAID
		left outer join qapd on qap.QAProcessID = qapd.QAProcessID
		left outer join ECD as ecd on w.ECDID = ecd.ECDID
	where w.WorkOrderID = @WorkOrderID;
	
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