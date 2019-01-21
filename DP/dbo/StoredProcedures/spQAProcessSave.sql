CREATE PROCEDURE [dbo as.[spQAProcessSave]
	@WorkOrderID as int
    ,@ProcessID as int 
    ,@ECDMass as FLOAT = NULL
    ,@InletCell12 as FLOAT = NULL
    ,@InletCell03 as FLOAT = NULL
    ,@InletCell06 as FLOAT = NULL
    ,@InletCell09 as FLOAT = NULL
    ,@InletCellCenter as FLOAT = NULL
	,@TargetVelocity as FLOAT = null
	,@MaxSpaceVelocity as FLOAT = null
	,@MaxHertz as FLOAT = null
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
    ,@PSI12 as FLOAT = null
    ,@SV1 as FLOAT = null
    ,@SV2 as FLOAT = null
    ,@SV3 as FLOAT = null
    ,@SV4 as FLOAT = null
    ,@SV5 as FLOAT = null
    ,@SV6 as FLOAT = null
    ,@SV7 as FLOAT = null
    ,@SV8 as FLOAT = null
    ,@SV9 as FLOAT = null
    ,@SV10 as FLOAT = null
    ,@SV11 as FLOAT = null
    ,@SV12 as FLOAT = null
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
	declare @QAID as int = null
		,@QAProcessID as int = null
		,@PSI as float
		,@SpaceVelocity as float
		,@TestLine as int = 0;

	declare @d as table (TestLine int
		,PSI float
		,SpaceVelocity float);

	set @ErrorCode = 0;
	set @ErrorMsg = '';

	select @QAID = QA.QAID
		,@QAProcessID = qap.QAProcessID
	from QA
		left outer join QAProcess as qap on QA.QAID = qap.QAID
			and @ProcessID = qap.ProcessID
	where QA.WorkOrderID = @WorkOrderID;

	if @QAID is null or @ProcessID is null goto ExitProc;

	update qap set qap.ECDMass = @ECDMass
		,qap.InletCell12 = @InletCell12
		,qap.InletCell03 = @InletCell03
		,qap.InletCell06 = @InletCell06
		,qap.InletCell09 = @InletCell09
		,qap.InletCellCenter = @InletCellCenter
		,qap.TargetVelocity = @TargetVelocity
		,qap.MaxSpaceVelocity = @MaxSpaceVelocity
		,qap.MaxHertz = @MaxHertz
		,qap.AirTemp = @AirTemp
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
			,ECDMass
			,InletCell12
			,InletCell03
			,InletCell06
			,InletCell09
			,InletCellCenter
			,TargetVelocity
			,MaxSpaceVelocity
			,MaxHertz
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
			,@ECDMass
			,@InletCell12
			,@InletCell03
			,@InletCell06
			,@InletCell09
			,@InletCellCenter
			,@TargetVelocity
			,@MaxSpaceVelocity
			,@MaxHertz
			,@AirTemp
			,@BarometricPressure
			,@BackPressure
			,@Coefficient_a
			,@Coefficient_b
			,@Coefficient_c
			);

		set @QAProcessID = SCOPE_IDENTITY();
	end

	insert into @d (TestLine, PSI, SpaceVelocity)
	values (1, @PSI1, @SV1)
		,(2, @PSI2, @SV2)
		,(3, @PSI3, @SV3)
		,(4, @PSI4, @SV4)
		,(5, @PSI5, @SV5)
		,(6, @PSI6, @SV6)
		,(7, @PSI7, @SV7)
		,(8, @PSI8, @SV8)
		,(9, @PSI9, @SV9)
		,(10, @PSI10, @SV10)
		,(11, @PSI11, @SV11)
		,(12, @PSI12, @SV12);

	Declare d Cursor FAST_FORWARD FOR 
		select d.TestLine
			,d.PSI
			,d.SpaceVelocity
		from @d as d;

	Open d;
	Fetch next from d into @TestLine, @PSI, @SpaceVelocity;
		
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		exec spQAProcessDataSave
			@QAProcessID = @QAProcessID
			,@TestLine = @TestLine
			,@PSI = @PSI
			,@SpaceVelocity = @SpaceVelocity;

		Fetch next from d into @TestLine, @PSI, @SpaceVelocity;
	end

	CLOSE wo;
	DEALLOCATE wo;
	
ExitProc:

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