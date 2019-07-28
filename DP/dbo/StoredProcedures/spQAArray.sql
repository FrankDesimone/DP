CREATE PROCEDURE [dbo].[spQAArray]
	@WorkOrderID as int
	,@ProcessID as int 
	,@ECDMass as FLOAT = NULL
	,@InletCell12 as FLOAT = NULL
	,@InletCell03 as FLOAT = NULL
	,@InletCell06 as FLOAT = NULL
	,@InletCell09 as FLOAT = NULL
	,@InletCellCenter as FLOAT = NULL
	,@ErrorCode as INT = 0 OUTPUT
	,@ErrorMsg as VARCHAR(8000) = '' OUTPUT
AS
SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
	declare @True as bit = 1
		,@False as bit = 0;
	
	declare @QAID as int = null
		,@QAProcessID as int = null;
	
	set @ErrorCode = 1;
	set @ErrorMsg = 'Unable to update quality';

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
			);

		set @QAProcessID = SCOPE_IDENTITY();
	end

ExitProc:
	set @ErrorMsg = 'Record Saved';


COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION;

	DECLARE @ReportingProcedure VARCHAR(250) = ERROR_PROCEDURE()
	,@ErrorNumber INT = ERROR_NUMBER()
	,@ErrorLine INT = ERROR_LINE()
	,@ErrorMessage VARCHAR(500) = ERROR_MESSAGE()
	,@ErrorNote VARCHAR(500) = ERROR_MESSAGE();
		
	SELECT @ErrorMessage = '[spQAArray]:: ' 
			+ ERROR_PROCEDURE()
			+ ' Line: ' + CAST(ERROR_LINE() as VARCHAR(20))
			+  ' - ' + coalesce(@ErrorMessage , '') + ' Err #: ' + cast(ERROR_NUMBER() as varchar(8));

	EXEC  [dbo].[spExceptionAdd]  @ReportingProcedure ,@ErrorNumber,@ErrorLine ,@ErrorMessage,@ErrorNote;
END CATCH