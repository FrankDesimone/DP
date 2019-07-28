CREATE PROCEDURE [dbo].[spQAProcessSave]
	@WorkOrderID as int
	,@ProcessID as int 
	,@AirTemp as FLOAT = null
	,@BarometricPressure as FLOAT = null
	,@BackPressure as FLOAT = null
	,@Coefficient_a as FLOAT = null
	,@Coefficient_b as FLOAT = null
	,@Coefficient_c as FLOAT = null
	,@PSI1 as FLOAT = null
	,@PSI2 as FLOAT = null
	,@PSI3 as FLOAT = null
	,@PSI4 as FLOAT = null
	,@PSI5 as FLOAT = null
	,@PSI6 as FLOAT = null
	,@PSI7 as FLOAT = null
	,@PSI8 as FLOAT = null
	,@PSI9 as FLOAT = null
	,@PSI10 as FLOAT = null
	,@PSI11 as FLOAT = null
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
	declare @True as bit = 1
		,@False as bit = 0;
	
	declare @QAID as int = null
		,@QAProcessID as int = null
		,@PSI as float
		,@TestLine as int = 0
		,@Fail as bit = @True;

	declare @d as table (TestLine int
		,PSI float
		,SpaceVelocity float);

	set @ErrorCode = 1;
	set @ErrorMsg = 'Unable to update quality';

	select @QAID = QA.QAID
		,@QAProcessID = qap.QAProcessID
	from QA
		left outer join QAProcess as qap on QA.QAID = qap.QAID
			and @ProcessID = qap.ProcessID
	where QA.WorkOrderID = @WorkOrderID;

	if @QAID is null or @ProcessID is null goto ExitProc;

	update qap set qap.AirTemp = @AirTemp
		,qap.BarometricPressure = @BarometricPressure
		,qap.BackPressure = @BackPressure
		,qap.Coefficient_a = @Coefficient_a
		,qap.Coefficient_b = @Coefficient_b
		,qap.Coefficient_c = @Coefficient_c
	from QAProcess as qap
	where qap.QAProcessID = @QAProcessID;

	if @@ROWCOUNT = 0
	begin
		insert into QAProcess 
			(QAID
			,ProcessID
			,AirTemp
			,BarometricPressure
			,BackPressure
			,Coefficient_a
			,Coefficient_b
			,Coefficient_c
			)
		values 
			(@QAID
			,@ProcessID
			,@AirTemp
			,@BarometricPressure
			,@BackPressure
			,@Coefficient_a
			,@Coefficient_b
			,@Coefficient_c
			);

		set @QAProcessID = SCOPE_IDENTITY();
	end

	insert into @d (TestLine, PSI)
	values (1, @PSI1)
		,(2, @PSI2)
		,(3, @PSI3)
		,(4, @PSI4)
		,(5, @PSI5)
		,(6, @PSI6)
		,(7, @PSI7)
		,(8, @PSI8)
		,(9, @PSI9)
		,(10, @PSI10)
		,(11, @PSI11);

	Declare d Cursor FAST_FORWARD FOR 
		select d.TestLine
			,d.PSI
		from @d as d;

	Open d;
	Fetch next from d into @TestLine, @PSI;
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		exec spQAProcessDataSave
			@QAProcessID = @QAProcessID
			,@TestLine = @TestLine
			,@PSI = @PSI

		Fetch next from d into @TestLine, @PSI;
	end

	CLOSE d;
	DEALLOCATE d;

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
		
	SELECT @ErrorMessage = 'spQAGet:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH